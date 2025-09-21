# import numpy as np
# import warnings
# from warnings import warn

# def win(win_type='hann', win_size=4096, zero_pad=0):
#     """Generate diverse type of window function"""
#     if win_type == 'hann':
#         win = np.hanning(win_size)
#     elif win_type == 'sin':
#         win = np.sin(np.pi * np.arange(win_size) / (win_size - 1))
#     else:
#         raise Exception("Please use the valid window type. (hann, sin)")

#     win = np.pad(win, zero_pad // 2, 'constant')
#     return win

# def _target_f0_to_beta(x, pitch_mark, source_f0, target_f0):
#     """Modify target_f0 to continuous beta, a time-varying pitch-shifting rate."""
#     beta = np.zeros(pitch_mark.size)
#     for i in range(beta.size):
#         idx = int(round(pitch_mark[i] * source_f0.size / x.size))
#         idx = max(0, min(idx, source_f0.size - 1))

#         if (not target_f0[idx] == 0) and (not source_f0[idx] == 0):
#             beta[i] = target_f0[idx] / source_f0[idx]
#         else:
#             beta[i] = 1

#     return beta

# def _find_pitch_marks(x, sr, f0, hop_size, win_size):
#     """Find pitch marks for TD-PSOLA."""
#     m = np.array([0])
    
#     p0 = np.round(sr / f0)
#     p0[f0 == 0] = p0[np.where(f0!=0)[0][0]] if np.any(f0!=0) else 120

#     search_up_lim = int(p0[0])
#     last_m = 0

#     for i in range(f0.size):
#         if i == 0:
#             loc = np.argmax(x[: search_up_lim])
#             local_m = np.array([loc])
#         else:
#             search_up_lim = search_up_lim + p0[i]
#             local_m = np.array([last_m + p0[i]])

#         while search_up_lim + p0[i] <= win_size + i * hop_size - 1:
#             search_up_lim = search_up_lim + p0[i]
#             local_m = np.append(local_m, local_m[-1] + p0[i])

#         m = np.append(m, local_m)
#         last_m = local_m[-1]

#     m = np.sort(m)
#     m = np.unique(m)
#     m = m[1:]

#     return m.astype(int)

# def psola(x, sr, src_f0, tgt_f0, alpha=1,
#             win_type='hann', p_hop_size=441, p_win_size=1470):
#     """Modify length and pitch of the audio sequnce using TD-PSOLA algorithm."""
    
#     # Input validation is now for 1D arrays only
#     if x.ndim != 1:
#         raise ValueError("Input audio must be a 1D array (mono).")
#     if src_f0.ndim != 1:
#         raise ValueError("Source f0 must be a 1D array.")
#     if tgt_f0.ndim != 1:
#         raise ValueError("Target f0 must be a 1D array.")

#     min_f0 = src_f0[np.nonzero(src_f0)].min() if np.any(src_f0) else 100
#     pad_len = int(np.ceil(sr / min_f0)) + p_win_size

#     output_length = int(np.ceil(x.size * alpha))
    
#     # Core PSOLA logic for a single channel
#     x_chan = x
#     src_f0_chan = src_f0
#     src_f0_chan[np.isnan(src_f0_chan)] = 0
#     pm_chan = _find_pitch_marks(x_chan, sr, src_f0_chan, p_hop_size, p_win_size)
#     pitch_period = np.diff(pm_chan)

#     tgt_f0_chan = tgt_f0
#     beta_seq = _target_f0_to_beta(x_chan, pm_chan, src_f0_chan, tgt_f0_chan)

#     if pm_chan.size > 0 and pm_chan[0] <= pitch_period[0]:
#         pm_chan = pm_chan[1:]
#         pitch_period = pitch_period[1:]
#         beta_seq = beta_seq[1:]

#     if pm_chan.size > 0 and pm_chan[-1] + pitch_period[-1] > x_chan.size:
#         pm_chan = pm_chan[:-1]
#     else:
#         pitch_period = np.append(pitch_period, pitch_period[-1])
#         beta_seq = np.append(beta_seq, beta_seq[-1])

#     output_length = int(np.ceil(x_chan.size * alpha))
#     x_chan = np.pad(x_chan, (pad_len, pad_len), 'constant')
#     y_chan = np.zeros(output_length + 2 * pad_len)
#     ow = np.zeros(y_chan.shape)
    
#     if pitch_period.size > 0:
#         tk = pitch_period[0] + 1
#     else:
#         # Handle the edge case of no pitch periods found
#         return np.zeros(output_length)

