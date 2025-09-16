from functools import partial
from pathlib import Path
import librosa
import numpy as np
import matplotlib.pyplot as plt
import soundfile as sf
from scipy.io import wavfile
import scipy.signal as sig
from yin import yin
from psola import psola
import pytsmod as tsm


SEMITONES_IN_OCTAVE = 12

# ----------------------
# Hardcoded parameters
# ----------------------
VOCALS_FILE = r"C:\Users\nsvp2\OneDrive\Desktop\HarmoniCore\wav\teenagefever.wav"   # Path to your input file
PLOT_RESULTS = False                       # Whether to plot results
CORRECTION_METHOD = "scale"               # "closest" or "scale"
SCALE = "D:maj"                           # Used only if CORRECTION_METHOD == "scale"
# ----------------------


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
    smoothed_sanitized_pitch = sig.medfilt(sanitized_pitch, kernel_size=11)
    smoothed_sanitized_pitch[np.isnan(smoothed_sanitized_pitch)] = \
        sanitized_pitch[np.isnan(smoothed_sanitized_pitch)]
    return smoothed_sanitized_pitch


def autotune(audio, sr, correction_function, plot=False):
    frame_length = 2048
    hop_length = frame_length // 4
    fmin = librosa.note_to_hz('C2')
    fmax = librosa.note_to_hz('C7')

    f0 = yin(
        audio, frame_length=frame_length, hop_length=hop_length,
        sr=sr, fmin=fmin, fmax=fmax
    )

    corrected_f0 = correction_function(f0)

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
        plt.savefig('pitch_correction.png', dpi=300, bbox_inches='tight')

    return psola(audio, sample_rate=int(sr),
                         target_pitch=corrected_f0, fmin=fmin, fmax=fmax)
    # return tsm.tdpsola(audio, int(sr), f0, corrected_f0, 1, p_hop_size=hop_length, p_win_size=frame_length)

def main():
    filepath = Path(VOCALS_FILE)

    # Load audio
    y, sr = librosa.load(str(filepath), sr=None, mono=False)

    if y.ndim > 1:
        y = y[0, :]

    # Choose correction method
    if CORRECTION_METHOD == "closest":
        correction_function = closest_pitch
    else:
        correction_function = partial(aclosest_pitch_from_scale, scale=SCALE)

    # Autotune
    pitch_corrected_y = autotune(y, sr, correction_function, PLOT_RESULTS)

    # Save output
    outpath = filepath.parent / (filepath.stem + "_pitch_corrected" + filepath.suffix)
    sf.write(str(outpath), pitch_corrected_y, sr)
    print(f"Saved corrected audio to {outpath}")

    # Save cleaned audio
    sf.write("voice_cleaned.wav", pitch_corrected_y, sr)

if __name__=='__main__':
    main()