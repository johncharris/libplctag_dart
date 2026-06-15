@Tags(['native'])
library;

import 'package:libplctag_dart/native/plctag.dart';
import 'package:test/test.dart';

/// Smoke tests that exercise the real native binary. Skipped by default in CI.
/// Run with: dart test --tags native
void main() {
  test('plc_tag_check_lib_version returns OK for current bundled lib', () {
    // The first call inside any plctag.* method triggers _extractLibraryIfRequired
    // which already performs a version check internally. Calling it explicitly
    // proves the FFI signature matches the loaded binary.
    final result = plctag.plc_tag_check_lib_version(2, 5, 0);
    expect(result, equals(0)); // PLCTAG_STATUS_OK
  });

  test('plc_tag_check_lib_version reports newer version', () {
    final result = plctag.plc_tag_check_lib_version(2, 7, 0);
    expect(result, equals(0));
  });

  test('plc_tag_decode_error works for known codes', () {
    final msg = plctag.plc_tag_decode_error(-32);
    expect(msg, isNotEmpty);
  });
}
