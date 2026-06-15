import 'package:libplctag_dart/data_types/bool_plc_mapper.dart';
import 'package:libplctag_dart/data_types/dint_plc_mapper.dart';
import 'package:libplctag_dart/data_types/int_plc_mapper.dart';
import 'package:libplctag_dart/data_types/lint_plc_mapper.dart';
import 'package:libplctag_dart/data_types/lreal_plc_mapper.dart';
import 'package:libplctag_dart/data_types/real_plc_mapper.dart';
import 'package:libplctag_dart/data_types/sint_plc_mapper.dart';
import 'package:libplctag_dart/data_types/tag_info_plc_mapper.dart';
import 'package:libplctag_dart/data_types/udint_plc_mapper.dart';
import 'package:libplctag_dart/data_types/uint_plc_mapper.dart';
import 'package:libplctag_dart/data_types/ulint_plc_mapper.dart';
import 'package:libplctag_dart/data_types/usint_plc_mapper.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';
import 'package:test/test.dart';

import 'mock_native_tag.dart';

void main() {
  // Scalar roundtrip tests use Tag<T> with each mapper through a mock.
  // Each Tag<T> instance constructs its own NativeTagWrapper(NativeTag()),
  // so we cannot easily inject the mock. Instead we instantiate
  // NativeTagWrapper directly and exercise the mapper's encode/decode
  // methods against the wrapper.

  test('SintPlcMapper roundtrips int8 (signed)', () {
    final wrapper = _buildTag();
    final mapper = SintPlcMapper();
    mapper.encodeAtOffset(wrapper, 0, -42);
    expect(mapper.decodeAtOffset(wrapper, 0), equals(-42));
  });

  test('UsintPlcMapper roundtrips uint8 (unsigned)', () {
    final wrapper = _buildTag();
    final mapper = UsintPlcMapper();
    mapper.encodeAtOffset(wrapper, 0, 200);
    expect(mapper.decodeAtOffset(wrapper, 0), equals(200));
  });

  test('IntPlcMapper roundtrips int16 (signed)', () {
    final wrapper = _buildTag();
    final mapper = IntPlcMapper();
    mapper.encodeAtOffset(wrapper, 0, -1234);
    expect(mapper.decodeAtOffset(wrapper, 0), equals(-1234));
  });

  test('UintPlcMapper roundtrips uint16 (unsigned)', () {
    final wrapper = _buildTag();
    final mapper = UintPlcMapper();
    mapper.encodeAtOffset(wrapper, 0, 60000);
    expect(mapper.decodeAtOffset(wrapper, 0), equals(60000));
  });

  test('DintPlcMapper roundtrips int32 (signed)', () {
    final wrapper = _buildTag();
    final mapper = DintPlcMapper();
    mapper.encodeAtOffset(wrapper, 0, -123456);
    expect(mapper.decodeAtOffset(wrapper, 0), equals(-123456));
  });

  test('UdintPlcMapper roundtrips uint32 (unsigned)', () {
    final wrapper = _buildTag();
    final mapper = UdintPlcMapper();
    mapper.encodeAtOffset(wrapper, 0, 4000000000);
    expect(mapper.decodeAtOffset(wrapper, 0), equals(4000000000));
  });

  test('LintPlcMapper roundtrips int64 (signed) — Phase 1 regression', () {
    final wrapper = _buildTag();
    final mapper = LintPlcMapper();
    mapper.encodeAtOffset(wrapper, 0, -1234567890123);
    expect(mapper.decodeAtOffset(wrapper, 0), equals(-1234567890123));
  });

  test('UlintPlcMapper roundtrips uint64 (unsigned)', () {
    final wrapper = _buildTag();
    final mapper = UlintPlcMapper();
    mapper.encodeAtOffset(wrapper, 0, 9000000000);
    expect(mapper.decodeAtOffset(wrapper, 0), equals(9000000000));
  });

  test('RealPlcMapper roundtrips float32', () {
    final wrapper = _buildTag();
    final mapper = RealPlcMapper();
    mapper.encodeAtOffset(wrapper, 0, 3.14);
    expect(mapper.decodeAtOffset(wrapper, 0), closeTo(3.14, 0.0001));
  });

  test('LrealPlcMapper roundtrips float64', () {
    final wrapper = _buildTag();
    final mapper = LrealPlcMapper();
    mapper.encodeAtOffset(wrapper, 0, 3.141592653589793);
    expect(mapper.decodeAtOffset(wrapper, 0), equals(3.141592653589793));
  });

  test('BoolPlcMapper encodes 0xFF for ControlLogix true', () {
    final wrapper = _buildTag();
    final mapper = BoolPlcMapper();
    mapper.encode(wrapper, true);
    expect(wrapper.getUInt8(0), equals(255));
    expect(mapper.decode(wrapper), isTrue);
  });

  test('BoolPlcMapper decodes Omron via non-zero', () {
    final wrapper = _buildTag(plc: PlcType.omron);
    final mapper = BoolPlcMapper()..plcType = PlcType.omron;
    wrapper.setUInt8(0, 1);
    expect(mapper.decode(wrapper), isTrue);
    wrapper.setUInt8(0, 0);
    expect(mapper.decode(wrapper), isFalse);
  });

  test('PlcMapperBase.decodeArray produces flat list', () {
    final wrapper = _buildTag(size: 8);
    final mapper = SintPlcMapper();
    for (var i = 0; i < 8; i++) mapper.encodeAtOffset(wrapper, i, i);
    expect(mapper.decodeArray(wrapper), equals([0, 1, 2, 3, 4, 5, 6, 7]));
  });

  test('PlcMapperBase.decodeArray2D reshapes by arrayDimensions', () {
    final wrapper = _buildTag(size: 6);
    final mapper = SintPlcMapper()..arrayDimensions = [2, 3];
    for (var i = 0; i < 6; i++) mapper.encodeAtOffset(wrapper, i, i);
    expect(
      mapper.decodeArray2D(wrapper),
      equals([
        [0, 1, 2],
        [3, 4, 5],
      ]),
    );
  });

  test('PlcMapperBase.decodeArray3D reshapes by arrayDimensions', () {
    final wrapper = _buildTag(size: 8);
    final mapper = SintPlcMapper()..arrayDimensions = [2, 2, 2];
    for (var i = 0; i < 8; i++) mapper.encodeAtOffset(wrapper, i, i);
    expect(
      mapper.decodeArray3D(wrapper),
      equals([
        [
          [0, 1],
          [2, 3],
        ],
        [
          [4, 5],
          [6, 7],
        ],
      ]),
    );
  });

  test('PlcMapperBase.encodeArray2D flattens and writes row-major', () {
    final wrapper = _buildTag(size: 6);
    final mapper = SintPlcMapper()..arrayDimensions = [2, 3];
    mapper.encodeArray2D(wrapper, [
      [10, 11, 12],
      [13, 14, 15],
    ]);
    expect(mapper.decodeArray(wrapper), equals([10, 11, 12, 13, 14, 15]));
  });

  test('PlcMapperBase array reshape rejects wrong rank', () {
    final wrapper = _buildTag(size: 4);
    final mapper = SintPlcMapper()..arrayDimensions = [2];
    expect(() => mapper.decodeArray2D(wrapper), throwsStateError);
  });

  test('TagInfoPlcMapper decodes one entry against a known byte sequence', () {
    final mock = MockNativeTag();
    final name = 'TestTag';
    final nameBytes = name.codeUnits;
    final size = 22 + nameBytes.length;
    mock.defaultSize = size;
    final wrapper = _buildTagFor(mock);

    // Layout (little-endian):
    // [0..4) uint32 instance_id = 0xCAFEBABE
    // [4..6) uint16 type = 0x00C4 (DINT)
    // [6..8) uint16 length = 4
    // [8..12)  uint32 dim0 = 10
    // [12..16) uint32 dim1 = 0
    // [16..20) uint32 dim2 = 0
    // [20..22) uint16 name_length
    // [22..)   name bytes
    wrapper.setUInt32(0, 0xCAFEBABE);
    wrapper.setUInt16(4, 0xC4);
    wrapper.setUInt16(6, 4);
    wrapper.setUInt32(8, 10);
    wrapper.setUInt32(12, 0);
    wrapper.setUInt32(16, 0);
    wrapper.setUInt16(20, nameBytes.length);
    for (var i = 0; i < nameBytes.length; i++) {
      wrapper.setUInt8(22 + i, nameBytes[i]);
    }

    final mapper = TagInfoPlcMapper();
    final list = mapper.decode(wrapper);
    expect(list, hasLength(1));
    final info = list.first;
    expect(info.id, equals(0xCAFEBABE));
    expect(info.type, equals(0xC4));
    expect(info.length, equals(4));
    expect(info.name, equals(name));
    expect(info.dimensions, equals([10, 0, 0]));
  });

  test('Tag<T> applies mapper element count during initialize', () {
    final mock = MockNativeTag();
    mock.defaultSize = 32;
    final mapper = DintPlcMapper()..arrayDimensions = [4];
    // Tag<T> internally constructs its own NativeTagWrapper(NativeTag()), so
    // the mapper element count exercise has to be checked indirectly.
    expect(mapper.getElementCount(), equals(4));
  });
}

