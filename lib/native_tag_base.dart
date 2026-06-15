import 'dart:typed_data';

import 'package:libplctag_dart/native/plctag.dart';

/// Abstract seam over the native libplctag API. Lets [NativeTagWrapper]
/// be tested against an in-memory mock instead of the real `.so`/`.dll`.
///
/// Method names match the underlying C symbols verbatim — keep them that
/// way so callers can cross-reference the libplctag wiki.
abstract class NativeTagBase {
  int plc_tag_abort(int tag);
  int plc_tag_check_lib_version(int reqMajor, int reqMinor, int reqPatch);
  int plc_tag_create(String attributeString, int timeoutMs);
  String plc_tag_decode_error(int err);
  int plc_tag_destroy(int tag);
  int plc_tag_get_bit(int tag, int bitOffset);
  double plc_tag_get_float32(int tag, int offset);
  double plc_tag_get_float64(int tag, int offset);
  int plc_tag_get_int16(int tag, int offset);
  int plc_tag_get_int32(int tag, int offset);
  int plc_tag_get_int64(int tag, int offset);
  int plc_tag_get_int8(int tag, int offset);
  int plc_tag_get_int_attribute(int tag, String name, int defaultValue);
  int plc_tag_get_size(int tag);
  int plc_tag_set_size(int tag, int newSize);
  int plc_tag_get_uint16(int tag, int offset);
  int plc_tag_get_uint32(int tag, int offset);
  int plc_tag_get_uint64(int tag, int offset);
  int plc_tag_get_uint8(int tag, int offset);
  int plc_tag_lock(int tag);
  int plc_tag_read(int tag, int timeoutMs);
  int plc_tag_register_callback(int tagId, TagCallback callback);
  int plc_tag_register_logger(LogCallback callback);
  int plc_tag_set_bit(int tag, int bitOffset, int value);
  void plc_tag_set_debug_level(int debugLevel);
  int plc_tag_set_float32(int tag, int offset, double value);
  int plc_tag_set_float64(int tag, int offset, double value);
  int plc_tag_set_int16(int tag, int offset, int value);
  int plc_tag_set_int32(int tag, int offset, int value);
  int plc_tag_set_int64(int tag, int offset, int value);
  int plc_tag_set_int8(int tag, int offset, int value);
  int plc_tag_set_int_attribute(int tag, String name, int newValue);
  int plc_tag_set_uint16(int tag, int offset, int value);
  int plc_tag_set_uint32(int tag, int offset, int value);
  int plc_tag_set_uint64(int tag, int offset, int value);
  int plc_tag_set_uint8(int tag, int offset, int value);
  void plc_tag_shutdown();
  int plc_tag_status(int tag);
  int plc_tag_unlock(int tag);
  int plc_tag_unregister_callback(int tagId);
  int plc_tag_unregister_logger();
  int plc_tag_write(int tag, int timeoutMs);
  int plc_tag_get_raw_bytes(int tag, int startOffset, Uint8List buffer, int bufferLength);
  int plc_tag_set_raw_bytes(int tag, int startOffset, Uint8List buffer, int bufferLength);
  int plc_tag_get_string_length(int tag, int offset);
  int plc_tag_get_string(int tag, int offset, StringBuffer buffer, int bufferLength);
  int plc_tag_get_string_total_length(int tag, int offset);
  int plc_tag_get_string_capacity(int tag, int offset);
  int plc_tag_set_string(int tag, int offset, String value);
}
