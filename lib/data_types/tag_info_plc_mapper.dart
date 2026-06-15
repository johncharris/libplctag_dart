import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:libplctag_dart/data_types/plc_mapper.dart';
import 'package:libplctag_dart/data_types/tag_info.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

/// Decodes the variable-length tag listing buffer returned by special
/// Allen-Bradley list-tags requests.
///
/// Each entry is a 22-byte header followed by a name of declared length.
/// Encoding is not supported — this mapper is read-only.
class TagInfoPlcMapper implements PlcMapper<List<TagInfo>> {
  /// libplctag caps tag names at this many wide chars.
  static const int tagStringSize = 200;

  @override
  PlcType plcType = PlcType.controlLogix;

  @override
  int? get elementSize => null;

  @override
  List<int>? get arrayDimensions => null;

  @override
  set arrayDimensions(List<int>? value) {
    throw UnsupportedError('TagInfoPlcMapper is read-only');
  }

  @override
  int? getElementCount() => null;

  @override
  List<TagInfo> decode(Tag tag) {
    final result = <TagInfo>[];
    final tagSize = tag.getSize();
    var offset = 0;
    while (offset < tagSize) {
      final (info, size) = _decodeEntry(tag, offset);
      result.add(info);
      offset += size;
    }
    return result;
  }

  @override
  void encode(Tag tag, List<TagInfo> value) {
    throw UnsupportedError('TagInfoPlcMapper is read-only');
  }

  (TagInfo, int) _decodeEntry(Tag tag, int offset) {
    final instanceId = tag.getUInt32(offset);
    final type = tag.getUInt16(offset + 4);
    final length = tag.getUInt16(offset + 6);
    final dimensions = [
      tag.getUInt32(offset + 8),
      tag.getUInt32(offset + 12),
      tag.getUInt32(offset + 16),
    ];

    final declaredNameLength = tag.getUInt16(offset + 20);
    final actualNameLength = math.min(declaredNameLength, tagStringSize * 2 - 1);

    final nameBytes = BytesBuilder();
    for (var i = offset + 22; i < offset + 22 + actualNameLength; i++) {
      nameBytes.addByte(tag.getUInt8(i));
    }
    final name = ascii.decode(nameBytes.toBytes());

    return (
      TagInfo(instanceId, type, name, length, dimensions),
      22 + actualNameLength,
    );
  }
}
