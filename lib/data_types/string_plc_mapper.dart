import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

class StringPlcMapper extends PlcMapperBase<String> {
  int? get elementSize {
    switch (plcType) {
      case PlcType.ControlLogix:
        return 88;
      case PlcType.Plc5:
        return 84;
      case PlcType.Slc500:
        return 84;
      case PlcType.LogixPccc:
        return 84;
      case PlcType.Micro800:
        return 256; //To be Confirmed
      case PlcType.MicroLogix:
        return 84;
      default:
        throw new Exception();
    }
  }

  String decodeAtOffset(Tag tag, int offset) => tag.getString(offset);
  void encodeAtOffset(Tag tag, int offset, String value) => tag.setString(offset, value);
}
