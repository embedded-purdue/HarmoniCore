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
from constants import SEMITONES_IN_OCTAVE, VOCALS_FILE, PLOT_RESULTS, CORRECTION_METHOD, SCALE, SR
from constants import fmin, fmax, frame_length, hop_length, win_length

###
#CONSTANTS
####

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


def main():
    filepath = Path(VOCALS_FILE)

    # Load audio
    y, sr = librosa.load(str(filepath), sr=None, mono=False)

    if y.ndim > 1:
        y = y[0, :]

    y_orig=y
    y = np.concatenate((np.zeros(frame_length-hop_length), y))
    # Autotune
    if (SR != sr):
        print("CHANGE SR")
    f0 = yin(y)
    # Choose correction method
    if CORRECTION_METHOD == "closest":
        corrected_f0 = closest_pitch(f0)
    else:
        corrected_f0 = aclosest_pitch_from_scale(f0, SCALE)
    
    #pitch_corrected_y = psola(x=y, sr=int(SR), src_f0=f0, alpha=1, tgt_f0=corrected_f0, p_hop_size=hop_length, p_win_size=frame_length)
    pitch_corrected_y =  psola(y, sample_rate=SR, target_pitch=corrected_f0, fmin=fmin, fmax=fmax)
    pitch_corrected_y = []
    for i in range(len(y_orig)//hop_length):
        #temp  = []
        temp = librosa.effects.pitch_shift(y[i:i+frame_length], sr=sr, n_steps=corrected_f0[i]/f0[i])
        pitch_corrected_y = np.concatenate((pitch_corrected_y, temp[i:i+hop_length]))
    # Save output
    outpath = filepath.parent / (filepath.stem + "_pitch_corrected" + filepath.suffix)
    sf.write(str(outpath), pitch_corrected_y, sr)
    print(f"Saved corrected audio to {outpath}")

    # Save cleaned audio
    sf.write("voice_cleaned.wav", pitch_corrected_y, sr)

if __name__=='__main__':
    main()