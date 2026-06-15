import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

/// Maps Dart `String` values to/from PLC string types.
///
/// Element size depends on the PLC family — pick the right one before
/// calling `getElementCount()` or letting the tag initialize.
class StringPlcMapper extends PlcMapperBase<String> {
  @override
  int? get elementSize => switch (plcType) {
        PlcType.controlLogix => 88,
        PlcType.plc5 || PlcType.slc500 || PlcType.logixPccc || PlcType.microLogix => 84,
        // Micro800 string size is not officially documented; 256 is a
        // conservative guess used by libplctag.NET.
        PlcType.micro800 => 256,
        PlcType.omron =>
          throw UnsupportedError('Omron string sizing is not yet implemented'),
      };

  @override
  String decodeAtOffset(Tag tag, int offset) => tag.getString(offset);

  @override
  void encodeAtOffset(Tag tag, int offset, String value) => tag.setString(offset, value);
}
