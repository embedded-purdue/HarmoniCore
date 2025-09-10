from parselmouth import Data, praat, Sound
import soundfile
import tempfile
import numpy as np
import os

def save(file, audio, sample_rate):
    """Save audio to disk"""
    soundfile.write(file, audio, sample_rate)
    
def get_manipulation(audio, fmin, fmax, sample_rate, tmpdir):
    """Retrieve a praat manipulation context

    Arguments
        audio : np.array(shape=(samples,))
            The speech signal to process
        fmin : int
            The minimum allowable frequency in Hz.
        fmax : int
            The maximum allowable frequency in Hz.
        sample_rate : int
            The audio sampling rate
        tmpdir : string
            Directory to save intermediate values

    Returns
        manipulation : parselmouth.Data
            The praat manipulation context
    """
    # Write audio to disk
    audio_file = os.path.join(tmpdir, 'audio.wav')
    save(audio_file, audio, sample_rate)

    # Setup the source utterance for modulation
    return praat.call(
        Sound(audio_file), "To Manipulation", 1e-3, fmin, fmax)

def write_pitch_tier(filename, pitch, duration):
    """
    Write a pitch tier to disk that is readable by praat

    Arguments
        filename : string
            Where to write the pitch file
        pitch : np.array
            The new pitch contour to use for synthesis
        duration : float
            The duration of the audio in seconds
    """
    times = np.linspace(0., duration, len(pitch))
    with open(filename, 'w') as file:
        # Write the header
        file.write('File type = "ooTextFile"\nObject class = "PitchTier"\n\n')

        # Write the start and end of the audio file
        file.write('0\n')
        file.write(str(duration) + '\n')

        # Write the number of voiced frames
        file.write(str(np.sum(~np.isnan(pitch))) + '\n')

        # Write the pitch values and time points
        for time, value in zip(times, pitch):
            if not np.isnan(value):
                file.write(str(time) + '\n' + str(value) + '\n')

def pitch_shift(audio, pitch, fmin, fmax, sample_rate, tmpdir):
    """Perform praat pitch shifting on the manipulation

    Arguments
        audio : np.array(shape=(samples,))
            The speech signal to process
        pitch : np.array(shape=(frames,))
            The target pitch contour
        fmin : int
            The minimum allowable frequency in Hz.
        fmax : int
            The maximum allowable frequency in Hz.
        sample_rate : int
            The audio sampling rate
        tmpdir : string
            Directory to save intermediate values

    Returns
        audio : np.array(shape=(samples,))
            The pitch-shifted audio
    """
    # Don't edit in-place
    pitch = np.copy(pitch)

    # Convert unvoiced tokens to 0.
    pitch[np.isnan(pitch)] = 0.

    # Write pitch to disk
    pitch_file = os.path.join(tmpdir, 'pitch.txt')
    write_pitch_tier(pitch_file, pitch, float(len(audio)) / sample_rate)

    # Read pitch file into praat
    pitch_tier = Data.read(pitch_file)

    # Open a praat manipulation context
    manipulation = get_manipulation(audio, fmin, fmax, sample_rate, tmpdir)

    # Replace source pitch with new pitch
    praat.call([pitch_tier, manipulation], "Replace pitch tier")

    # Resynthesize
    return praat.call(manipulation, "Get resynthesis (overlap-add)").values[0]

def vocode(audio,
           sample_rate,
           target_pitch,
           fmin,
           fmax):
    """Performs pitch vocoding using Praat

    Arguments
        audio : np.array(shape=(samples,))
            The speech signal to process
        sample_rate : int
            The audio sampling rate.
        source_alignment : pypar.Alignment
            The current alignment if performing time-stretching
        target_alignment : pypar.Alignment
            The target alignment if performing time-stretching
        target_pitch : np.array(shape=(frames,))
            The target pitch contour
        constant_stretch : float or None
            A constant value for time-stretching
        fmin : int
            The minimum allowable frequency in Hz.
        fmax : int
            The maximum allowable frequency in Hz.

    Returns
        audio : np.array(shape=(samples,))
            The vocoded audio
    """
    with tempfile.TemporaryDirectory() as tmpdir:

        # Pitch-shift
        if target_pitch is not None:
            audio = pitch_shift(
                audio, target_pitch, fmin, fmax, sample_rate, tmpdir)

        return audio