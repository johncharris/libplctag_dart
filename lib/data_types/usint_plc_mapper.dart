import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/tag.dart';

class UsintPlcMapper extends PlcMapperBase<int> {
  @override
  int decodeAtOffset(Tag tag, int offset) => tag.getUInt8(offset);

  @override
  int? get elementSize => 1;

  @override
  void encodeAtOffset(Tag tag, int offset, int value) => tag.setUInt8(offset, value);
}
