import 'package:libplctag_dart/data_types/iplc_mapper.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

abstract class PlcMapperBase<T> extends IPlcMapper<T> {
  PlcType _plcType = PlcType.ControlLogix;
  PlcType get plcType => _plcType;
  set plcType(value) => _plcType = value;

  List<int>? _arrayDimensions = null;
  List<int>? get arrayDimensions => _arrayDimensions;
  set arrayDimensions(value) => _arrayDimensions = value;

  // Multiply all the dimensions together to get the total flat element count.
  @override
  int? getElementCount() => arrayDimensions?.fold(1, (x, y) => x! * y);

  T decode(Tag tag) => decodeAtOffset(tag, 0);
  T decodeAtOffset(Tag tag, int offset);

  void encode(Tag tag, T value) => encodeAtOffset(tag, 0, value);
  void encodeAtOffset(Tag tag, int offset, T value);

  /// Decode a flat 1D array of values from the tag buffer.
  List<T> decodeArray(Tag tag) {
    if (elementSize == null) throw new Exception("ElementSize cannot be null for array decoding");

    final tagSize = tag.getSize();
    final buffer = <T>[];

    var offset = 0;
    while (offset < tagSize) {
      buffer.add(decodeAtOffset(tag, offset));
      offset += elementSize!;
    }

    return buffer;
  }

  /// Encode a flat 1D array of values into the tag buffer.
  void encodeArray(Tag tag, List<T> values) {
    if (elementSize == null) throw new Exception("ElementSize cannot be null for array encoding");

    var offset = 0;
    for (final item in values) {
      encodeAtOffset(tag, offset, item);
      offset += elementSize!;
    }
  }

  /// Decode the tag buffer as a 2D array shaped by [arrayDimensions]. Row-major.
  List<List<T>> decodeArray2D(Tag tag) {
    final dims = _requireDims(2);
    return _reshape2D(decodeArray(tag), dims[0], dims[1]);
  }

  /// Encode a 2D row-major array into the tag buffer.
  void encodeArray2D(Tag tag, List<List<T>> values) {
    final flat = <T>[];
    for (final row in values) flat.addAll(row);
    encodeArray(tag, flat);
  }

  /// Decode the tag buffer as a 3D array shaped by [arrayDimensions].
  List<List<List<T>>> decodeArray3D(Tag tag) {
    final dims = _requireDims(3);
    return _reshape3D(decodeArray(tag), dims[0], dims[1], dims[2]);
  }

  /// Encode a 3D array into the tag buffer.
  void encodeArray3D(Tag tag, List<List<List<T>>> values) {
    final flat = <T>[];
    for (final plane in values) {
      for (final row in plane) {
        flat.addAll(row);
      }
    }
    encodeArray(tag, flat);
  }

  List<int> _requireDims(int rank) {
    final dims = arrayDimensions;
    if (dims == null || dims.length != rank) {
      throw new Exception("arrayDimensions must have rank $rank for this operation");
    }
    return dims;
  }

  List<List<T>> _reshape2D(List<T> flat, int rows, int cols) {
    final out = <List<T>>[];
    for (var r = 0; r < rows; r++) {
      out.add(flat.sublist(r * cols, (r + 1) * cols));
    }
    return out;
  }

  List<List<List<T>>> _reshape3D(List<T> flat, int planes, int rows, int cols) {
    final out = <List<List<T>>>[];
    final planeSize = rows * cols;
    for (var p = 0; p < planes; p++) {
      final planeStart = p * planeSize;
      final plane = <List<T>>[];
      for (var r = 0; r < rows; r++) {
        final rowStart = planeStart + r * cols;
        plane.add(flat.sublist(rowStart, rowStart + cols));
      }
      out.add(plane);
    }
    return out;
  }
}
