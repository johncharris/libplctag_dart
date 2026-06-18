import 'dart:convert';
import 'dart:typed_data';

import 'package:libplctag_dart/data_types/plc_mapper.dart';
import 'package:libplctag_dart/data_types/udt_info.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

/// Decodes the variable-length buffer returned by an Allen-Bradley
/// `@udt/N` read into a [UdtInfo].
///
/// Wire layout (matches libplctag's `eip_cip.c` decoder):
///
///   * 2 bytes  uint16  template / struct handle
///   * 4 bytes  uint32  member count (includes one hidden "parent handle" entry)
///   * 4 bytes  uint32  template definition size in 32-bit words
///   * 4 bytes  uint32  instance size in bytes
///   * `memberCount * 8 bytes` per-member records:
///       - 2 bytes uint16 metadata (bit info; bit 0x8000 = hidden member)
///       - 2 bytes uint16 type code (Allen-Bradley type encoding)
///       - 4 bytes uint32 byte offset within instance
///   * Names block: null-terminated UDT name, then a single `;`-separated
///     list of member names terminated by `\0`.
class UdtInfoPlcMapper implements PlcMapper<UdtInfo> {
  @override
  PlcType plcType = PlcType.controlLogix;

  /// libplctag's `@udt/N` response has a variable length so we can't supply a
  /// fixed byte size, but the library still needs to know the element layout
  /// to allocate a buffer. We hint a small element size; libplctag grows the
  /// buffer to fit the actual response.
  @override
  int? get elementSize => 1;

  @override
  List<int>? get arrayDimensions => null;

  @override
  set arrayDimensions(List<int>? value) {
    throw UnsupportedError('UdtInfoPlcMapper is read-only');
  }

  /// libplctag requires `elem_count` to be set before issuing the read.
  /// Without it the `@udt/N` request returns an empty buffer (size=0).
  @override
  int? getElementCount() => 1;

  @override
  UdtInfo decode(Tag tag) {
    final size = tag.getSize();
    try {
      return _decode(tag, size);
    } catch (e) {
      // Re-throw with a hex dump so callers can iterate on the wire format
      // without needing tcpdump.
      throw FormatException(
        '$e (buffer size=$size; first bytes: ${_dumpHex(tag, size)})',
      );
    }
  }

  UdtInfo _decode(Tag tag, int size) {
    if (size < 14) {
      throw FormatException(
        'UDT info response too short (size=$size, expected >= 14)',
      );
    }

    final templateId = tag.getUInt16(0);
    final memberCount = tag.getUInt32(2);
    // Skip definition size at offset 6 — we don't surface it.
    final instanceSizeBytes = tag.getUInt32(10);

    const headerSize = 14;
    const recordSize = 8;
    final namesOffset = headerSize + (memberCount * recordSize);

    if (size < namesOffset + 1) {
      throw const FormatException('UDT info names block missing');
    }

    // Read all remaining bytes and split into null-terminated strings.
    final nameBytes = BytesBuilder();
    for (var i = namesOffset; i < size; i++) {
      nameBytes.addByte(tag.getUInt8(i));
    }
    final raw = nameBytes.toBytes();

    // First null-terminated string is the UDT name. Often suffixed with
    // ";n" where n is the field separator marker that the PLC inserts.
    final firstZero = raw.indexOf(0);
    final udtNameRaw = firstZero < 0
        ? ascii.decode(raw)
        : ascii.decode(raw.sublist(0, firstZero));
    final udtName = _stripSemicolonSuffix(udtNameRaw);

    // The remaining bytes are member names joined by ';'.
    Uint8List remaining;
    if (firstZero < 0 || firstZero + 1 >= raw.length) {
      remaining = Uint8List(0);
    } else {
      remaining = raw.sublist(firstZero + 1);
    }
    // Drop trailing nulls.
    while (remaining.isNotEmpty && remaining.last == 0) {
      remaining = remaining.sublist(0, remaining.length - 1);
    }
    final names = remaining.isEmpty
        ? <String>[]
        : ascii.decode(remaining).split(';');

    // Read per-member records.
    final members = <UdtField>[];
    var nameIdx = 0;
    for (var i = 0; i < memberCount; i++) {
      final base = headerSize + (i * recordSize);
      final metadata = tag.getUInt16(base);
      final typeCode = tag.getUInt16(base + 2);
      final offset = tag.getUInt32(base + 4);
      final isHidden = (metadata & 0x8000) != 0;
      var memberName = '__hidden_$i';
      if (!isHidden && nameIdx < names.length) {
        memberName = names[nameIdx];
        nameIdx++;
      }
      members.add(UdtField(
        name: memberName,
        typeCode: typeCode,
        metadata: metadata,
        offset: offset,
      ));
    }

    return UdtInfo(
      templateId: templateId,
      name: udtName,
      instanceSizeBytes: instanceSizeBytes,
      members: members.where((m) => !m.isHidden).toList(),
    );
  }

  @override
  void encode(Tag tag, UdtInfo value) {
    throw UnsupportedError('UdtInfoPlcMapper is read-only');
  }

  String _stripSemicolonSuffix(String s) {
    final semi = s.indexOf(';');
    return semi < 0 ? s : s.substring(0, semi);
  }

  String _dumpHex(Tag tag, int size) {
    final n = size < 32 ? size : 32;
    final parts = <String>[];
    for (var i = 0; i < n; i++) {
      parts.add(tag.getUInt8(i).toRadixString(16).padLeft(2, '0'));
    }
    return parts.join(' ');
  }
}
