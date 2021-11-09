/// <summary>
/// Debug levels available in the base libplctag library
/// </summary>
class DebugLevel {
  final _value;
  const DebugLevel._internal(this._value);
  int get value => _value;

  /// <inheritdoc cref="DEBUG_LEVELS.PLCTAG_DEBUG_NONE"/>
  static const None = const DebugLevel._internal(DEBUG_LEVELS.PLCTAG_DEBUG_NONE);

  /// <inheritdoc cref="DEBUG_LEVELS.PLCTAG_DEBUG_ERROR"/>
  static const Error = const DebugLevel._internal(DEBUG_LEVELS.PLCTAG_DEBUG_ERROR);

  /// <inheritdoc cref="DEBUG_LEVELS.PLCTAG_DEBUG_WARN"/>
  static const Warn = const DebugLevel._internal(DEBUG_LEVELS.PLCTAG_DEBUG_WARN);

  /// <inheritdoc cref="DEBUG_LEVELS.PLCTAG_DEBUG_INFO"/>
  static const Info = const DebugLevel._internal(DEBUG_LEVELS.PLCTAG_DEBUG_INFO);

  /// <inheritdoc cref="DEBUG_LEVELS.PLCTAG_DEBUG_DETAIL"/>
  static const Detail = const DebugLevel._internal(DEBUG_LEVELS.PLCTAG_DEBUG_DETAIL);

  /// <inheritdoc cref="DEBUG_LEVELS.PLCTAG_DEBUG_SPEW"/>
  static const Spew = const DebugLevel._internal(DEBUG_LEVELS.PLCTAG_DEBUG_SPEW);
}

class DEBUG_LEVELS {
  final _value;
  const DEBUG_LEVELS._internal(this._value);
  int get value => _value;

  /// <summary>
  /// Disables debugging output.
  /// </summary>
  static const PLCTAG_DEBUG_NONE = const DebugLevel._internal(0);

  /// <summary>
  /// Only output errors. Generally these are fatal to the functioning of the library.
  /// </summary>
  static const PLCTAG_DEBUG_ERROR = const DebugLevel._internal(1);

  /// <summary>
  /// Outputs warnings such as error found when checking a malformed tag attribute string or when unexpected problems are reported from the PLC.
  /// </summary>
  static const PLCTAG_DEBUG_WARN = const DebugLevel._internal(2);

  /// <summary>
  /// Outputs diagnostic information about the internal calls within the library.
  /// Includes some packet dumps.
  /// </summary>
  static const PLCTAG_DEBUG_INFO = const DebugLevel._internal(3);

  /// <summary>
  /// Outputs detailed diagnostic information about the code executing within the library including packet dumps.
  /// </summary>
  static const PLCTAG_DEBUG_DETAIL = const DebugLevel._internal(4);

  /// <summary>
  /// Outputs extremely detailed information.
  /// Do not use this unless you are trying to debug detailed information about every mutex lock and release.
  /// Will output many lines of output per millisecond.
  /// You have been warned!
  /// </summary>
  static const PLCTAG_DEBUG_SPEW = const DebugLevel._internal(5);
}
