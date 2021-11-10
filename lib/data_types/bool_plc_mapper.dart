import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

import 'iplc_mapper.dart';

class BoolPlcMapper extends IPlcMapper<bool> //, IPlcMapper<bool[]>, IPlcMapper<bool[,]>, IPlcMapper<bool[,,]>
{
  int? get elementSize => 1;

  int? getElementCount() {
    if (arrayDimensions == null) return null;

    //TODO: Test -> I'm not confident that the overall bool count is packed as a 1D array and not packed by dimension.
    //Multiply dimensions for total elements
    double totalElements = arrayDimensions!.fold<int>(1, (x, y) => x * y).toDouble();
    return (totalElements / 32.0).ceil();
  }

  int? SetArrayLength(int? elementCount) => (elementCount!.toDouble() / 32.0).ceil();

  List<bool> decodeArray(Tag tag) {
    if (elementSize == null) throw new Exception("ElementSize cannot be null for array decoding");

    List<bool> buffer = List.filled(tag.ElementCount! * 32, false);

    for (int ii = 0; ii < tag.ElementCount! * 32; ii++) {
      buffer[ii] = tag.getBit(ii);
    }
    return buffer;
  }

  void encodeArray(Tag tag, List<bool> values) {
    for (int ii = 0; ii < tag.ElementCount! * 32; ii++) {
      tag.setBit(ii, values[ii]);
    }
  }

  bool decode(Tag tag) => tag.plcType == PlcType.Omron ? tag.getUInt8(0) != 0 : tag.getUInt8(0) == 255;

  void encode(Tag tag, bool value) => tag.setUInt8(0, value == true ? 255 : 0);

  List<int>? _arrayDimensions = [];
  List<int>? get arrayDimensions => _arrayDimensions;
  set arrayDimensions(value) => _arrayDimensions = value;

  PlcType _plcType = PlcType.ControlLogix;
  PlcType get plcType => _plcType;
  set plcType(value) => _plcType = value;

  // bool[] IPlcMapper<bool[]>.Decode(Tag tag) => DecodeArray(tag);

  // void IPlcMapper<bool[]>.Encode(Tag tag, bool[] value) => EncodeArray(tag, value);

  // bool[,] IPlcMapper<bool[,]>.Decode(Tag tag) => DecodeArray(tag).To2DArray(ArrayDimensions[0], ArrayDimensions[1]);

  // void IPlcMapper<bool[,]>.Encode(Tag tag, bool[,] value) => EncodeArray(tag, value.To1DArray());

  // bool[,,] IPlcMapper<bool[,,]>.Decode(Tag tag) => DecodeArray(tag).To3DArray(ArrayDimensions[0], ArrayDimensions[1], ArrayDimensions[2]);

  // void IPlcMapper<bool[,,]>.Encode(Tag tag, bool[,,] value) => EncodeArray(tag, value.To1DArray());

}
