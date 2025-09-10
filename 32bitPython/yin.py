import numpy as np
def autocorrelate(y, max_lag=None, axis=-1):
    """
    Computes the autocorrelation of a signal using the Fast Fourier Transform (FFT).

    This method is generally more efficient than direct correlation for long signals.
    It computes the power spectrum of the signal in the frequency domain and then
    converts it back to the time domain via an inverse FFT.

    Parameters:
    y (np.ndarray): The input array to autocorrelate.
    max_lag (int, optional): The maximum lag to compute. If None,
                             the full autocorrelation is computed.
    axis (int): The axis along which to autocorrelate.
    
    Returns:
    np.ndarray: The truncated autocorrelation along the specified axis.
    """
    # Ensure a valid maximum lag
    if max_lag is None:
        max_lag = y.shape[axis]

    max_lag = int(min(max_lag, y.shape[axis]))
    
    # Determine if the input signal is real or complex
    real = not np.iscomplexobj(y)

    # Pad the signal to a "fast" FFT length to optimize performance
    # The length must be at least 2*N - 1 for a full autocorrelation.
    n_pad = scipy.fft.next_fast_len(2 * y.shape[axis] - 1, real=real)
    
    if real:
        # For real-valued signals, use the real FFT for efficiency
        powspec = np.abs(scipy.fft.rfft(y, n=n_pad, axis=axis))**2

        autocorr = scipy.fft.irfft(powspec, n=n_pad, axis=axis)
    else:
        # For complex signals, use the standard FFT
        powspec = np.abs(scipy.fft.fft(y, n=n_pad, axis=axis))**2

        autocorr = scipy.fft.ifft(powspec, n=n_pad, axis=axis)

    # If the input was real, the output should also be real
    if real:
        autocorr = np.real(autocorr)

    # Step 3: Slice the result to the specified maximum lag
    subslice = [slice(None)] * autocorr.ndim
    subslice[axis] = slice(max_lag)

    autocorr_slice = autocorr[tuple(subslice)]

    # Step 4: Normalize by the zero-lag value (energy of the signal)
    # The zero-lag value is always the first element of the autocorrelation array.
    zero_lag_value = autocorr_slice.take(0, axis=axis)
    autocorr_normalized = autocorr_slice / zero_lag_value

    return autocorr_normalized
    
def expand_to(
    x: np.ndarray, *, ndim: int, axes
) -> np.ndarray:
    """Expand the dimensions of an input array with

    Parameters
    ----------
    x : np.ndarray
        The input array
    ndim : int
        The number of dimensions to expand to.  Must be at least ``x.ndim``
    axes : int or slice
        The target axis or axes to preserve from x.
        All other axes will have length 1.

    Returns
    -------
    x_exp : np.ndarray
        The expanded version of ``x``, satisfying the following:
            ``x_exp[axes] == x``
            ``x_exp.ndim == ndim``

    See Also
    --------
    np.expand_dims

    Examples
    --------
    Expand a 1d array into an (n, 1) shape

    >>> x = np.arange(3)
    >>> librosa.util.expand_to(x, ndim=2, axes=0)
    array([[0],
       [1],
       [2]])

    Expand a 1d array into a (1, n) shape

    >>> librosa.util.expand_to(x, ndim=2, axes=1)
    array([[0, 1, 2]])

    Expand a 2d array into (1, n, m, 1) shape

    >>> x = np.vander(np.arange(3))
    >>> librosa.util.expand_to(x, ndim=4, axes=[1,2]).shape
    (1, 3, 3, 1)
    """
    # Force axes into a tuple
    axes_tup: Tuple[int]
    try:
        axes_tup = tuple(axes)  # type: ignore
    except TypeError:
        axes_tup = tuple([axes])  # type: ignore

    if len(axes_tup) != x.ndim:
        raise ParameterError(
            f"Shape mismatch between axes={axes_tup} and input x.shape={x.shape}"
        )

    if ndim < x.ndim:
        raise ParameterError(
            f"Cannot expand x.shape={x.shape} to fewer dimensions ndim={ndim}"
        )

    shape: List[int] = [1] * ndim
    for i, axi in enumerate(axes_tup):
        shape[axi] = x.shape[i]

    return x.reshape(shape)

