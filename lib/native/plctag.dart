import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'package:libplctag_dart/native/extensions.dart';
import 'package:libplctag_dart/native/generated_bindings.dart';
import 'package:libplctag_dart/native/library_extractor.dart';
import 'package:libplctag_dart/status.dart';

/// Dart-side callback invoked when a tag event fires.
typedef TagCallback = void Function(int tagId, int eventId, int status);

/// Dart-side log callback invoked by the native library.
typedef LogCallback = void Function(int tagId, int debugLevel, String message);

/// Low-level proxy over the native libplctag C API.
///
/// Method names match the underlying C symbols verbatim to make
/// cross-references against the libplctag wiki obvious. Higher-level
/// Dart-friendly wrappers live in [Tag] and [NativeTagWrapper].
class Plctag {
  Plctag._();

  static late NativeLibrary _nativeMethods;
  static bool _libraryAlreadyInitialized = false;

  /// The native library bindings, lazily loaded on first FFI call.
  static NativeLibrary get nativeMethods {
    _extractLibraryIfRequired();
    return _nativeMethods;
  }

  /// Minimum native libplctag version required at load time.
  /// Set to `null` to skip the check (default `[2, 5, 0]`).
  static List<int>? requiredLibraryVersion = [2, 5, 0];

  static void _extractLibraryIfRequired() {
    if (_libraryAlreadyInitialized) return;
    _nativeMethods = NativeLibrary(LibraryExtractor.getLibrary());
    _libraryAlreadyInitialized = true;

    final required = requiredLibraryVersion;
    if (required != null && required.length == 3) {
      final result = _nativeMethods.plc_tag_check_lib_version(
          required[0], required[1], required[2]);
      if (result != Status.ok.value) {
        throw Exception(
            'libplctag is older than required version ${required.join(".")} (status $result)');
      }
    }
  }

  static final Map<int, NativeCallable<Void Function(Int32, Int, Int)>>
      _tagCallbacks = {};
  static NativeCallable<Void Function(Int32, Int, Pointer<Char>)>? _logCallback;

  // ignore: non_constant_identifier_names
  static int plc_tag_check_lib_version(int reqMajor, int reqMinor, int reqPatch) =>
      nativeMethods.plc_tag_check_lib_version(reqMajor, reqMinor, reqPatch);

  // ignore: non_constant_identifier_names
  static int plc_tag_create(String attributeString, int timeoutMs) {
    final ptr = attributeString.toChar();
    try {
      return nativeMethods.plc_tag_create(ptr, timeoutMs);
    } finally {
      malloc.free(ptr);
    }
  }

  // ignore: non_constant_identifier_names
  static int plc_tag_destroy(int tag) => nativeMethods.plc_tag_destroy(tag);

  // ignore: non_constant_identifier_names
  static void plc_tag_shutdown() => nativeMethods.plc_tag_shutdown();

  // ignore: non_constant_identifier_names
  static int plc_tag_register_callback(int tagId, TagCallback callback) {
    _tagCallbacks.remove(tagId)?.close();
    final native = NativeCallable<Void Function(Int32, Int, Int)>.listener(
      (int t, int e, int s) => callback(t, e, s),
    );
    _tagCallbacks[tagId] = native;
    return nativeMethods.plc_tag_register_callback(tagId, native.nativeFunction);
  }

  // ignore: non_constant_identifier_names
  static int plc_tag_unregister_callback(int tagId) {
    final result = nativeMethods.plc_tag_unregister_callback(tagId);
    _tagCallbacks.remove(tagId)?.close();
    return result;
  }

  // ignore: non_constant_identifier_names
  static int plc_tag_register_logger(LogCallback callback) {
    _logCallback?.close();
    final native = NativeCallable<Void Function(Int32, Int, Pointer<Char>)>.listener(
      (int tagId, int debugLevel, Pointer<Char> message) {
        callback(tagId, debugLevel, message.cast<Utf8>().toDartString());
      },
    );
    _logCallback = native;
    return nativeMethods.plc_tag_register_logger(native.nativeFunction);
  }

