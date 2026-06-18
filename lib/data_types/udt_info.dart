/// One member of a User-Defined Type (UDT) on an Allen-Bradley PLC.
///
/// Returned by [UdtInfo.members]. The [typeCode] is the same encoding used by
/// `TagInfo.type` (low 12 bits are the atomic, bit 0x8000 marks a nested
/// struct, bit 0x2000 marks an array). [offset] is the byte offset within the
/// containing UDT instance.
class UdtField {
  const UdtField({
    required this.name,
    required this.typeCode,
    required this.metadata,
    required this.offset,
  });

  final String name;
  final int typeCode;
  /// libplctag-encoded bit field (bit info, hidden, etc.). Mostly opaque —
  /// callers usually only care about whether the field is hidden:
  /// `metadata & 0x8000 != 0`.
  final int metadata;
  final int offset;

  bool get isHidden => (metadata & 0x8000) != 0;
}

/// Decoded view of an Allen-Bradley UDT template, returned by
/// `Controller.getUdtInfo` (or the top-level `enumerateUdtMembers` helper).
class UdtInfo {
  const UdtInfo({
    required this.templateId,
    required this.name,
    required this.instanceSizeBytes,
    required this.members,
  });

  final int templateId;
  final String name;
  final int instanceSizeBytes;
  final List<UdtField> members;
}