def tiny(x):
    """Compute the tiny-value corresponding to an input's data type.

    This is the smallest "usable" number representable in ``x.dtype``
    (e.g., float32).

    This is primarily useful for determining a threshold for
    numerical underflow in division or multiplication operations.

    Parameters
    ----------
    x : number or np.ndarray
        The array to compute the tiny-value for.
        All that matters here is ``x.dtype``

    Returns
    -------
    tiny_value : float
        The smallest positive usable number for the type of ``x``.
        If ``x`` is integer-typed, then the tiny value for ``np.float32``
        is returned instead.

    See Also
    --------
    numpy.finfo

    Examples
    --------
    For a standard double-precision floating point number:

    >>> librosa.util.tiny(1.0)
    2.2250738585072014e-308

    Or explicitly as double-precision

    >>> librosa.util.tiny(np.asarray(1e-5, dtype=np.float64))
    2.2250738585072014e-308

    Or complex numbers

    >>> librosa.util.tiny(1j)
    2.2250738585072014e-308

    Single-precision floating point:

    >>> librosa.util.tiny(np.asarray(1e-5, dtype=np.float32))
    1.1754944e-38

    Integer

    >>> librosa.util.tiny(5)
    1.1754944e-38
    """
    # Make sure we have an array view
    x = np.asarray(x)

    # Only floating types generate a tiny
    if np.issubdtype(x.dtype, np.floating) or np.issubdtype(
        x.dtype, np.complexfloating
    ):
        dtype = x.dtype
    else:
        dtype = np.dtype(np.float32)

    return np.finfo(dtype).tiny

def _pi_stencil(x: np.ndarray) -> np.ndarray:
    """Stencil to compute local parabolic interpolation"""
    a = x[1] + x[-1] - 2 * x[0]
    b = (x[1] - x[-1]) / 2

    # if np.abs(b) >= np.abs(a):
    #     # If this happens, we'll shift by more than 1 bin
    #     # Suppressing types because mypy has no idea about stencils
    #     return 0  # type: ignore

    return -b / a  # type: ignore
    
def _pi_wrapper(x: np.ndarray, y: np.ndarray) -> None:  # pragma: no cover
    """Vectorized wrapper for the parabolic interpolation stencil"""
    y[:] = _pi_stencil(x)
    
def _parabolic_interpolation(x: np.ndarray, *, axis: int = -2) -> np.ndarray:
    """Piecewise parabolic interpolation for yin and pyin.

    Parameters
    ----------
    x : np.ndarray
        array to interpolate
    axis : int
        axis along which to interpolate

    Returns
    -------
    parabolic_shifts : np.ndarray [shape=x.shape]
        position of the parabola optima (relative to bin indices)

        Note: the shift at bin `n` is determined as 0 if the estimated
        optimum is outside the range `[n-1, n+1]`.
    """
    # Rotate the target axis to the end
    xi = x.swapaxes(-1, axis)

    # Allocate the output array and rotate target axis
    shifts = np.empty_like(x)
    shiftsi = shifts.swapaxes(-1, axis)

    # Call the vectorized stencil
    _pi_wrapper(xi, shiftsi)

    # Handle the edge condition not covered by the stencil
    shiftsi[..., -1] = 0
    shiftsi[..., 0] = 0

    return shifts

