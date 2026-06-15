import 'package:libplctag_dart/data_types/plc_mapper.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

/// Base class for scalar/array PLC value mappers.
///
/// Subclasses implement [decodeAtOffset]/[encodeAtOffset] for a single
/// element; this class handles flat arrays and 2D/3D reshaping.
abstract class PlcMapperBase<T> implements PlcMapper<T> {
  @override
  PlcType plcType = PlcType.controlLogix;

  @override
  List<int>? arrayDimensions;

  @override
  int? getElementCount() => arrayDimensions?.fold(1, (acc, dim) => acc! * dim);

  @override
  T decode(Tag tag) => decodeAtOffset(tag, 0);
  T decodeAtOffset(Tag tag, int offset);

  @override
  void encode(Tag tag, T value) => encodeAtOffset(tag, 0, value);
  void encodeAtOffset(Tag tag, int offset, T value);

  /// Decode a flat 1D array from the tag buffer.
  List<T> decodeArray(Tag tag) {
    final size = _requireElementSize();
    final tagSize = tag.getSize();
    final buffer = <T>[];
    for (var offset = 0; offset < tagSize; offset += size) {
      buffer.add(decodeAtOffset(tag, offset));
    }
    return buffer;
  }

  /// Encode a flat 1D array into the tag buffer.
  void encodeArray(Tag tag, List<T> values) {
    final size = _requireElementSize();
    var offset = 0;
    for (final item in values) {
      encodeAtOffset(tag, offset, item);
      offset += size;
    }
  }

  /// Decode the tag buffer as a 2D row-major array shaped by [arrayDimensions].
  List<List<T>> decodeArray2D(Tag tag) {
    final dims = _requireDims(2);
    return _reshape2D(decodeArray(tag), dims[0], dims[1]);
  }

  /// Encode a 2D row-major array into the tag buffer.
  void encodeArray2D(Tag tag, List<List<T>> values) {
    encodeArray(tag, [for (final row in values) ...row]);
  }

  /// Decode the tag buffer as a 3D array shaped by [arrayDimensions].
  List<List<List<T>>> decodeArray3D(Tag tag) {
    final dims = _requireDims(3);
    return _reshape3D(decodeArray(tag), dims[0], dims[1], dims[2]);
  }

  /// Encode a 3D array into the tag buffer.
  void encodeArray3D(Tag tag, List<List<List<T>>> values) {
    encodeArray(tag, [
      for (final plane in values)
        for (final row in plane) ...row,
    ]);
  }

  int _requireElementSize() {
    final size = elementSize;
    if (size == null) {
      throw StateError('elementSize must be non-null for array decode/encode');
    }
    return size;
  }

  List<int> _requireDims(int rank) {
    final dims = arrayDimensions;
    if (dims == null || dims.length != rank) {
      throw StateError('arrayDimensions must have rank $rank for this operation');
    }
    return dims;
  }

  List<List<T>> _reshape2D(List<T> flat, int rows, int cols) => [
        for (var r = 0; r < rows; r++) flat.sublist(r * cols, (r + 1) * cols),
      ];

  List<List<List<T>>> _reshape3D(List<T> flat, int planes, int rows, int cols) {
    final out = <List<List<T>>>[];
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
