import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/tag.dart';

class LintPlcMapper extends PlcMapperBase<int> {
  @override
  int decodeAtOffset(Tag tag, int offset) => tag.GetInt32(offset);

  @override
  int? get elementSize => 8;

  @override
  void encodeAtOffset(Tag tag, int offset, int value) => tag.SetInt64(offset, value);
}
