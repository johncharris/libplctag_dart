import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/tag.dart';

class UlintPlcMapper extends PlcMapperBase<int> {
  @override
  int decodeAtOffset(Tag tag, int offset) => tag.getUInt64(offset);

  @override
  int? get elementSize => 8;

  @override
  void encodeAtOffset(Tag tag, int offset, int value) => tag.setUInt64(offset, value);
}
