import 'dart:convert';
import 'dart:typed_data';
import 'dart:ffi';
import "package:ffi/ffi.dart";
import 'package:libplctag_dart/native/extensions.dart';

import 'package:libplctag_dart/native/generated_bindings.dart';
import 'package:libplctag_dart/native/library_extractor.dart';
import 'package:libplctag_dart/native/status_codes.dart';

/// <summary>
/// This class provides low-level (raw) access to the native libplctag library (which is written in C).
/// The purpose of this package is to expose the API for this native library, and handle platform and configuration issues.
///
/// <para>See <see href="https://github.com/libplctag/libplctag/wiki/API"/> for documentation.</para>
/// </summary>
class plctag {
  static late NativeLibrary NativeMethods;

  static bool _forceExtractLibrary = true;

  /// <summary>
  /// During initialization, this package extracts to disk the appropriate native library.
  /// By default, it will overwrite files with the same filename (plctag.dll, libplctag.so, or libplctag.dylib).
  /// If you wish to disable this behaviour and use a different native library (e.g. one that you've compiled yourself, or a pre-release), you can disable the Force Extract feature by setting this value to false.
  /// </summary>
  static bool get ForceExtractLibrary => _forceExtractLibrary;
  static void set ForceExtractLibrary(value) {
    if (_libraryAlreadyInitialized) throw new Exception("Library already initialized");
    _forceExtractLibrary = value;
  }

  static bool _libraryAlreadyInitialized = false;
  // static object _libraryExtractLocker = new object();

  static void _extractLibraryIfRequired() {
    // Non-blocking check
    // Except during startup, this will be hit 100% of the time
    if (!_libraryAlreadyInitialized) {
// TODO I don't think this is relevant to Dart.
      // // Blocking check
      // // This is hit if multiple threads simultaneously try to initialize the library
      // lock (_libraryExtractLocker)
      // {
      //     if (!_libraryAlreadyInitialized)
      //     {
      NativeMethods = NativeLibrary(LibraryExtractor.getLibrary());
      _libraryAlreadyInitialized = true;
      //     }
      // }
    }
  }

  // [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
  //  delegate void callback_func(int tag_id, Int32 event_id, Int32 status);

  // [UnmanagedFunctionPointer(CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
  //  delegate void log_callback_func(int tag_id, int debug_level, [MarshalAs(UnmanagedType.LPStr)] string message);

