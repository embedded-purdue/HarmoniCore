from functools import partial
from pathlib import Path
import librosa
import numpy as np
import matplotlib.pyplot as plt
import soundfile as sf
import pytsmod as tsm
from constants2 import SEMITONES_IN_OCTAVE, VOCALS_FILE, PLOT_RESULTS, CORRECTION_METHOD, SCALE, SR
from constants2 import fmin, fmax, frame_length, hop_length, win_length
from constants2 import pitch_median_filter_size, pitch_smooth_window, pitch_gaussian_sigma
from constants2 import note_change_threshold, pitch_quantization_cents, transition_samples
from constants2 import tdpsola_hop_size, tdpsola_win_size, max_pitch_shift_ratio
from constants2 import pitch_smooth_passes, pitch_smooth_pass_window, fade_duration_sec
from constants2 import target_rms, target_peak, autotune_strength, enable_flat_pitch_regions
from yin import yin


def degrees_from(scale: str):
    """Return the pitch classes (degrees) that correspond to the given scale"""
    degrees = librosa.key_to_degrees(scale)
    degrees = np.concatenate((degrees, [degrees[0] + SEMITONES_IN_OCTAVE]))
    return degrees


def closest_pitch(f0):
    """Round the given pitch values to the nearest MIDI note numbers"""
    midi_note = np.around(librosa.hz_to_midi(f0))
    nan_indices = np.isnan(f0)
    midi_note[nan_indices] = np.nan
    return librosa.midi_to_hz(midi_note)


def closest_pitch_from_scale(f0, scale):
    """Return the pitch closest to f0 that belongs to the given scale"""
    if np.isnan(f0):
        return np.nan
    degrees = degrees_from(scale)
    midi_note = librosa.hz_to_midi(f0)
    degree = midi_note % SEMITONES_IN_OCTAVE
    degree_id = np.argmin(np.abs(degrees - degree))
    degree_difference = degree - degrees[degree_id]
    midi_note -= degree_difference
    return librosa.midi_to_hz(midi_note)


def aclosest_pitch_from_scale(f0, scale):
    """Map each pitch in the f0 array to the closest pitch belonging to the given scale."""
    sanitized_pitch = np.zeros_like(f0)
    for i in np.arange(f0.shape[0]):
        sanitized_pitch[i] = closest_pitch_from_scale(f0[i], scale)
    
    if pitch_median_filter_size > 0:
        kernel_size = pitch_median_filter_size
        half_kernel = kernel_size // 2
        smoothed_sanitized_pitch = sanitized_pitch.copy()
        
        for i in range(half_kernel, len(sanitized_pitch) - half_kernel):
            window = sanitized_pitch[i-half_kernel:i+half_kernel+1]
            valid_values = window[~np.isnan(window)]
            if len(valid_values) > 0:
                smoothed_sanitized_pitch[i] = np.median(valid_values)
        
        smoothed_sanitized_pitch[np.isnan(smoothed_sanitized_pitch)] = \
            sanitized_pitch[np.isnan(smoothed_sanitized_pitch)]
        
        return smoothed_sanitized_pitch
    else:
        return sanitized_pitch


