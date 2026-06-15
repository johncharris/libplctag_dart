@Tags(['integration'])
library;

import 'dart:io';

import 'package:libplctag_dart/data_types/dint_plc_mapper.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/protocol.dart';
import 'package:libplctag_dart/tag_event.dart';
import 'package:libplctag_dart/tag_of_t.dart';
import 'package:test/test.dart';

/// Integration tests that require a real PLC or the libplctag software
/// simulator. Opt-in via the `PLC_GATEWAY` environment variable.
///
/// Run with:
///   PLC_GATEWAY=127.0.0.1 dart test --tags integration
void main() {
  final gateway = Platform.environment['PLC_GATEWAY'];
  final tagName = Platform.environment['PLC_TAG_NAME'] ?? 'TestDint';
  final plcTypeName = Platform.environment['PLC_TYPE'] ?? 'controllogix';

  if (gateway == null) {
    test('skipped (PLC_GATEWAY not set)',
        () => print('Set PLC_GATEWAY=ip-of-plc to run integration tests'));
    return;
  }

  Tag<int> newTag() => Tag<int>(DintPlcMapper())
    ..gateway = gateway
    ..name = tagName
    ..protocol = Protocol.abEip
    ..plcType = _plcTypeFor(plcTypeName)
    ..timeout = const Duration(seconds: 5);

  test('synchronous read followed by write round-trips', () {
    final tag = newTag()..initialize();
    tag.read();
    final original = tag.value!;
    tag.value = original + 1;
    tag.write();

    tag.read();
    expect(tag.value, equals(original + 1));

    tag.value = original;
    tag.write();
    tag.dispose();
  });

  test('readAsync completes', () async {
    final tag = newTag()..initialize();
    await tag.readAsync();
    expect(tag.value, isNotNull);
    tag.dispose();
  });

  test('events stream fires ReadCompletedEvent', () async {
    final tag = newTag()..initialize();
    final completer = tag.events.firstWhere((e) => e is ReadCompletedEvent);
    await tag.readAsync();
    final evt = await completer.timeout(const Duration(seconds: 10));
    expect(evt, isNotNull);
    tag.dispose();
  });
}

PlcType _plcTypeFor(String s) => switch (s.toLowerCase()) {
      'controllogix' => PlcType.controlLogix,
      'micro800' => PlcType.micro800,
      'plc5' => PlcType.plc5,
      'slc' || 'slc500' => PlcType.slc500,
      'logixpccc' => PlcType.logixPccc,
      'omron' => PlcType.omron,
      'micrologix' => PlcType.microLogix,
      _ => throw ArgumentError.value(s, 'PLC_TYPE'),
    };
