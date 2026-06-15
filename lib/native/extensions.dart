import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

extension StringExtensions on String {
  /// Allocate a native UTF-8 C string. Caller must `malloc.free` the result.
  Pointer<Char> toChar() => toNativeUtf8().cast<Char>();
}

extension Uint8ListBlobConversion on Uint8List {
  /// Allocate native memory and copy this list into it.
  /// Caller must `malloc.free` the result.
  Pointer<Uint8> allocatePointer() {
    final blob = calloc<Uint8>(length);
    blob.asTypedList(length).setAll(0, this);
    return blob;
  }
}
