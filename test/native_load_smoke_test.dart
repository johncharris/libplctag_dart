@Tags(['native'])
library;

import 'package:libplctag_dart/native/plctag.dart';
import 'package:libplctag_dart/status.dart';
import 'package:test/test.dart';

/// Smoke tests that exercise the real native binary. Skipped by default in CI.
/// Run with: dart test --tags native
void main() {
  test('plc_tag_check_lib_version returns OK for current bundled lib', () {
    expect(Plctag.plc_tag_check_lib_version(2, 5, 0), equals(Status.ok.value));
  });

  test('plc_tag_check_lib_version reports v2.7.0', () {
    expect(Plctag.plc_tag_check_lib_version(2, 7, 0), equals(Status.ok.value));
  });

  test('plc_tag_decode_error works for known codes', () {
    final msg = Plctag.plc_tag_decode_error(Status.errorTimeout.value);
    expect(msg, isNotEmpty);
  });
}