def _cumulative_mean_normalized_difference(
    y_frames: np.ndarray,
    min_period: int,
    max_period: int,
) -> np.ndarray:
    """Cumulative mean normalized difference function (equation 8 in [#]_)

    .. [#] De Cheveigné, Alain, and Hideki Kawahara.
        "YIN, a fundamental frequency estimator for speech and music."
        The Journal of the Acoustical Society of America 111.4 (2002): 1917-1930.

    Parameters
    ----------
    y_frames : np.ndarray [shape=(frame_length, n_frames)]
        framed audio time series.
    min_period : int > 0 [scalar]
        minimum period.
    max_period : int > 0 [scalar]
        maximum period.

    Returns
    -------
    yin_frames : np.ndarray [shape=(max_period-min_period+1,n_frames)]
        Cumulative mean normalized difference function for each frame.
    """
    acf_frames = autocorrelate(y_frames, max_lag=max_period + 1, axis=-2)

    # Energy terms.
    yin_frames = np.square(y_frames)
    np.cumsum(yin_frames, out=yin_frames, axis=-2)

    # Difference function: d(k) = 2 * (ACF(0) - ACF(k)) - sum_{m=0}^{k-1} y(m)^2
    k = slice(1, max_period + 1)
    yin_frames[..., 0, :] = 0
    yin_frames[..., k, :] = (
        2 * (acf_frames[..., 0:1, :] - acf_frames[..., k, :]) - yin_frames[..., :k.stop-1, :]
    )

    # Cumulative mean normalized difference function.
    yin_numerator = yin_frames[..., min_period : max_period + 1, :]
    # broadcast this shape to have leading ones
    k_range = expand_to(np.r_[k], ndim=yin_frames.ndim, axes=-2)

    cumulative_mean = (
        np.cumsum(yin_frames[..., k, :], axis=-2) / k_range
    )
    yin_denominator = cumulative_mean[..., min_period - 1 : max_period, :]
    yin_frames: np.ndarray = yin_numerator / (
        yin_denominator + tiny(yin_denominator)
    )
    return yin_frames

def _localmin_sten(x):  # pragma: no cover
    """Numba stencil for local minima computation"""
    return (x[0] < x[-1]) & (x[0] <= x[1])
    
def _localmin(x, y):  # pragma: no cover
    """Vectorized wrapper for the localmin stencil"""
    y[:] = _localmin_sten(x)

def localmin(x: np.ndarray, *, axis: int = 0) -> np.ndarray:
    """Find local minima in an array

    An element ``x[i]`` is considered a local minimum if the following
    conditions are met:

    - ``x[i] < x[i-1]``
    - ``x[i] <= x[i+1]``

    Note that the first condition is strict, and that the first element
    ``x[0]`` will never be considered as a local minimum.

    Examples
    --------
    >>> x = np.array([1, 0, 1, 2, -1, 0, -2, 1])
    >>> librosa.util.localmin(x)
    array([False,  True, False, False,  True, False,  True, False])

    >>> # Two-dimensional example
    >>> x = np.array([[1,0,1], [2, -1, 0], [2, 1, 3]])
    >>> librosa.util.localmin(x, axis=0)
    array([[False, False, False],
           [False,  True,  True],
           [False, False, False]])

    >>> librosa.util.localmin(x, axis=1)
    array([[False,  True, False],
           [False,  True, False],
           [False,  True, False]])

    Parameters
    ----------
    x : np.ndarray [shape=(d1,d2,...)]
        input vector or array
    axis : int
        axis along which to compute local minimality

    Returns
    -------
    m : np.ndarray [shape=x.shape, dtype=bool]
        indicator array of local minimality along ``axis``

    See Also
    --------
    localmax
    """
    # Rotate the target axis to the end
    xi = x.swapaxes(-1, axis)

    # Allocate the output array and rotate target axis
    lmin = np.empty_like(x, dtype=bool)
    lmini = lmin.swapaxes(-1, axis)

    # Call the vectorized stencil
    _localmin(xi, lmini)

    # Handle the edge condition not covered by the stencil
    lmini[..., -1] = xi[..., -1] < xi[..., -2]

    return lmin

