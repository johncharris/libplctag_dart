import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/tag.dart';

class DintPlcMapper extends PlcMapperBase<int> {
  @override
  int decodeAtOffset(Tag tag, int offset) => tag.getInt32(offset);

  @override
  int? get elementSize => 4;

  @override
  void encodeAtOffset(Tag tag, int offset, int value) => tag.setInt32(offset, value);
}
