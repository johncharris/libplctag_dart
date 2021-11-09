class STATUS_CODES {
  final _value;
  const STATUS_CODES._internal(this._value);
  int get value => _value;

  /// <summary>
  /// Operation in progress. Not an error.
  /// </summary>
  static const PLCTAG_STATUS_PENDING = const STATUS_CODES._internal(1);

  /// <summary>
  /// No error.
  /// </summary>
  static const PLCTAG_STATUS_OK = const STATUS_CODES._internal(0);

  /// <summary>
  /// The operation was aborted.
  /// </summary>
  static const PLCTAG_ERR_ABORT = const STATUS_CODES._internal(-1);

  /// <summary>
  /// The operation failed due to incorrect configuration. Usually returned from a remote system.
  /// </summary>
  static const PLCTAG_ERR_BAD_CONFIG = const STATUS_CODES._internal(-2);

  /// <summary>
  /// The connection failed for some reason. This can mean that the remote PLC was power cycled); for instance.
  /// </summary>
  static const PLCTAG_ERR_BAD_CONNECTION = const STATUS_CODES._internal(-3);

  /// <summary>
  /// The data received from the remote PLC was undecipherable or otherwise not able to be processed.
  /// Can also be returned from a remote system that cannot process the data sent to it.
  /// </summary>
  static const PLCTAG_ERR_BAD_DATA = const STATUS_CODES._internal(-4);

  /// <summary>
  /// Usually returned from a remote system when something addressed does not exist.
  /// </summary>
  static const PLCTAG_ERR_BAD_DEVICE = const STATUS_CODES._internal(-5);

  /// <summary>
  /// Usually returned when the library is unable to connect to a remote system.
  /// </summary>
  static const PLCTAG_ERR_BAD_GATEWAY = const STATUS_CODES._internal(-6);

  /// <summary>
  /// A common error return when something is not correct with the tag creation attribute string.
  /// </summary>
  static const PLCTAG_ERR_BAD_PARAM = const STATUS_CODES._internal(-7);

  /// <summary>
  /// Usually returned when the remote system returned an unexpected response.
  /// </summary>
  static const PLCTAG_ERR_BAD_REPLY = const STATUS_CODES._internal(-8);

  /// <summary>
  /// Usually returned by a remote system when something is not in a good state.
  /// </summary>
  static const PLCTAG_ERR_BAD_STATUS = const STATUS_CODES._internal(-9);

  /// <summary>
  /// An error occurred trying to close some resource.
  /// </summary>
  static const PLCTAG_ERR_CLOSE = const STATUS_CODES._internal(-10);

  /// <summary>
  /// An error occurred trying to create some internal resource.
  /// </summary>
  static const PLCTAG_ERR_CREATE = const STATUS_CODES._internal(-11);

  /// <summary>
  /// An error returned by a remote system when something is incorrectly duplicated (i.e. a duplicate connection ID).
  /// </summary>
  static const PLCTAG_ERR_DUPLICATE = const STATUS_CODES._internal(-12);

  /// <summary>
  /// An error was returned when trying to encode some data such as a tag name.
  /// </summary>
  static const PLCTAG_ERR_ENCODE = const STATUS_CODES._internal(-13);

  /// <summary>
  /// An internal library error. It would be very unusual to see this.
  /// </summary>
  static const PLCTAG_ERR_MUTEX_DESTROY = const STATUS_CODES._internal(-14);

  /// <summary>
  /// An internal library error. It would be very unusual to see this.
  /// </summary>
  static const PLCTAG_ERR_MUTEX_INIT = const STATUS_CODES._internal(-15);

  /// <summary>
  /// An internal library error. It would be very unusual to see this.
  /// </summary>
  static const PLCTAG_ERR_MUTEX_LOCK = const STATUS_CODES._internal(-16);

  /// <summary>
  /// An internal library error. It would be very unusual to see this.
  /// </summary>
  static const PLCTAG_ERR_MUTEX_UNLOCK = const STATUS_CODES._internal(-17);

  /// <summary>
  /// Often returned from the remote system when an operation is not permitted.
  /// </summary>
  static const PLCTAG_ERR_NOT_ALLOWED = const STATUS_CODES._internal(-18);

  /// <summary>
  /// Often returned from the remote system when something is not found.
  /// </summary>
  static const PLCTAG_ERR_NOT_FOUND = const STATUS_CODES._internal(-19);

  /// <summary>
  /// returned when a valid operation is not implemented.
  /// </summary>
  static const PLCTAG_ERR_NOT_IMPLEMENTED = const STATUS_CODES._internal(-20);

  /// <summary>
  /// Returned when expected data is not present.
  /// </summary>
  static const PLCTAG_ERR_NO_DATA = const STATUS_CODES._internal(-21);

  /// <summary>
  /// Similar to <see cref="PLCTAG_ERR_NOT_FOUND"/>
  /// </summary>
  static const PLCTAG_ERR_NO_MATCH = const STATUS_CODES._internal(-22);

  /// <summary>
  /// Returned by the library when memory allocation fails.
  /// </summary>
  static const PLCTAG_ERR_NO_MEM = const STATUS_CODES._internal(-23);

  /// <summary>
  /// Returned by the remote system when some resource allocation fails.
  /// </summary>
  static const PLCTAG_ERR_NO_RESOURCES = const STATUS_CODES._internal(-24);

  /// <summary>
  /// Usually an internal error); but can be returned when an invalid handle is used with an API call.
  /// </summary>
  static const PLCTAG_ERR_NULL_PTR = const STATUS_CODES._internal(-25);

  /// <summary>
  /// Returned when an error occurs opening a resource such as a socket.
  /// </summary>
  static const PLCTAG_ERR_OPEN = const STATUS_CODES._internal(-26);

  /// <summary>
  /// Usually returned when trying to write a value into a tag outside of the tag data bounds.
  /// </summary>
  static const PLCTAG_ERR_OUT_OF_BOUNDS = const STATUS_CODES._internal(-27);

  /// <summary>
  /// Returned when an error occurs during a read operation. Usually related to socket problems.
  /// </summary>
  static const PLCTAG_ERR_READ = const STATUS_CODES._internal(-28);

  /// <summary>
  /// An unspecified or untranslatable remote error causes this.
  /// </summary>
  static const PLCTAG_ERR_REMOTE_ERR = const STATUS_CODES._internal(-29);

  /// <summary>
  /// An internal library error. If you see this); it is likely that everything is about to crash.
  /// </summary>
  static const PLCTAG_ERR_THREAD_CREATE = const STATUS_CODES._internal(-30);

  /// <summary>
  /// Another internal library error. It is very unlikely that you will see this.
  /// </summary>
  static const PLCTAG_ERR_THREAD_JOIN = const STATUS_CODES._internal(-31);

  /// <summary>
  /// An operation took too long and timed out.
  /// </summary>
  static const PLCTAG_ERR_TIMEOUT = const STATUS_CODES._internal(-32);

  /// <summary>
  /// More data was returned than was expected.
  /// </summary>
  static const PLCTAG_ERR_TOO_LARGE = const STATUS_CODES._internal(-33);

  /// <summary>
  /// Insufficient data was returned from the remote system.
  /// </summary>
  static const PLCTAG_ERR_TOO_SMALL = const STATUS_CODES._internal(-34);

  /// <summary>
  /// The operation is not supported on the remote system.
  /// </summary>
  static const PLCTAG_ERR_UNSUPPORTED = const STATUS_CODES._internal(-35);

  /// <summary>
  /// A Winsock-specific error occurred (only on Windows).
  /// </summary>
  static const PLCTAG_ERR_WINSOCK = const STATUS_CODES._internal(-36);

  /// <summary>
  /// An error occurred trying to write); usually to a socket.
  /// </summary>
  static const PLCTAG_ERR_WRITE = const STATUS_CODES._internal(-37);

  /// <summary>
  /// Partial data was received or something was unexpectedly incomplete.
  /// </summary>
  static const PLCTAG_ERR_PARTIAL = const STATUS_CODES._internal(-38);

  /// <summary>
  /// The operation cannot be performed as some other operation is taking place.
  /// </summary>
  static const PLCTAG_ERR_BUSY = const STATUS_CODES._internal(-39);
}