def frame(
    x: np.ndarray,
    *,
    frame_length: int,
    hop_length: int,
    axis: int = -1,
    writeable: bool = False,
    subok: bool = False,
) -> np.ndarray:
    """Slice a data array into (overlapping) frames.

    This implementation uses low-level stride manipulation to avoid
    making a copy of the data.  The resulting frame representation
    is a new view of the same input data.

    For example, a one-dimensional input ``x = [0, 1, 2, 3, 4, 5, 6]``
    can be framed with frame length 3 and hop length 2 in two ways.
    The first (``axis=-1``), results in the array ``x_frames``::

        [[0, 2, 4],
         [1, 3, 5],
         [2, 4, 6]]

    where each column ``x_frames[:, i]`` contains a contiguous slice of
    the input ``x[i * hop_length : i * hop_length + frame_length]``.

    The second way (``axis=0``) results in the array ``x_frames``::

        [[0, 1, 2],
         [2, 3, 4],
         [4, 5, 6]]

    where each row ``x_frames[i]`` contains a contiguous slice of the input.

    This generalizes to higher dimensional inputs, as shown in the examples below.
    In general, the framing operation increments by 1 the number of dimensions,
    adding a new "frame axis" either before the framing axis (if ``axis < 0``)
    or after the framing axis (if ``axis >= 0``).

    Parameters
    ----------
    x : np.ndarray
        Array to frame
    frame_length : int > 0 [scalar]
        Length of the frame
    hop_length : int > 0 [scalar]
        Number of steps to advance between frames
    axis : int
        The axis along which to frame.
    writeable : bool
        If ``False``, then the framed view of ``x`` is read-only.
        If ``True``, then the framed view is read-write.  Note that writing to the framed view
        will also write to the input array ``x`` in this case.
    subok : bool
        If True, sub-classes will be passed-through, otherwise the returned array will be
        forced to be a base-class array (default).

    Returns
    -------
    x_frames : np.ndarray [shape=(..., frame_length, N_FRAMES, ...)]
        A framed view of ``x``, for example with ``axis=-1`` (framing on the last dimension)::

            x_frames[..., j] == x[..., j * hop_length : j * hop_length + frame_length]

        If ``axis=0`` (framing on the first dimension), then::

            x_frames[j] = x[j * hop_length : j * hop_length + frame_length]

    Raises
    ------
    ParameterError
        If ``x.shape[axis] < frame_length``, there is not enough data to fill one frame.

        If ``hop_length < 1``, frames cannot advance.

    See Also
    --------
    numpy.lib.stride_tricks.as_strided

    Examples
    --------
    Extract 2048-sample frames from monophonic signal with a hop of 64 samples per frame

    >>> y, sr = librosa.load(librosa.ex('trumpet'))
    >>> frames = librosa.util.frame(y, frame_length=2048, hop_length=64)
    >>> frames
    array([[-1.407e-03, -2.604e-02, ..., -1.795e-05, -8.108e-06],
           [-4.461e-04, -3.721e-02, ..., -1.573e-05, -1.652e-05],
           ...,
           [ 7.960e-02, -2.335e-01, ..., -6.815e-06,  1.266e-05],
           [ 9.568e-02, -1.252e-01, ...,  7.397e-06, -1.921e-05]],
          dtype=float32)
    >>> y.shape
    (117601,)

    >>> frames.shape
    (2048, 1806)

    Or frame along the first axis instead of the last:

    >>> frames = librosa.util.frame(y, frame_length=2048, hop_length=64, axis=0)
    >>> frames.shape
    (1806, 2048)

    Frame a stereo signal:

    >>> y, sr = librosa.load(librosa.ex('trumpet', hq=True), mono=False)
    >>> y.shape
    (2, 117601)
    >>> frames = librosa.util.frame(y, frame_length=2048, hop_length=64)
    (2, 2048, 1806)

    Carve an STFT into fixed-length patches of 32 frames with 50% overlap

    >>> y, sr = librosa.load(librosa.ex('trumpet'))
    >>> S = np.abs(librosa.stft(y))
    >>> S.shape
    (1025, 230)
    >>> S_patch = librosa.util.frame(S, frame_length=32, hop_length=16)
    >>> S_patch.shape
    (1025, 32, 13)
    >>> # The first patch contains the first 32 frames of S
    >>> np.allclose(S_patch[:, :, 0], S[:, :32])
    True
    >>> # The second patch contains frames 16 to 16+32=48, and so on
    >>> np.allclose(S_patch[:, :, 1], S[:, 16:48])
    True
    """
    # This implementation is derived from numpy.lib.stride_tricks.sliding_window_view (1.20.0)
    # https://numpy.org/doc/stable/reference/generated/numpy.lib.stride_tricks.sliding_window_view.html

    x = np.array(x, copy=False, subok=subok)

    if x.shape[axis] < frame_length:
        raise ParameterError(
            f"Input is too short (n={x.shape[axis]:d}) for frame_length={frame_length:d}"
        )

    if hop_length < 1:
        raise ParameterError(f"Invalid hop_length: {hop_length:d}")

    # put our new within-frame axis at the end for now
    out_strides = x.strides + tuple([x.strides[axis]])

    # Reduce the shape on the framing axis
    x_shape_trimmed = list(x.shape)
    x_shape_trimmed[axis] -= frame_length - 1

    out_shape = tuple(x_shape_trimmed) + tuple([frame_length])
    xw = as_strided(
        x, strides=out_strides, shape=out_shape, subok=subok, writeable=writeable
    )

    if axis < 0:
        target_axis = axis - 1
    else:
        target_axis = axis + 1

    xw = np.moveaxis(xw, -1, target_axis)

    # Downsample along the target axis
    slices = [slice(None)] * xw.ndim
    slices[axis] = slice(0, None, hop_length)
    return xw[tuple(slices)]

