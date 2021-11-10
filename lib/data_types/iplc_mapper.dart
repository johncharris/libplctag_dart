import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/tag.dart';

abstract class IPlcMapper<T> {
  IPlcMapper();

  /// <summary>
  /// You can define different marshalling behaviour for different types
  /// The PlcType is injected during PlcMapper instantiation, and
  /// will be available to you in your marshalling logic
  /// </summary>
  PlcType get plcType;
  set plcType(value);

  /// <summary>
  /// Provide an integer value for ElementSize if you
  /// want to pass this into the tag constructor
  /// </summary>
  int? get elementSize;

  /// <summary>
  /// The dimensions of the array. Null if not an array.
  /// </summary>
  List<int>? get arrayDimensions;
  set arrayDimensions(value);

  /// <summary>
  /// This is used to convert the number of array elements
  /// into the raw element count, which is used by the library.
  /// Most of the time, this will be the dimensions multiplied, but occasionally
  /// it is not (e.g. BOOL arrays).
  /// </summary>
  int? getElementCount();

  /// <summary>
  /// This is the method that reads/unpacks the underlying value of the tag
  /// and returns it as a C# type
  /// </summary>
  /// <param name="tag">Tag to be Decoded</param>
  /// <returns>C# value of tag</returns>
  T decode(Tag tag);

  /// <summary>
  /// This is the method that transforms the C# type into the underlying value of the tag
  /// </summary>
  /// <param name="tag">Tag to be encoded to</param>
  /// <param name="value">C# value to be transformed</param>
  void encode(Tag tag, T value);
}
