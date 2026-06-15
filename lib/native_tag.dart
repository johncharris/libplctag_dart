import 'dart:typed_data';

import 'package:libplctag_dart/native/plctag.dart';
import 'package:libplctag_dart/native_tag_base.dart';

/// Thin delegate over [Plctag] that lets [NativeTagWrapper] talk to the
/// native library through an interface ([NativeTagBase]) for testability.
class NativeTag implements NativeTagBase {
  @override
  int plc_tag_check_lib_version(int reqMajor, int reqMinor, int reqPatch) =>
      Plctag.plc_tag_check_lib_version(reqMajor, reqMinor, reqPatch);
  @override
  int plc_tag_create(String attributeString, int timeoutMs) =>
      Plctag.plc_tag_create(attributeString, timeoutMs);
  @override
  int plc_tag_destroy(int tag) => Plctag.plc_tag_destroy(tag);
  @override
  void plc_tag_shutdown() => Plctag.plc_tag_shutdown();
  @override
  int plc_tag_register_callback(int tagId, TagCallback callback) =>
      Plctag.plc_tag_register_callback(tagId, callback);
  @override
  int plc_tag_unregister_callback(int tagId) =>
      Plctag.plc_tag_unregister_callback(tagId);
  @override
  int plc_tag_register_logger(LogCallback callback) =>
      Plctag.plc_tag_register_logger(callback);
  @override
  int plc_tag_unregister_logger() => Plctag.plc_tag_unregister_logger();
  @override
  int plc_tag_lock(int tag) => Plctag.plc_tag_lock(tag);
  @override
  int plc_tag_unlock(int tag) => Plctag.plc_tag_unlock(tag);
  @override
  int plc_tag_status(int tag) => Plctag.plc_tag_status(tag);
  @override
  String plc_tag_decode_error(int err) => Plctag.plc_tag_decode_error(err);
  @override
  int plc_tag_read(int tag, int timeoutMs) => Plctag.plc_tag_read(tag, timeoutMs);
  @override
  int plc_tag_write(int tag, int timeoutMs) => Plctag.plc_tag_write(tag, timeoutMs);
  @override
  int plc_tag_get_size(int tag) => Plctag.plc_tag_get_size(tag);
  @override
  int plc_tag_set_size(int tag, int newSize) => Plctag.plc_tag_set_size(tag, newSize);
  @override
  int plc_tag_abort(int tag) => Plctag.plc_tag_abort(tag);
  @override
  int plc_tag_get_int_attribute(int tag, String name, int defaultValue) =>
      Plctag.plc_tag_get_int_attribute(tag, name, defaultValue);
  @override
  int plc_tag_set_int_attribute(int tag, String name, int newValue) =>
      Plctag.plc_tag_set_int_attribute(tag, name, newValue);
  @override
  int plc_tag_get_uint64(int tag, int offset) => Plctag.plc_tag_get_uint64(tag, offset);
  @override
  int plc_tag_get_int64(int tag, int offset) => Plctag.plc_tag_get_int64(tag, offset);
  @override
  int plc_tag_set_uint64(int tag, int offset, int value) =>
      Plctag.plc_tag_set_uint64(tag, offset, value);
  @override
  int plc_tag_set_int64(int tag, int offset, int value) =>
      Plctag.plc_tag_set_int64(tag, offset, value);
  @override
  double plc_tag_get_float64(int tag, int offset) =>
      Plctag.plc_tag_get_float64(tag, offset);
  @override
  int plc_tag_set_float64(int tag, int offset, double value) =>
      Plctag.plc_tag_set_float64(tag, offset, value);
  @override
  int plc_tag_get_uint32(int tag, int offset) => Plctag.plc_tag_get_uint32(tag, offset);
  @override
  int plc_tag_get_int32(int tag, int offset) => Plctag.plc_tag_get_int32(tag, offset);
  @override
  int plc_tag_set_uint32(int tag, int offset, int value) =>
      Plctag.plc_tag_set_uint32(tag, offset, value);
  @override
  int plc_tag_set_int32(int tag, int offset, int value) =>
      Plctag.plc_tag_set_int32(tag, offset, value);
  @override
  double plc_tag_get_float32(int tag, int offset) =>
      Plctag.plc_tag_get_float32(tag, offset);
  @override
  int plc_tag_set_float32(int tag, int offset, double value) =>
      Plctag.plc_tag_set_float32(tag, offset, value);
  @override
  int plc_tag_get_uint16(int tag, int offset) => Plctag.plc_tag_get_uint16(tag, offset);
  @override
  int plc_tag_get_int16(int tag, int offset) => Plctag.plc_tag_get_int16(tag, offset);
  @override
  int plc_tag_set_uint16(int tag, int offset, int value) =>
      Plctag.plc_tag_set_uint16(tag, offset, value);
  @override
  int plc_tag_set_int16(int tag, int offset, int value) =>
      Plctag.plc_tag_set_int16(tag, offset, value);
  @override
  int plc_tag_get_uint8(int tag, int offset) => Plctag.plc_tag_get_uint8(tag, offset);
  @override
  int plc_tag_get_int8(int tag, int offset) => Plctag.plc_tag_get_int8(tag, offset);
  @override
  int plc_tag_set_uint8(int tag, int offset, int value) =>
      Plctag.plc_tag_set_uint8(tag, offset, value);
  @override
  int plc_tag_set_int8(int tag, int offset, int value) =>
      Plctag.plc_tag_set_int8(tag, offset, value);
  @override
  int plc_tag_get_bit(int tag, int bitOffset) => Plctag.plc_tag_get_bit(tag, bitOffset);
  @override
  int plc_tag_set_bit(int tag, int bitOffset, int value) =>
      Plctag.plc_tag_set_bit(tag, bitOffset, value);
  @override
  void plc_tag_set_debug_level(int debugLevel) =>
      Plctag.plc_tag_set_debug_level(debugLevel);
  @override
  int plc_tag_get_raw_bytes(int tag, int startOffset, Uint8List buffer, int bufferLength) =>
      Plctag.plc_tag_get_raw_bytes(tag, startOffset, buffer, bufferLength);
  @override
  int plc_tag_set_raw_bytes(int tag, int startOffset, Uint8List buffer, int bufferLength) =>
      Plctag.plc_tag_set_raw_bytes(tag, startOffset, buffer, bufferLength);
  @override
  int plc_tag_get_string_length(int tag, int offset) =>
      Plctag.plc_tag_get_string_length(tag, offset);
  @override
  int plc_tag_get_string(int tag, int offset, StringBuffer buffer, int bufferLength) =>
      Plctag.plc_tag_get_string(tag, offset, buffer, bufferLength);
  @override
  int plc_tag_get_string_total_length(int tag, int offset) =>
      Plctag.plc_tag_get_string_total_length(tag, offset);
  @override
  int plc_tag_get_string_capacity(int tag, int offset) =>
      Plctag.plc_tag_get_string_capacity(tag, offset);
  @override
  int plc_tag_set_string(int tag, int offset, String value) =>
      Plctag.plc_tag_set_string(tag, offset, value);
}