  static int plc_tag_check_lib_version(int req_major, int req_minor, int req_patch) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_check_lib_version(req_major, req_minor, req_patch);
  }

  static int plc_tag_create(String lpString, int timeout) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_create(lpString.toInt8(), timeout);
  }

  static int plc_tag_destroy(int tag) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_destroy(tag);
  }

  static void plc_tag_shutdown() {
    _extractLibraryIfRequired();
    NativeMethods.plc_tag_shutdown();
  }

  // static int plc_tag_register_callback(int tag_id, callback_func func) {
  //   _extractLibraryIfRequired();
  //   return NativeMethods.plc_tag_register_callback(tag_id, func);
  // }

  static int plc_tag_unregister_callback(int tag_id) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_unregister_callback(tag_id);
  }

  // static int plc_tag_register_logger(log_callback_func func) {
  //   _extractLibraryIfRequired();
  //   return NativeMethods.plc_tag_register_logger(func);
  // }

  static int plc_tag_unregister_logger() {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_unregister_logger();
  }

  static int plc_tag_lock(int tag) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_lock(tag);
  }

  static int plc_tag_unlock(int tag) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_unlock(tag);
  }

  static int plc_tag_status(int tag) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_status(tag);
  }

  static String plc_tag_decode_error(int err) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_decode_error(err).cast<Utf8>().toDartString();
  }

  static int plc_tag_read(int tag, int timeout) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_read(tag, timeout);
  }

  static int plc_tag_write(int tag, int timeout) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_write(tag, timeout);
  }

  static int plc_tag_get_size(int tag) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_size(tag);
  }

  static int plc_tag_set_size(int tag, int new_size) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_size(tag, new_size);
  }

  static int plc_tag_abort(int tag) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_abort(tag);
  }

  static int plc_tag_get_int_attribute(int tag, String attrib_name, int default_value) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_int_attribute(tag, attrib_name.toInt8(), default_value);
  }

  static int plc_tag_set_int_attribute(int tag, String attrib_name, int new_value) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_int_attribute(tag, attrib_name.toInt8(), new_value);
  }

  static int plc_tag_get_uint64(int tag, int offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_uint64(tag, offset);
  }

  static int plc_tag_get_int64(int tag, int offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_int64(tag, offset);
  }

  static int plc_tag_set_uint64(int tag, int offset, int val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_uint64(tag, offset, val);
  }

  static int plc_tag_set_int64(int tag, int offset, int val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_int64(tag, offset, val);
  }

  static double plc_tag_get_float64(int tag, int offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_float64(tag, offset);
  }

  static int plc_tag_set_float64(int tag, int offset, double val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_float64(tag, offset, val);
  }

  static int plc_tag_get_uint32(int tag, int offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_uint32(tag, offset);
  }

  static int plc_tag_get_int32(int tag, int offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_int32(tag, offset);
  }

  static int plc_tag_set_uint32(int tag, int offset, int val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_uint32(tag, offset, val);
  }

  static int plc_tag_set_int32(int tag, int offset, int val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_int32(tag, offset, val);
  }

  static double plc_tag_get_float32(int tag, int offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_float32(tag, offset);
  }

  static int plc_tag_set_float32(int tag, int offset, double val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_float32(tag, offset, val);
  }

  static int plc_tag_get_uint16(int tag, int offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_uint16(tag, offset);
  }

  static int plc_tag_get_int16(int tag, int offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_int16(tag, offset);
  }

  static int plc_tag_set_uint16(int tag, int offset, int val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_uint16(tag, offset, val);
  }

  static int plc_tag_set_int16(int tag, int offset, int val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_int16(tag, offset, val);
  }

  static int plc_tag_get_uint8(int tag, int offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_uint8(tag, offset);
  }

  static int plc_tag_get_int8(int tag, int offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_int8(tag, offset);
  }

  static int plc_tag_set_uint8(int tag, int offset, int val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_uint8(tag, offset, val);
  }

  static int plc_tag_set_int8(int tag, int offset, int val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_int8(tag, offset, val);
  }

  static int plc_tag_get_bit(int tag, int offset_bit) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_bit(tag, offset_bit);
  }

  static int plc_tag_set_bit(int tag, int offset_bit, int val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_bit(tag, offset_bit, val);
  }

  static void plc_tag_set_debug_level(int debug_level) {
    _extractLibraryIfRequired();
    NativeMethods.plc_tag_set_debug_level(debug_level);
  }

  static int plc_tag_get_string(int tag_id, int string_start_offset, StringBuffer buffer, int buffer_length) {
    _extractLibraryIfRequired();

    var ptr = malloc.allocate<Int8>(buffer_length);

    var result = NativeMethods.plc_tag_get_string(tag_id, string_start_offset, ptr, buffer_length);

    if (result == STATUS_CODES.PLCTAG_STATUS_OK.value) {
      for (int i = 0; i < buffer_length; i++) {
        buffer.write(ascii.decode([ptr.elementAt(i).value]));
      }
    }

    return result;
  }

  static int plc_tag_set_string(int tag_id, int string_start_offset, String string_val) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_set_string(tag_id, string_start_offset, string_val.toInt8());
  }

  static int plc_tag_get_string_length(int tag_id, int string_start_offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_string_length(tag_id, string_start_offset);
  }

  static int plc_tag_get_string_capacity(int tag_id, int string_start_offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_string_capacity(tag_id, string_start_offset);
  }

  static int plc_tag_get_string_total_length(int tag_id, int string_start_offset) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_string_total_length(tag_id, string_start_offset);
  }

  static int plc_tag_get_raw_bytes(int tag_id, int start_offset, Uint8List buffer, int buffer_length) {
    _extractLibraryIfRequired();
    return NativeMethods.plc_tag_get_raw_bytes(tag_id, start_offset, buffer.allocatePointer(), buffer_length);
  }

  static int plc_tag_set_raw_bytes(int tag_id, int start_offset, Uint8List buffer, int buffer_length) {
    _extractLibraryIfRequired();

    return NativeMethods.plc_tag_set_raw_bytes(tag_id, start_offset, buffer.allocatePointer(), buffer_length);
  }
}
