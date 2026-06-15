import 'package:libplctag_dart/status.dart';

/// Thrown when a libplctag FFI call returns a non-OK status.
class LibPlcTagException implements Exception {
  final Status status;
  LibPlcTagException(this.status);

  @override
  String toString() => 'LibPlcTagException: $status';
}
