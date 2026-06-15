import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

/// Maps between a Dart-side value of type [T] and the raw bytes of a PLC tag.
///
/// Implementations decide how to encode/decode the scalar form; the
/// [PlcMapperBase] subclass adds 1D/2D/3D array helpers on top.
abstract class PlcMapper<T> {
  /// PLC family — set by [Tag] so that byte order and structure quirks
  /// can be encoded correctly.
  PlcType get plcType;
  set plcType(PlcType value);

  /// Size in bytes of a single element. May be null when not known up front.
  int? get elementSize;

  /// Logical dimensions of the array. Null for non-arrays.
  List<int>? get arrayDimensions;
  set arrayDimensions(List<int>? value);

  /// Number of native elements the underlying tag should be allocated for.
  ///
  /// For most types this is the product of [arrayDimensions]. Bool packs
  /// 32 bits into a DINT, so [BoolPlcMapper] rounds up differently.
  int? getElementCount();

  /// Decode the tag buffer into a Dart value.
  T decode(Tag tag);

  /// Encode a Dart value into the tag buffer.
  void encode(Tag tag, T value);
}