def valid_audio(y: np.ndarray) -> bool:
    """Determine whether a variable contains valid audio data.

    The following conditions must be satisfied:

    - ``type(y)`` is ``np.ndarray``
    - ``y.dtype`` is floating-point
    - ``y.ndim != 0`` (must have at least one dimension)
    - ``np.isfinite(y).all()`` samples must be all finite values

    Parameters
    ----------
    y : np.ndarray
        The input data to validate

    Returns
    -------
    valid : bool
        True if all tests pass

    Raises
    ------
    ParameterError
        In any of the conditions specified above fails

    Notes
    -----
    This function caches at level 20.

    Examples
    --------
    We can make an array that can be interpreted as an audio signal

    >>> y = np.random.randn(5000)
    >>> librosa.util.valid_audio(y)
    True

    If we insert a non-finite sample value somewhere, it will fail

    >>> y[5] = np.nan
    >>> librosa.util.valid_audio(y)
    ...
    ParameterError: Audio buffer is not finite everywhere

    See Also
    --------
    numpy.float32
    """
    if not isinstance(y, np.ndarray):
        raise ParameterError("Audio data must be of type numpy.ndarray")

    if not np.issubdtype(y.dtype, np.floating):
        raise ParameterError("Audio data must be floating-point")

    if y.ndim == 0:
        raise ParameterError(
            f"Audio data must be at least one-dimensional, given y.shape={y.shape}"
        )

    if not np.isfinite(y).all():
        raise ParameterError("Audio buffer is not finite everywhere")

    return True