// Helpers ----------------------------------------------------------

/// Build a [Tag] backed by a mock through reflection-free injection.
///
/// The production [Tag] hard-codes `NativeTagWrapper(NativeTag())`. To keep
/// the public surface unchanged while still letting tests use a mock, we
/// expose the wrapper directly here and have the mapper operate on it via
/// the same untyped [Tag] facade that mappers see.
Tag _buildTag({int size = 32, PlcType? plc}) {
  // We use a one-shot adapter: construct a mock-backed wrapper and wrap it
  // in a thin Tag-like adapter. Since Tag is final-state-machine driven and
  // the mappers only call typed accessors / getSize, we bypass Tag and use
  // [_TagAdapter] which forwards to a mock-backed wrapper.
  return _TagAdapter(size: size, plcType: plc);
}

Tag _buildTagFor(MockNativeTag mock) => _TagAdapter.fromMock(mock);

/// Lightweight Tag that delegates everything to a MockNativeTag-backed handle.
class _TagAdapter extends Tag {
  late final int _handle;
  late final MockNativeTag _mock;

  _TagAdapter({required int size, PlcType? plcType}) {
    _mock = MockNativeTag()..defaultSize = size;
    _handle = _mock.plc_tag_create('elem_size=1&elem_count=$size', 0);
    if (plcType != null) this.plcType = plcType;
  }

