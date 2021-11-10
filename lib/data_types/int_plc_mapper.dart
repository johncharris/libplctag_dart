import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/tag.dart';

class IntPlcMapper extends PlcMapperBase<int> {
  @override
  int decodeAtOffset(Tag tag, int offset) => tag.GetInt16(offset);

  @override
  int? get elementSize => 2;

  @override
  void encodeAtOffset(Tag tag, int offset, int value) => tag.SetInt16(offset, value);
}
