import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/tag.dart';

class SintPlcMapper extends PlcMapperBase<int> {
  @override
  int decodeAtOffset(Tag tag, int offset) => tag.GetInt8(offset);

  @override
  int? get elementSize => 1;

  @override
  void encodeAtOffset(Tag tag, int offset, int value) => tag.SetInt8(offset, value);
}
