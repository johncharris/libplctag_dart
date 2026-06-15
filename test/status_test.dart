import 'package:libplctag_dart/status.dart';
import 'package:test/test.dart';

void main() {
  // Sanity-check every status code that the library exposes. If a new code is
  // added, this should remind us to wire it into Status.fromInt.
  final codes = <int>[
    1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9,
    -10, -11, -12, -13, -14, -15, -16, -17, -18, -19,
    -20, -21, -22, -23, -24, -25, -26, -27, -28, -29,
    -30, -31, -32, -33, -34, -35, -36, -37, -38, -39,
  ];

  for (final code in codes) {
    test('Status.fromInt($code) round-trips', () {
      final status = Status.fromInt(code);
      expect(status.value, equals(code));
    });
  }

  test('ErrorBadConnection message has no leading space (Phase 1 regression)', () {
    expect(Status.ErrorBadConnection.toString(), equals('-3 Bad Connection'));
  });

  test('toString includes the integer value and the human name', () {
    expect(Status.Ok.toString(), equals('0 Ok'));
    expect(Status.ErrorTimeout.toString(), equals('-32 Timeout'));
  });
}
