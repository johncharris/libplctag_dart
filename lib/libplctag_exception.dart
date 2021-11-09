import 'package:libplctag_dart/status.dart';

class LibPlcTagException implements Exception {
  final Status status;
  LibPlcTagException(this.status);

  @override
  String toString() {
    return status.toString();
  }
}