def yin(
    y: np.ndarray,
    fmin: float,
    fmax: float,
    sr: float = 22050,
    frame_length: int = 2048,
    hop_length: int = None,
    pad_mode: str = "constant",
    trough_threshold: float = 0.1
) -> np.ndarray:
    """Fundamental frequency (F0) estimation using the YIN algorithm.

    YIN is an autocorrelation based method for fundamental frequency estimation [#]_.
    First, a normalized difference function is computed over short (overlapping) frames of audio.
    Next, the first minimum in the difference function below ``trough_threshold`` is selected as
    an estimate of the signal's period.
    Finally, the estimated period is refined using parabolic interpolation before converting
    into the corresponding frequency.

    .. [#] De Cheveigné, Alain, and Hideki Kawahara.
        "YIN, a fundamental frequency estimator for speech and music."
        The Journal of the Acoustical Society of America 111.4 (2002): 1917-1930.

    Parameters
    ----------
    y : np.ndarray [shape=(..., n)]
        audio time series. Multi-channel is supported..

    fmin : number > 0 [scalar]
        minimum frequency in Hertz.
        The recommended minimum is ``librosa.note_to_hz('C2')`` (~65 Hz)
        though lower values may be feasible.

    fmax : number > fmin, <= sr/2 [scalar]
        maximum frequency in Hertz.
        The recommended maximum is ``librosa.note_to_hz('C7')`` (~2093 Hz)
        though higher values may be feasible.

    sr : number > 0 [scalar]
        sampling rate of ``y`` in Hertz.

    frame_length : int > 0 [scalar]
        length of the frames in samples.
        By default, ``frame_length=2048`` corresponds to a time scale of about 93 ms at
        a sampling rate of 22050 Hz.

    hop_length : None or int > 0 [scalar]
        number of audio samples between adjacent YIN predictions.
        If ``None``, defaults to ``frame_length // 4``.

    trough_threshold : number > 0 [scalar]
        absolute threshold for peak estimation.

    center : boolean
        If ``True``, the signal `y` is padded so that frame
        ``D[:, t]`` is centered at `y[t * hop_length]`.
        If ``False``, then ``D[:, t]`` begins at ``y[t * hop_length]``.
        Defaults to ``True``,  which simplifies the alignment of ``D`` onto a
        time grid by means of ``librosa.core.frames_to_samples``.

    pad_mode : string or function
        If ``center=True``, this argument is passed to ``np.pad`` for padding
        the edges of the signal ``y``. By default (``pad_mode="constant"``),
        ``y`` is padded on both sides with zeros.
        If ``center=False``,  this argument is ignored.
        .. see also:: `np.pad`

    win_length : Deprecated
        length of the window for calculating autocorrelation in samples.

        .. warning:: This parameter is deprecated as of 0.11.0 and
            will be removed in 1.0.

    Returns
    -------
    f0: np.ndarray [shape=(..., n_frames)]
        time series of fundamental frequencies in Hertz.

        If multi-channel input is provided, f0 curves are estimated separately for each channel.

    See Also
    --------
    librosa.pyin :
        Fundamental frequency (F0) estimation using probabilistic YIN (pYIN).

    Examples
    --------
    Computing a fundamental frequency (F0) curve from an audio input

    >>> y = librosa.chirp(fmin=440, fmax=880, duration=5.0, sr=22050)
    >>> librosa.yin(y, fmin=440, fmax=880, sr=22050)
    array([442.66354675, 441.95299983, 441.58010963, ...,
        871.161732  , 873.99001454, 877.04297681])
    """

    # Check that audio is valid.
    valid_audio(y)

    # Frame audio.
    y_frames = frame(y, frame_length=frame_length, hop_length=hop_length)

    # Calculate minimum and maximum periods
    min_period = int(np.floor(sr / fmax))
    max_period = min(int(np.ceil(sr / fmin)), frame_length - 1)

    # Calculate cumulative mean normalized difference function.
    yin_frames = _cumulative_mean_normalized_difference(
        y_frames, min_period, max_period
    )

    # Parabolic interpolation.
    parabolic_shifts = _parabolic_interpolation(yin_frames)

    # Find local minima.
    is_trough = localmin(yin_frames, axis=-2)
    is_trough[..., 0, :] = yin_frames[..., 0, :] < yin_frames[..., 1, :]

    # Find minima below peak threshold.
    is_threshold_trough = np.logical_and(is_trough, yin_frames < trough_threshold)

    # Absolute threshold.
    # "The solution we propose is to set an absolute threshold and choose the
    # smallest value of tau that gives a minimum of d' deeper than
    # this threshold. If none is found, the global minimum is chosen instead."
    target_shape = list(yin_frames.shape)
    target_shape[-2] = 1

    global_min = np.argmin(yin_frames, axis=-2)
    yin_period = np.argmax(is_threshold_trough, axis=-2)

    global_min = global_min.reshape(target_shape)
    yin_period = yin_period.reshape(target_shape)

    no_trough_below_threshold = np.all(~is_threshold_trough, axis=-2, keepdims=True)
    yin_period[no_trough_below_threshold] = global_min[no_trough_below_threshold]

    # Refine peak by parabolic interpolation.

    yin_period = (
        min_period
        + yin_period
        + np.take_along_axis(parabolic_shifts, yin_period, axis=-2)
    )[..., 0, :]

    # Convert period to fundamental frequency.
    f0: np.ndarray = sr / yin_period
    return f0