  // ignore: non_constant_identifier_names
  static int plc_tag_unregister_logger() {
    final result = nativeMethods.plc_tag_unregister_logger();
    _logCallback?.close();
    _logCallback = null;
    return result;
  }

  // ignore: non_constant_identifier_names
  static int plc_tag_lock(int tag) => nativeMethods.plc_tag_lock(tag);

  // ignore: non_constant_identifier_names
  static int plc_tag_unlock(int tag) => nativeMethods.plc_tag_unlock(tag);

  // ignore: non_constant_identifier_names
  static int plc_tag_status(int tag) => nativeMethods.plc_tag_status(tag);

  // ignore: non_constant_identifier_names
  static String plc_tag_decode_error(int err) =>
      nativeMethods.plc_tag_decode_error(err).cast<Utf8>().toDartString();

  // ignore: non_constant_identifier_names
  static int plc_tag_read(int tag, int timeoutMs) =>
      nativeMethods.plc_tag_read(tag, timeoutMs);

  // ignore: non_constant_identifier_names
  static int plc_tag_write(int tag, int timeoutMs) =>
      nativeMethods.plc_tag_write(tag, timeoutMs);

  // ignore: non_constant_identifier_names
  static int plc_tag_get_size(int tag) => nativeMethods.plc_tag_get_size(tag);

  // ignore: non_constant_identifier_names
  static int plc_tag_set_size(int tag, int newSize) =>
      nativeMethods.plc_tag_set_size(tag, newSize);

  // ignore: non_constant_identifier_names
  static int plc_tag_abort(int tag) => nativeMethods.plc_tag_abort(tag);

  // ignore: non_constant_identifier_names
  static int plc_tag_get_int_attribute(int tag, String name, int defaultValue) {
    final ptr = name.toChar();
    try {
      return nativeMethods.plc_tag_get_int_attribute(tag, ptr, defaultValue);
    } finally {
      malloc.free(ptr);
    }
  }

  // ignore: non_constant_identifier_names
  static int plc_tag_set_int_attribute(int tag, String name, int newValue) {
    final ptr = name.toChar();
    try {
      return nativeMethods.plc_tag_set_int_attribute(tag, ptr, newValue);
    } finally {
      malloc.free(ptr);
    }
  }

