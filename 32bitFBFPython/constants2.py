import librosa
import numpy as np

# Audio file configuration and basic settings
SEMITONES_IN_OCTAVE = 12
VOCALS_FILE = r"C:\Users\neals\OneDrive\Desktop\ES@P\HarmoniCore\HarmoniCore\wav\nothingonyou.wav"
PLOT_RESULTS = False
CORRECTION_METHOD = "scale"
SCALE = "A#:maj"
SR = 44100

# Frequency range for pitch detection
fmin = librosa.note_to_hz('C2')
fmax = librosa.note_to_hz('C7')

# YIN algorithm frame parameters
frame_length = 2048
hop_length = 512
win_length = 1024

# Pitch detection threshold
trough_threshold = 0.1

# Calculate period bounds for pitch detection
min_period = int(np.floor(SR / fmax))
max_period = min(int(np.ceil(SR / fmin)), frame_length - win_length - 1)

# Median filtering for pitch smoothing
pitch_median_filter_size = 31

# Additional pitch smoothing parameters
pitch_smooth_window = 0

# Gaussian smoothing for pitch contour
pitch_gaussian_sigma = 0

# Note segmentation threshold
note_change_threshold = 0.2

# Pitch quantization granularity
pitch_quantization_cents = 5

# Transition smoothing between pitches
transition_samples = 1

# TDPSOLA synthesis parameters
tdpsola_hop_size = hop_length
tdpsola_win_size = frame_length

# Pitch shift limiting
max_pitch_shift_ratio = 1.2

# Pitch smoothing passes for post-processing
pitch_smooth_passes = 1

# Smoothing window for passes
pitch_smooth_pass_window = 3

# Audio fade envelope duration
fade_duration_sec = 0.01

# Volume normalization targets
target_rms = 0.0596
target_peak = 0.380

# Autotune effect strength
autotune_strength = 1.0

# Flat pitch region feature toggle
enable_flat_pitch_regions = True

