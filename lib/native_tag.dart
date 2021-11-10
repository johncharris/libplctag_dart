import 'dart:typed_data';

import 'package:libplctag_dart/inativeTag.dart';
import 'package:libplctag_dart/native/plctag.dart';

class NativeTag implements INativeTag {
  int plc_tag_check_lib_version(int req_major, int req_minor, int req_patch) =>
      plctag.plc_tag_check_lib_version(req_major, req_minor, req_patch);
  int plc_tag_create(String lpString, int timeout) => plctag.plc_tag_create(lpString, timeout);
  int plc_tag_destroy(int tag) => plctag.plc_tag_destroy(tag);
  void plc_tag_shutdown() => plctag.plc_tag_shutdown();
  //  int plc_tag_register_callback(int tag_id, callback_func func)                  => plctag.plc_tag_register_callback(tag_id, func);
  int plc_tag_unregister_callback(int tag_id) => plctag.plc_tag_unregister_callback(tag_id);
  //  int plc_tag_register_logger(log_callback_func func)                              => plctag.plc_tag_register_logger(func);
  int plc_tag_unregister_logger() => plctag.plc_tag_unregister_logger();
  int plc_tag_lock(int tag) => plctag.plc_tag_lock(tag);
  int plc_tag_unlock(int tag) => plctag.plc_tag_unlock(tag);
  int plc_tag_status(int tag) => plctag.plc_tag_status(tag);
  String plc_tag_decode_error(int err) => plctag.plc_tag_decode_error(err);
  int plc_tag_read(int tag, int timeout) => plctag.plc_tag_read(tag, timeout);
  int plc_tag_write(int tag, int timeout) => plctag.plc_tag_write(tag, timeout);
  int plc_tag_get_size(int tag) => plctag.plc_tag_get_size(tag);
  int plc_tag_set_size(int tag, int new_size) => plctag.plc_tag_set_size(tag, new_size);
  int plc_tag_abort(int tag) => plctag.plc_tag_abort(tag);
  int plc_tag_get_int_attribute(int tag, String attrib_name, int default_value) =>
      plctag.plc_tag_get_int_attribute(tag, attrib_name, default_value);
  int plc_tag_set_int_attribute(int tag, String attrib_name, int new_value) =>
      plctag.plc_tag_set_int_attribute(tag, attrib_name, new_value);
  int plc_tag_get_uint64(int tag, int offset) => plctag.plc_tag_get_uint64(tag, offset);
  int plc_tag_get_int64(int tag, int offset) => plctag.plc_tag_get_int64(tag, offset);
  int plc_tag_set_uint64(int tag, int offset, int val) => plctag.plc_tag_set_uint64(tag, offset, val);
  int plc_tag_set_int64(int tag, int offset, int val) => plctag.plc_tag_set_int64(tag, offset, val);
  double plc_tag_get_float64(int tag, int offset) => plctag.plc_tag_get_float64(tag, offset);
  int plc_tag_set_float64(int tag, int offset, double val) => plctag.plc_tag_set_float64(tag, offset, val);
  int plc_tag_get_uint32(int tag, int offset) => plctag.plc_tag_get_uint32(tag, offset);
  int plc_tag_get_int32(int tag, int offset) => plctag.plc_tag_get_int32(tag, offset);
  int plc_tag_set_uint32(int tag, int offset, val) => plctag.plc_tag_set_uint32(tag, offset, val);
  int plc_tag_set_int32(int tag, int offset, val) => plctag.plc_tag_set_int32(tag, offset, val);
  double plc_tag_get_float32(int tag, int offset) => plctag.plc_tag_get_float32(tag, offset);
  int plc_tag_set_float32(int tag, int offset, double val) => plctag.plc_tag_set_float32(tag, offset, val);
  int plc_tag_get_uint16(int tag, int offset) => plctag.plc_tag_get_uint16(tag, offset);
  int plc_tag_get_int16(int tag, int offset) => plctag.plc_tag_get_int16(tag, offset);
  int plc_tag_set_uint16(int tag, int offset, int val) => plctag.plc_tag_set_uint16(tag, offset, val);
  int plc_tag_set_int16(int tag, int offset, int val) => plctag.plc_tag_set_int16(tag, offset, val);
  int plc_tag_get_uint8(int tag, int offset) => plctag.plc_tag_get_uint8(tag, offset);
  int plc_tag_get_int8(int tag, int offset) => plctag.plc_tag_get_int8(tag, offset);
  int plc_tag_set_uint8(int tag, int offset, int val) => plctag.plc_tag_set_uint8(tag, offset, val);
  int plc_tag_set_int8(int tag, int offset, int val) => plctag.plc_tag_set_int8(tag, offset, val);
  int plc_tag_get_bit(int tag, int offset_bit) => plctag.plc_tag_get_bit(tag, offset_bit);
  int plc_tag_set_bit(int tag, int offset_bit, int val) => plctag.plc_tag_set_bit(tag, offset_bit, val);
  void plc_tag_set_debug_level(int debug_level) => plctag.plc_tag_set_debug_level(debug_level);
  int plc_tag_get_raw_bytes(int tag, int start_offset, Uint8List buffer, int buffer_length) =>
      plctag.plc_tag_get_raw_bytes(tag, start_offset, buffer, buffer_length);
  int plc_tag_set_raw_bytes(int tag, int start_offset, Uint8List buffer, int buffer_length) =>
      plctag.plc_tag_set_raw_bytes(tag, start_offset, buffer, buffer_length);
  int plc_tag_get_string_length(int tag, int string_start_offset) =>
      plctag.plc_tag_get_string_length(tag, string_start_offset);
  int plc_tag_get_string(int tag, int string_start_offset, StringBuffer buffer, int buffer_length) =>
      plctag.plc_tag_get_string(tag, string_start_offset, buffer, buffer_length);
  int plc_tag_get_string_total_length(int tag, int string_start_offset) =>
      plctag.plc_tag_get_string_total_length(tag, string_start_offset);
  int plc_tag_get_string_capacity(int tag, int string_start_offset) =>
      plctag.plc_tag_get_string_capacity(tag, string_start_offset);
  int plc_tag_set_string(int tag, int string_start_offset, String string_val) =>
      plctag.plc_tag_set_string(tag, string_start_offset, string_val);
}
