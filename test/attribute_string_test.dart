import 'package:libplctag_dart/debug_level.dart';
import 'package:libplctag_dart/native_tag_wrapper.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:test/test.dart';

import 'mock_native_tag.dart';

void main() {
  test('omits null fields', () {
    final mock = MockNativeTag();
    NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = '192.168.1.1'
      ..name = 'MyTag'
      ..initialize();

    final attrs = mock.createAttributeStrings.single;
    expect(attrs, contains('protocol=ab_eip'));
    expect(attrs, contains('gateway=192.168.1.1'));
    expect(attrs, contains('name=MyTag'));
    expect(attrs, isNot(contains('path=')));
    expect(attrs, isNot(contains('plc=')));
  });

  test('renders Omron as "omron-njnx"', () {
    final mock = MockNativeTag();
    NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = 'x'
      ..name = 'y'
      ..plcType = PlcType.omron
      ..initialize();
    expect(mock.createAttributeStrings.single, contains('plc=omron-njnx'));
  });

  test('renders ControlLogix as "controllogix"', () {
    final mock = MockNativeTag();
    NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = 'x'
      ..name = 'y'
      ..plcType = PlcType.controlLogix
      ..initialize();
    expect(mock.createAttributeStrings.single, contains('plc=controllogix'));
  });

  test('booleans become 0 / 1', () {
    final mock = MockNativeTag();
    NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = 'x'
      ..name = 'y'
      ..stringIsZeroTerminated = true
      ..stringIsFixedLength = false
      ..useConnectedMessaging = true
      ..initialize();

    final attrs = mock.createAttributeStrings.single;
    expect(attrs, contains('str_is_zero_terminated=1'));
    expect(attrs, contains('str_is_fixed_length=0'));
    expect(attrs, contains('use_connected_msg=1'));
  });

  test('str_is_zero_terminated uses its own value (Phase 1 regression test)', () {
    final mock = MockNativeTag();
    NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = 'x'
      ..name = 'y'
      ..stringIsFixedLength = false
      ..stringIsZeroTerminated = true
      ..initialize();

    final attrs = mock.createAttributeStrings.single;
    expect(attrs, contains('str_is_fixed_length=0'));
    expect(attrs, contains('str_is_zero_terminated=1'));
  });

  test('debug level is emitted when non-None', () {
    final mock = MockNativeTag();
    NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = 'x'
      ..name = 'y'
      ..debugLevel = DebugLevel.info
      ..initialize();
    expect(mock.createAttributeStrings.single, contains('debug=${DebugLevel.info.value}'));
  });

  test('debug level None is omitted', () {
    final mock = MockNativeTag();
    NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = 'x'
      ..name = 'y'
      ..initialize();
    expect(mock.createAttributeStrings.single, isNot(contains('debug=')));
  });

  test('elem_size and elem_count are emitted as strings', () {
    final mock = MockNativeTag();
    NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = 'x'
      ..name = 'y'
      ..elementSize = 4
      ..elementCount = 10
      ..initialize();
    final attrs = mock.createAttributeStrings.single;
    expect(attrs, contains('elem_size=4'));
    expect(attrs, contains('elem_count=10'));
  });

  test('byte orders are emitted as-is', () {
    final mock = MockNativeTag();
    NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = 'x'
      ..name = 'y'
      ..int16ByteOrder = '10'
      ..int32ByteOrder = '3210'
      ..int64ByteOrder = '76543210'
      ..float32ByteOrder = '3210'
      ..float64ByteOrder = '76543210'
      ..initialize();
    final attrs = mock.createAttributeStrings.single;
    expect(attrs, contains('int16_byte_order=10'));
    expect(attrs, contains('int32_byte_order=3210'));
    expect(attrs, contains('int64_byte_order=76543210'));
    expect(attrs, contains('float32_byte_order=3210'));
    expect(attrs, contains('float64_byte_order=76543210'));
  });
}
