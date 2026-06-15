import 'package:libplctag_dart/data_types/plc_mapper.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

/// Maps Dart `bool`s to/from PLC BOOL values.
///
/// ControlLogix packs BOOL arrays as 32-bit words, so [getElementCount]
/// rounds the bit count up to the nearest DINT. Omron uses any non-zero
/// byte as true; ControlLogix uses exactly `0xFF`.
class BoolPlcMapper implements PlcMapper<bool> {
  @override
  PlcType plcType = PlcType.controlLogix;

  @override
  int? get elementSize => 1;

  @override
  List<int>? arrayDimensions = [];

  @override
  int? getElementCount() {
    final dims = arrayDimensions;
    if (dims == null) return null;
    final totalBits = dims.fold<int>(1, (acc, dim) => acc * dim).toDouble();
    return (totalBits / 32.0).ceil();
  }

  @override
  bool decode(Tag tag) => plcType == PlcType.omron
      ? tag.getUInt8(0) != 0
      : tag.getUInt8(0) == 255;

  @override
  void encode(Tag tag, bool value) => tag.setUInt8(0, value ? 255 : 0);

  List<bool> decodeArray(Tag tag) {
    final bitCount = tag.elementCount! * 32;
    final buffer = List<bool>.filled(bitCount, false);
    for (var i = 0; i < bitCount; i++) {
      buffer[i] = tag.getBit(i);
    }
    return buffer;
  }

  void encodeArray(Tag tag, List<bool> values) {
    final bitCount = tag.elementCount! * 32;
    for (var i = 0; i < bitCount && i < values.length; i++) {
      tag.setBit(i, values[i]);
    }
  }

  List<List<bool>> decodeArray2D(Tag tag) {
    final dims = _requireDims(2);
    return _reshape2D(decodeArray(tag), dims[0], dims[1]);
  }

  void encodeArray2D(Tag tag, List<List<bool>> values) {
    encodeArray(tag, [for (final row in values) ...row]);
  }

  List<List<List<bool>>> decodeArray3D(Tag tag) {
    final dims = _requireDims(3);
    return _reshape3D(decodeArray(tag), dims[0], dims[1], dims[2]);
  }

  void encodeArray3D(Tag tag, List<List<List<bool>>> values) {
    encodeArray(tag, [
      for (final plane in values)
        for (final row in plane) ...row,
    ]);
  }

  List<int> _requireDims(int rank) {
    final dims = arrayDimensions;
    if (dims == null || dims.length != rank) {
      throw StateError('arrayDimensions must have rank $rank for this operation');
    }
    return dims;
  }

  List<List<bool>> _reshape2D(List<bool> flat, int rows, int cols) => [
        for (var r = 0; r < rows; r++) flat.sublist(r * cols, (r + 1) * cols),
      ];

  List<List<List<bool>>> _reshape3D(List<bool> flat, int planes, int rows, int cols) {
    final out = <List<List<bool>>>[];
    final planeSize = rows * cols;
    for (var p = 0; p < planes; p++) {
      final planeStart = p * planeSize;
      out.add([
        for (var r = 0; r < rows; r++)
          flat.sublist(planeStart + r * cols, planeStart + (r + 1) * cols),
      ]);
    }
    return out;
  }
}