  // ignore: non_constant_identifier_names
  static int plc_tag_get_uint64(int tag, int offset) =>
      nativeMethods.plc_tag_get_uint64(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_get_int64(int tag, int offset) =>
      nativeMethods.plc_tag_get_int64(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_set_uint64(int tag, int offset, int value) =>
      nativeMethods.plc_tag_set_uint64(tag, offset, value);
  // ignore: non_constant_identifier_names
  static int plc_tag_set_int64(int tag, int offset, int value) =>
      nativeMethods.plc_tag_set_int64(tag, offset, value);
  // ignore: non_constant_identifier_names
  static double plc_tag_get_float64(int tag, int offset) =>
      nativeMethods.plc_tag_get_float64(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_set_float64(int tag, int offset, double value) =>
      nativeMethods.plc_tag_set_float64(tag, offset, value);
  // ignore: non_constant_identifier_names
  static int plc_tag_get_uint32(int tag, int offset) =>
      nativeMethods.plc_tag_get_uint32(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_get_int32(int tag, int offset) =>
      nativeMethods.plc_tag_get_int32(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_set_uint32(int tag, int offset, int value) =>
      nativeMethods.plc_tag_set_uint32(tag, offset, value);
  // ignore: non_constant_identifier_names
  static int plc_tag_set_int32(int tag, int offset, int value) =>
      nativeMethods.plc_tag_set_int32(tag, offset, value);
  // ignore: non_constant_identifier_names
  static double plc_tag_get_float32(int tag, int offset) =>
      nativeMethods.plc_tag_get_float32(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_set_float32(int tag, int offset, double value) =>
      nativeMethods.plc_tag_set_float32(tag, offset, value);
  // ignore: non_constant_identifier_names
  static int plc_tag_get_uint16(int tag, int offset) =>
      nativeMethods.plc_tag_get_uint16(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_get_int16(int tag, int offset) =>
      nativeMethods.plc_tag_get_int16(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_set_uint16(int tag, int offset, int value) =>
      nativeMethods.plc_tag_set_uint16(tag, offset, value);
  // ignore: non_constant_identifier_names
  static int plc_tag_set_int16(int tag, int offset, int value) =>
      nativeMethods.plc_tag_set_int16(tag, offset, value);
  // ignore: non_constant_identifier_names
  static int plc_tag_get_uint8(int tag, int offset) =>
      nativeMethods.plc_tag_get_uint8(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_get_int8(int tag, int offset) =>
      nativeMethods.plc_tag_get_int8(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_set_uint8(int tag, int offset, int value) =>
      nativeMethods.plc_tag_set_uint8(tag, offset, value);
  // ignore: non_constant_identifier_names
  static int plc_tag_set_int8(int tag, int offset, int value) =>
      nativeMethods.plc_tag_set_int8(tag, offset, value);

  // ignore: non_constant_identifier_names
  static int plc_tag_get_bit(int tag, int bitOffset) =>
      nativeMethods.plc_tag_get_bit(tag, bitOffset);
  // ignore: non_constant_identifier_names
  static int plc_tag_set_bit(int tag, int bitOffset, int value) =>
      nativeMethods.plc_tag_set_bit(tag, bitOffset, value);

  // ignore: non_constant_identifier_names
  static void plc_tag_set_debug_level(int debugLevel) =>
      nativeMethods.plc_tag_set_debug_level(debugLevel);

  // ignore: non_constant_identifier_names
  static int plc_tag_get_string(
      int tag, int offset, StringBuffer buffer, int bufferLength) {
    final ptr = malloc.allocate<Char>(bufferLength);
    try {
      final result = nativeMethods.plc_tag_get_string(tag, offset, ptr, bufferLength);
      if (result == Status.ok.value) {
        final raw = ptr.cast<Uint8>();
        for (var i = 0; i < bufferLength; i++) {
          buffer.write(ascii.decode([(raw + i).value]));
        }
      }
      return result;
    } finally {
      malloc.free(ptr);
    }
  }

  // ignore: non_constant_identifier_names
  static int plc_tag_set_string(int tag, int offset, String value) {
    final ptr = value.toChar();
    try {
      return nativeMethods.plc_tag_set_string(tag, offset, ptr);
    } finally {
      malloc.free(ptr);
    }
  }

  // ignore: non_constant_identifier_names
  static int plc_tag_get_string_length(int tag, int offset) =>
      nativeMethods.plc_tag_get_string_length(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_get_string_capacity(int tag, int offset) =>
      nativeMethods.plc_tag_get_string_capacity(tag, offset);
  // ignore: non_constant_identifier_names
  static int plc_tag_get_string_total_length(int tag, int offset) =>
      nativeMethods.plc_tag_get_string_total_length(tag, offset);

  // ignore: non_constant_identifier_names
  static int plc_tag_get_raw_bytes(
      int tag, int startOffset, Uint8List buffer, int bufferLength) {
    final ptr = malloc.allocate<Uint8>(bufferLength);
    try {
      final result =
          nativeMethods.plc_tag_get_raw_bytes(tag, startOffset, ptr, bufferLength);
      if (result == Status.ok.value) {
        for (var i = 0; i < bufferLength; i++) {
          buffer[i] = (ptr + i).value;
        }
      }
      return result;
    } finally {
      malloc.free(ptr);
    }
  }

  // ignore: non_constant_identifier_names
  static int plc_tag_set_raw_bytes(
      int tag, int startOffset, Uint8List buffer, int bufferLength) {
    final ptr = buffer.allocatePointer();
    try {
      return nativeMethods.plc_tag_set_raw_bytes(tag, startOffset, ptr, bufferLength);
    } finally {
      malloc.free(ptr);
    }
  }
}