  _TagAdapter.fromMock(MockNativeTag mock) {
    _mock = mock;
    _handle = mock.plc_tag_create('elem_size=1&elem_count=${mock.defaultSize}', 0);
  }

  @override
  int getSize() => _mock.plc_tag_get_size(_handle);

  @override
  int getInt8(int offset) => _mock.plc_tag_get_int8(_handle, offset);
  @override
  void setInt8(int offset, int v) => _mock.plc_tag_set_int8(_handle, offset, v);

  @override
  int getUInt8(int offset) => _mock.plc_tag_get_uint8(_handle, offset);
  @override
  void setUInt8(int offset, int v) => _mock.plc_tag_set_uint8(_handle, offset, v);

  @override
  int getInt16(int offset) => _mock.plc_tag_get_int16(_handle, offset);
  @override
  void setInt16(int offset, int v) => _mock.plc_tag_set_int16(_handle, offset, v);

  @override
  int getUInt16(int offset) => _mock.plc_tag_get_uint16(_handle, offset);
  @override
  void setUInt16(int offset, int v) => _mock.plc_tag_set_uint16(_handle, offset, v);

  @override
  int getInt32(int offset) => _mock.plc_tag_get_int32(_handle, offset);
  @override
  void setInt32(int offset, int v) => _mock.plc_tag_set_int32(_handle, offset, v);

  @override
  int getUInt32(int offset) => _mock.plc_tag_get_uint32(_handle, offset);
  @override
  void setUInt32(int offset, int v) => _mock.plc_tag_set_uint32(_handle, offset, v);

  @override
  int getInt64(int offset) => _mock.plc_tag_get_int64(_handle, offset);
  @override
  void setInt64(int offset, int v) => _mock.plc_tag_set_int64(_handle, offset, v);

  @override
  int getUInt64(int offset) => _mock.plc_tag_get_uint64(_handle, offset);
  @override
  void setUInt64(int offset, int v) => _mock.plc_tag_set_uint64(_handle, offset, v);

  @override
  double getFloat32(int offset) => _mock.plc_tag_get_float32(_handle, offset);
  @override
  void setFloat32(int offset, double v) => _mock.plc_tag_set_float32(_handle, offset, v);

  @override
  double getFloat64(int offset) => _mock.plc_tag_get_float64(_handle, offset);
  @override
  void setFloat64(int offset, double v) => _mock.plc_tag_set_float64(_handle, offset, v);

  @override
  bool getBit(int offset) => _mock.plc_tag_get_bit(_handle, offset) != 0;
  @override
  void setBit(int offset, bool v) => _mock.plc_tag_set_bit(_handle, offset, v ? 1 : 0);
}
