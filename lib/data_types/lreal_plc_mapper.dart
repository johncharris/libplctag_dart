import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/tag.dart';

class LrealPlcMapper extends PlcMapperBase<double> {
  @override
  double decodeAtOffset(Tag tag, int offset) => tag.getFloat64(offset);

  @override
  int? get elementSize => 8;

  @override
  void encodeAtOffset(Tag tag, int offset, double value) => tag.setFloat64(offset, value);
}
