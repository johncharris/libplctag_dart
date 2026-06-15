import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/tag.dart';

class UdintPlcMapper extends PlcMapperBase<int> {
  @override
  int decodeAtOffset(Tag tag, int offset) => tag.getUInt32(offset);

  @override
  int? get elementSize => 4;

  @override
  void encodeAtOffset(Tag tag, int offset, int value) => tag.setUInt32(offset, value);
}
