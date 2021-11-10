import 'package:libplctag_dart/data_types/iplc_mapper.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

abstract class PlcMapperBase<T> extends IPlcMapper<T> // IPlcMapper<T[]>, // IPlcMapper<T[,]>, IPlcMapper<T[,,]>
{
  PlcType _plcType = PlcType.ControlLogix;
  PlcType get plcType => _plcType;
  set plcType(value) => _plcType = value;

  List<int>? _arrayDimensions = null;
  List<int>? get arrayDimensions => _arrayDimensions;
  set arrayDimensions(value) => _arrayDimensions = value;

  //Multiply all the dimensions to get total elements
  @override
  int? getElementCount() => arrayDimensions?.fold(1, (x, y) => x! * y);

  List<T> _decodeArray(Tag tag) {
    if (elementSize == null) throw new Exception("ElementSize cannot be null for array decoding");

    var buffer = <T>[];

    var tagSize = tag.getSize();

    int offset = 0;
    while (offset < tagSize) {
      buffer.add(decodeAtOffset(tag, offset));
      offset += elementSize!;
    }

    return buffer;
  }

  void _encodeArray(Tag tag, List<T> values) {
    if (elementSize == null) {
      throw new Exception("ElementSize cannot be null for array encoding");
    }

    int offset = 0;
    for (var item in values) {
      encodeAtOffset(tag, offset, item);
      offset += elementSize!;
    }
  }

  T decode(Tag tag) => decodeAtOffset(tag, 0);
  T decodeAtOffset(Tag tag, int offset);

  void encode(Tag tag, T value) => encodeAtOffset(tag, 0, value);

  void encodeAtOffset(Tag tag, int offset, T value);

  void encodeList(Tag tag, List<T> value) => _encodeArray(tag, value);

  // List<T> IPlcMapper<List<T>>.Decode(Tag tag) => DecodeArray(tag);

  // T[,] IPlcMapper<T[,]>.Decode(Tag tag) => DecodeArray(tag).To2DArray<T>(ArrayDimensions[0], ArrayDimensions[1]);

  // void IPlcMapper<T[,]>.Encode(Tag tag, T[,] value) => EncodeArray(tag, value.To1DArray());

  // T[,,] IPlcMapper<T[,,]>.Decode(Tag tag) => DecodeArray(tag).To3DArray<T>(ArrayDimensions[0], ArrayDimensions[1], ArrayDimensions[2]);

  // void IPlcMapper<T[,,]>.Encode(Tag tag, T[,,] value) => EncodeArray(tag, value.To1DArray());
}