def autotune(audio, sr, correction_function, plot=False):
    """Apply autotune to audio using pitch detection, correction, and resynthesis."""
    f0 = yin(audio)
    
    nan_mask = np.isnan(f0)
    if np.any(nan_mask):
        valid_indices = np.where(~nan_mask)[0]
        if len(valid_indices) > 1:
            f0[nan_mask] = np.interp(np.where(nan_mask)[0], valid_indices, f0[valid_indices])
        else:
            f0[nan_mask] = fmin * 2
    
    corrected_f0 = correction_function(f0)
    
    nan_mask = np.isnan(corrected_f0)
    if np.any(nan_mask):
        valid_indices = np.where(~nan_mask)[0]
        if len(valid_indices) > 1:
            corrected_f0[nan_mask] = np.interp(np.where(nan_mask)[0], valid_indices, corrected_f0[valid_indices])
        else:
            corrected_f0[nan_mask] = f0[nan_mask]
    
    if pitch_smooth_passes > 0 and pitch_smooth_pass_window > 0:
        valid_mask = (corrected_f0 > 0) & ~np.isnan(corrected_f0)
        if np.any(valid_mask):
            for _ in range(pitch_smooth_passes):
                smooth_window = pitch_smooth_pass_window
                kernel = np.ones(smooth_window) / smooth_window
                padded = np.pad(corrected_f0, (smooth_window//2, smooth_window//2), mode='edge')
                smoothed = np.convolve(padded, kernel, mode='valid')
                corrected_f0 = smoothed
    
    valid_mask = (f0 > 0) & (corrected_f0 > 0) & ~np.isnan(f0) & ~np.isnan(corrected_f0)
    if np.any(valid_mask):
        pitch_ratio = np.ones_like(corrected_f0)
        pitch_ratio[valid_mask] = corrected_f0[valid_mask] / f0[valid_mask]
        pitch_ratio = np.clip(pitch_ratio, 1/max_pitch_shift_ratio, max_pitch_shift_ratio)
        corrected_f0[valid_mask] = f0[valid_mask] * pitch_ratio[valid_mask]
    
    if plot:
        stft = librosa.stft(audio, n_fft=frame_length, hop_length=hop_length)
        time_points = librosa.times_like(stft, sr=sr, hop_length=hop_length)
        log_stft = librosa.amplitude_to_db(np.abs(stft), ref=np.max)
        fig, ax = plt.subplots()
        img = librosa.display.specshow(
            log_stft, x_axis='time', y_axis='log',
            ax=ax, sr=sr, hop_length=hop_length, fmin=fmin, fmax=fmax
        )
        fig.colorbar(img, ax=ax, format="%+2.f dB")
        ax.plot(time_points, f0, label='original pitch', color='cyan', linewidth=2)
        ax.plot(time_points, corrected_f0, label='corrected pitch', color='orange', linewidth=1)
        ax.legend(loc='upper right')
        plt.ylabel('Frequency [Hz]')
        plt.xlabel('Time [M:SS]')
        plt.savefig('pitch_correction_constants2.png', dpi=300, bbox_inches='tight')
    
    pitch_corrected = tsm.tdpsola(
        audio, int(sr), f0, corrected_f0, 1, 
        p_hop_size=tdpsola_hop_size, 
        p_win_size=tdpsola_win_size
    )
    
    fade_samples = int(fade_duration_sec * sr)
    if len(pitch_corrected) > 2 * fade_samples:
        fade_in = np.linspace(0, 1, fade_samples)
        fade_out = np.linspace(1, 0, fade_samples)
        pitch_corrected[:fade_samples] *= fade_in
        pitch_corrected[-fade_samples:] *= fade_out
    
    return pitch_corrected


def main():
    """Load audio, apply autotune correction, normalize volume, and save the result."""
    filepath = Path(VOCALS_FILE)

    y, sr = librosa.load(str(filepath), sr=SR, mono=True)

    if (SR != sr):
        print("CHANGE SR")

    if CORRECTION_METHOD == "closest":
        correction_function = closest_pitch
    else:
        correction_function = partial(aclosest_pitch_from_scale, scale=SCALE)

    pitch_corrected_y = autotune(y, sr, correction_function, PLOT_RESULTS)

    current_rms = np.sqrt(np.mean(pitch_corrected_y**2))
    
    if current_rms > 0:
        gain = target_rms / current_rms
        pitch_corrected_y = pitch_corrected_y * gain
    
    current_peak = np.abs(pitch_corrected_y).max()
    if current_peak > target_peak * 1.05:
        peak_gain = target_peak / current_peak
        pitch_corrected_y = pitch_corrected_y * peak_gain
    
    outpath = filepath.parent / (filepath.stem + "_python_pitch_corrected" + filepath.suffix)
    sf.write(str(outpath), pitch_corrected_y, sr)
    print(f"Saved corrected audio to {outpath}")

if __name__=='__main__':
    main()