#     while np.round(tk) < output_length:
#         i = min(np.argmin(np.abs(alpha * pm_chan - tk)), pitch_period.size - 1)
#         pit = pitch_period[i]
#         win_func = win(win_type=win_type, win_size=2 * pit + 1)
        
#         st = pm_chan[i] - pit
#         en = pm_chan[i] + pit
#         gr = x_chan[int(st + pad_len): int(en + pad_len) + 1] * win_func
        
#         ini_gr = int(round(tk)) - pit + pad_len
#         end_gr = int(round(tk)) + pit + pad_len
        
#         y_chan[ini_gr: end_gr + 1] = y_chan[ini_gr: end_gr + 1] + gr
#         ow[ini_gr: end_gr + 1] = ow[ini_gr: end_gr + 1] + win_func
#         tk = tk + pit / beta_seq[i]
        
#     ow[ow < 1e-3] = 1
#     y_chan = y_chan / ow
#     y_chan = y_chan[pad_len:]
#     y_chan = y_chan[: output_length]
#     y = y_chan

#     return y

import tempfile
import numpy as np
import os
import soundfile as sf
from parselmouth import Data, praat, Sound

def psola(audio, sample_rate, target_pitch, fmin, fmax):
    """
    Performs pitch shifting on an audio signal using Praat's PSOLA algorithm.
    This function combines the logic of saving audio, creating a Praat
    manipulation object, writing a pitch tier, and resynthesizing the audio
    into a single, cohesive process.

    Arguments
    ---------
    audio : np.array(shape=(samples,))
        The speech signal to process.
    sample_rate : int
        The audio sampling rate in Hz.
    target_pitch : np.array(shape=(frames,))
        The target pitch contour in Hz. Unvoiced sections should be marked
        with np.nan.
    fmin : int
        The minimum allowable frequency for pitch analysis in Hz.
    fmax : int
        The maximum allowable frequency for pitch analysis in Hz.

    Returns
    -------
    shifted_audio : np.array(shape=(samples,))
        The pitch-shifted audio signal.
    """
    # Create a temporary directory to store intermediate files
    with tempfile.TemporaryDirectory() as tmpdir:
        # Step 1: Prepare the target pitch contour for Praat
        # Create a copy to avoid modifying the original array
        pitch_for_praat = np.copy(target_pitch)
        # Convert np.nan values (unvoiced frames) to 0, which Praat understands
        pitch_for_praat[np.isnan(pitch_for_praat)] = 0.0

        # Step 2: Write the target pitch tier to a temporary file in Praat's format
        pitch_file = os.path.join(tmpdir, 'pitch.txt')
        duration = float(len(audio)) / sample_rate
        times = np.linspace(0.0, duration, len(pitch_for_praat))

        with open(pitch_file, 'w') as file:
            # Write the required Praat header for a PitchTier object
            file.write('File type = "ooTextFile"\nObject class = "PitchTier"\n\n')
            # Write the start and end of the audio file duration-
            # Write the number of voiced frames (non-zero pitch values)
            file.write(str(np.sum(pitch_for_praat > 0)) + '\n')
            # Write the time points and corresponding pitch values
            for time, value in zip(times, pitch_for_praat):
                if value > 0:
                    file.write(str(time) + '\n' + str(value) + '\n')

        # Step 3: Write the audio signal to a temporary WAV file
        audio_file = os.path.join(tmpdir, 'audio.wav')
        sf.write(audio_file, audio, sample_rate)

        # Step 4: Open the Praat manipulation context from the audio file
        # The 'To Manipulation' call creates a multi-band representation of the signal
        # for pitch and duration modification.
        manipulation = praat.call(
            Sound(audio_file), "To Manipulation", 1e-3, fmin, fmax)

        # Step 5: Read the prepared pitch tier file into a Praat object
        pitch_tier = Data.read(pitch_file)

        # Step 6: Replace the original pitch contour in the manipulation object
        # with the new pitch tier
        praat.call([pitch_tier, manipulation], "Replace pitch tier")

        # Step 7: Resynthesize the audio from the modified manipulation object
        # The 'Get resynthesis' call uses the modified pitch to reconstruct the signal.
        # It returns a Praat Sound object, and we extract the numpy array from it.
        resynthesized_sound = praat.call(manipulation, "Get resynthesis (overlap-add)")
        shifted_audio = resynthesized_sound.values[0]

    return shifted_audio


