import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/tag.dart';

class RealPlcMapper extends PlcMapperBase<double> {
  @override
  double decodeAtOffset(Tag tag, int offset) => tag.getFloat32(offset);

  @override
  int? get elementSize => 4;

  @override
  void encodeAtOffset(Tag tag, int offset, double value) => tag.setFloat32(offset, value);
}
