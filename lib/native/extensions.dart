import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

extension StringExtensions on String {
  Pointer<Int8> toInt8() {
    return this.toNativeUtf8().cast<Int8>();
  }
}

extension Uint8ListBlobConversion on Uint8List {
  /// Allocates a pointer filled with the Uint8List data.
  Pointer<Uint8> allocatePointer() {
    final blob = calloc<Uint8>(length);
    final blobBytes = blob.asTypedList(length);
    blobBytes.setAll(0, this);
    return blob;
  }
}

// extension PointerExtensions<T extends NativeType> on Pointer<T> {
//   String toStr() {
//     if (T == Int8) {
//       return Utf8.fromUtf8(cast<Utf8>());
//     }

//     throw UnsupportedError('${T} unsupported');
//   }
// }
