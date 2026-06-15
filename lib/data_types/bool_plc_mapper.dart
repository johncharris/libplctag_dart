import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

import 'iplc_mapper.dart';

class BoolPlcMapper extends IPlcMapper<bool> {
  int? get elementSize => 1;

  int? getElementCount() {
    if (arrayDimensions == null) return null;

    // BOOL arrays are packed as 32-bit words in ControlLogix; round up.
    double totalElements = arrayDimensions!.fold<int>(1, (x, y) => x * y).toDouble();
    return (totalElements / 32.0).ceil();
  }

  List<bool> decodeArray(Tag tag) {
    if (elementSize == null) throw new Exception("ElementSize cannot be null for array decoding");

    final bitCount = tag.ElementCount! * 32;
    final buffer = List.filled(bitCount, false);
    for (var ii = 0; ii < bitCount; ii++) {
      buffer[ii] = tag.getBit(ii);
    }
    return buffer;
  }

  void encodeArray(Tag tag, List<bool> values) {
    final bitCount = tag.ElementCount! * 32;
    for (var ii = 0; ii < bitCount && ii < values.length; ii++) {
      tag.setBit(ii, values[ii]);
    }
  }

  List<List<bool>> decodeArray2D(Tag tag) {
    final dims = _requireDims(2);
    return _reshape2D(decodeArray(tag), dims[0], dims[1]);
  }

  void encodeArray2D(Tag tag, List<List<bool>> values) {
    final flat = <bool>[];
    for (final row in values) flat.addAll(row);
    encodeArray(tag, flat);
  }

  List<List<List<bool>>> decodeArray3D(Tag tag) {
    final dims = _requireDims(3);
    return _reshape3D(decodeArray(tag), dims[0], dims[1], dims[2]);
  }

  void encodeArray3D(Tag tag, List<List<List<bool>>> values) {
    final flat = <bool>[];
    for (final plane in values) {
      for (final row in plane) flat.addAll(row);
    }
    encodeArray(tag, flat);
  }

  bool decode(Tag tag) => tag.plcType == PlcType.Omron ? tag.getUInt8(0) != 0 : tag.getUInt8(0) == 255;

  void encode(Tag tag, bool value) => tag.setUInt8(0, value == true ? 255 : 0);

  List<int>? _arrayDimensions = [];
  List<int>? get arrayDimensions => _arrayDimensions;
  set arrayDimensions(value) => _arrayDimensions = value;

  PlcType _plcType = PlcType.ControlLogix;
  PlcType get plcType => _plcType;
  set plcType(value) => _plcType = value;

  List<int> _requireDims(int rank) {
    final dims = arrayDimensions;
    if (dims == null || dims.length != rank) {
      throw new Exception("arrayDimensions must have rank $rank for this operation");
    }
    return dims;
  }

  List<List<bool>> _reshape2D(List<bool> flat, int rows, int cols) {
    final out = <List<bool>>[];
    for (var r = 0; r < rows; r++) {
      out.add(flat.sublist(r * cols, (r + 1) * cols));
    }
    return out;
  }

  List<List<List<bool>>> _reshape3D(List<bool> flat, int planes, int rows, int cols) {
    final out = <List<List<bool>>>[];
    final planeSize = rows * cols;
    for (var p = 0; p < planes; p++) {
      final planeStart = p * planeSize;
      final plane = <List<bool>>[];
      for (var r = 0; r < rows; r++) {
        final rowStart = planeStart + r * cols;
        plane.add(flat.sublist(rowStart, rowStart + cols));
      }
      out.add(plane);
    }
    return out;
  }
}
