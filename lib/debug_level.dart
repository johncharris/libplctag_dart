/// Debug verbosity levels for the native libplctag library.
///
/// The associated [value] is the integer the native library accepts
/// via `plc_tag_set_debug_level` and the `debug=` attribute.
enum DebugLevel {
  /// Disable debugging output entirely.
  none(0),

  /// Errors only — generally fatal conditions inside the library.
  error(1),

  /// Errors plus warnings (malformed attributes, unexpected PLC responses).
  warn(2),

  /// Diagnostic information about internal calls, including some packet dumps.
  info(3),

  /// Detailed diagnostics with full packet dumps.
  detail(4),

  /// Extremely verbose — mutex acquires/releases, etc.
  /// May emit many lines per millisecond.
  spew(5);

  const DebugLevel(this.value);

  /// Integer code passed across the FFI boundary.
  final int value;
}
