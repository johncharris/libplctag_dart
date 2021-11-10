import 'dart:convert';
import 'dart:io';

import 'package:libplctag_dart/data_types/iplc_mapper.dart';
import 'package:libplctag_dart/data_types/tag_info.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';
import 'dart:math' as math;

import 'package:tuple/tuple.dart';

class TagInfoPlcMapper implements IPlcMapper<List<TagInfo>> {
  static const TAG_STRING_SIZE = 200;

  PlcType _plcType = PlcType.ControlLogix;
  PlcType get plcType => _plcType;
  set plcType(value) => _plcType = value;

  //TODO: Is null appropriate since it's unknown?
  int? get elementSize => null;
  List<int>? get arrayDimensions => null;
  set arrayDimensions(value) => throw new Exception("This plcMapper can only be used to read Tag Information");

  Tuple2<TagInfo, int> DecodeTagInfo(Tag tag, int offset) {
    var tagInstanceId = tag.GetUInt32(offset);
    var tagType = tag.GetUInt16(offset + 4);
    var tagLength = tag.GetUInt16(offset + 6);
    var tagArrayDims = <int>[tag.GetUInt32(offset + 8), tag.GetUInt32(offset + 12), tag.GetUInt32(offset + 16)];

    var apparentTagNameLength = tag.GetUInt16(offset + 20);
    var actualTagNameLength = math.min(apparentTagNameLength, TAG_STRING_SIZE * 2 - 1);

    var tagNameGenerator = BytesBuilder();
    for (int i = offset + 22; i < offset + 22 + actualTagNameLength; i++) {
      tagNameGenerator.addByte(tag.GetUInt8(i));
    }
    var tagNameBytes = tagNameGenerator.toBytes();

    var tagName = ascii.decode(tagNameBytes);

    int elementSize = 22 + actualTagNameLength;

    return Tuple2(TagInfo(tagInstanceId, tagType, tagName, tagLength, tagArrayDims), elementSize);
  }

  List<TagInfo> decode(Tag tag) {
    var buffer = <TagInfo>[];

    var tagSize = tag.GetSize();

    int offset = 0;
    while (offset < tagSize) {
      var decoded = DecodeTagInfo(tag, offset);
      buffer.add(decoded.item1);
      offset += decoded.item2;
    }

    return buffer;
  }

  void encode(Tag tag, List<TagInfo> value) {
    throw new Exception("This plcMapper can only be used to read Tag Information");
  }

  int? getElementCount() {
    //TODO: We know this value after we decode once. SHould we trigger a decode or cache the value after first decode?
    return null;
  }
}
