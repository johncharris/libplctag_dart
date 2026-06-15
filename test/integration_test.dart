@Tags(['integration'])
library;

import 'dart:io';

import 'package:libplctag_dart/data_types/dint_plc_mapper.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/protocol.dart';
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
  final plcType = Platform.environment['PLC_TYPE'] ?? 'controllogix';

  if (gateway == null) {
    test('skipped (PLC_GATEWAY not set)', () => print('Set PLC_GATEWAY=ip-of-plc to run integration tests'));
    return;
  }

  Tag<int> _newTag() {
    return Tag<int>(DintPlcMapper())
      ..gateway = gateway
      ..name = tagName
      ..protocol = Protocol.AllenBradleyEIP
      ..plcType = _plcTypeFor(plcType)
      ..timeout = Duration(seconds: 5);
  }

  test('synchronous read followed by write round-trips', () {
    final tag = _newTag()..initialize();
    tag.Read();
    final original = tag.Value!;
    tag.Value = original + 1;
    tag.Write();

    tag.Read();
    expect(tag.Value, equals(original + 1));

    tag.Value = original;
    tag.Write();
    tag.Dispose();
  });

  test('readAsync completes', () async {
    final tag = _newTag()..initialize();
    await tag.ReadAsync();
    expect(tag.Value, isNotNull);
    tag.Dispose();
  });

  test('events stream fires ReadCompleted', () async {
    final tag = _newTag()..initialize();
    final completer = tag.events.firstWhere((e) => e.runtimeType.toString().contains('ReadCompleted'));
    await tag.ReadAsync();
    final evt = await completer.timeout(Duration(seconds: 10));
    expect(evt, isNotNull);
    tag.Dispose();
  });
}

PlcType _plcTypeFor(String s) {
  switch (s.toLowerCase()) {
    case 'controllogix':
      return PlcType.ControlLogix;
    case 'micro800':
      return PlcType.Micro800;
    case 'plc5':
      return PlcType.Plc5;
    case 'slc':
    case 'slc500':
      return PlcType.Slc500;
    case 'logixpccc':
      return PlcType.LogixPccc;
    case 'omron':
      return PlcType.Omron;
    case 'micrologix':
      return PlcType.MicroLogix;
    default:
      throw Exception('Unknown PLC_TYPE: $s');
  }
}
