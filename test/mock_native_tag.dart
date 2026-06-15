import 'dart:typed_data';

import 'package:libplctag_dart/native/plctag.dart';
import 'package:libplctag_dart/native_tag_base.dart';
import 'package:libplctag_dart/status.dart';

/// In-memory implementation of [NativeTagBase] suitable for testing.
///
/// Each successful `plc_tag_create` allocates a fresh tag with a configurable
/// buffer size and stores it in [tags]. Mutating accessors update the buffer
/// directly; the buffer is laid out little-endian to match common PLC byte
/// orders used by the test fixtures.
class MockNativeTag implements NativeTagBase {
  /// Storage for live tags keyed by handle.
  final Map<int, _MockTag> tags = {};
  int _nextHandle = 1;

  /// Default size used when the attribute string does not specify elem_size/elem_count.
  int defaultSize = 256;

  /// Captured attribute strings, in call order.
  final List<String> createAttributeStrings = [];

  /// Default status returned for a tag — useful to simulate Pending.
  StatusOverride? statusOverride;

  /// Most recently registered tag callback (by handle).
  final Map<int, TagCallback> callbacks = {};

  /// Most recently registered logger.
  LogCallback? logger;

  /// Convenience: invoke a tag's registered callback synchronously.
  void fireCallback(int handle, int eventId, int statusCode) {
    final cb = callbacks[handle];
    if (cb != null) cb(handle, eventId, statusCode);
  }

  @override
  int plc_tag_create(String attributeString, int timeout) {
    createAttributeStrings.add(attributeString);
    final attrs = _parseAttributes(attributeString);
    final elemSize = int.tryParse(attrs['elem_size'] ?? '');
    final elemCount = int.tryParse(attrs['elem_count'] ?? '');
    final size = (elemSize != null && elemCount != null) ? elemSize * elemCount : defaultSize;
    final handle = _nextHandle++;
    tags[handle] = _MockTag(size);
    return handle;
  }

  @override
  int plc_tag_destroy(int tag) {
    tags.remove(tag);
    callbacks.remove(tag);
    return Status.ok.value;
  }

  @override
  void plc_tag_shutdown() {
    tags.clear();
    callbacks.clear();
    logger = null;
  }

  @override
  int plc_tag_check_lib_version(int req_major, int req_minor, int req_patch) =>
      Status.ok.value;

  @override
  int plc_tag_abort(int tag) => Status.ok.value;

  @override
  int plc_tag_lock(int tag) => Status.ok.value;

  @override
  int plc_tag_unlock(int tag) => Status.ok.value;

  @override
  int plc_tag_read(int tag, int timeout) {
    final override = statusOverride;
    if (override != null) return override.code;
    return Status.ok.value;
  }

  @override
  int plc_tag_write(int tag, int timeout) {
    final override = statusOverride;
    if (override != null) return override.code;
    return Status.ok.value;
  }

  @override
  int plc_tag_status(int tag) {
    final override = statusOverride;
    if (override != null) return override.code;
    return Status.ok.value;
  }

  @override
  String plc_tag_decode_error(int err) => 'mock-error:$err';

  @override
  int plc_tag_get_size(int tag) => tags[tag]?.size ?? 0;

  @override
  int plc_tag_set_size(int tag, int new_size) {
    final t = tags[tag];
    if (t == null) return Status.errorNotFound.value;
    t.resize(new_size);
    return Status.ok.value;
  }

  @override
  int plc_tag_get_int_attribute(int tag, String attrib_name, int default_value) {
    return tags[tag]?.attributes[attrib_name] ?? default_value;
  }

  @override
  int plc_tag_set_int_attribute(int tag, String attrib_name, int new_value) {
    tags[tag]?.attributes[attrib_name] = new_value;
    return Status.ok.value;
  }

  @override
  int plc_tag_register_callback(int tag_id, TagCallback callback) {
    callbacks[tag_id] = callback;
    return Status.ok.value;
  }

  @override
  int plc_tag_unregister_callback(int tag_id) {
    callbacks.remove(tag_id);
    return Status.ok.value;
  }

  @override
  int plc_tag_register_logger(LogCallback callback) {
    logger = callback;
    return Status.ok.value;
  }

  @override
  int plc_tag_unregister_logger() {
    logger = null;
    return Status.ok.value;
  }

  @override
  void plc_tag_set_debug_level(int debug_level) {}

  @override
  int plc_tag_get_bit(int tag, int offset_bit) {
    final t = tags[tag];
    if (t == null) return -1;
    final byteOffset = offset_bit ~/ 8;
    final bitOffset = offset_bit % 8;
    return ((t.bytes[byteOffset] >> bitOffset) & 0x1);
  }

  @override
  int plc_tag_set_bit(int tag, int offset_bit, int val) {
    final t = tags[tag];
    if (t == null) return Status.errorNotFound.value;
    final byteOffset = offset_bit ~/ 8;
    final bitOffset = offset_bit % 8;
    if (val != 0) {
      t.bytes[byteOffset] |= (1 << bitOffset);
    } else {
      t.bytes[byteOffset] &= ~(1 << bitOffset);
    }
    return Status.ok.value;
  }

  @override
  int plc_tag_get_int8(int tag, int offset) => tags[tag]!.view.getInt8(offset);
  @override
  int plc_tag_set_int8(int tag, int offset, int val) {
    tags[tag]!.view.setInt8(offset, val);
    return Status.ok.value;
  }

  @override
  int plc_tag_get_uint8(int tag, int offset) => tags[tag]!.view.getUint8(offset);
  @override
  int plc_tag_set_uint8(int tag, int offset, int val) {
    tags[tag]!.view.setUint8(offset, val);
    return Status.ok.value;
  }

  @override
  int plc_tag_get_int16(int tag, int offset) => tags[tag]!.view.getInt16(offset, Endian.little);
  @override
  int plc_tag_set_int16(int tag, int offset, int val) {
    tags[tag]!.view.setInt16(offset, val, Endian.little);
    return Status.ok.value;
  }

  @override
  int plc_tag_get_uint16(int tag, int offset) => tags[tag]!.view.getUint16(offset, Endian.little);
  @override
  int plc_tag_set_uint16(int tag, int offset, int val) {
    tags[tag]!.view.setUint16(offset, val, Endian.little);
    return Status.ok.value;
  }

  @override
  int plc_tag_get_int32(int tag, int offset) => tags[tag]!.view.getInt32(offset, Endian.little);
  @override
  int plc_tag_set_int32(int tag, int offset, int val) {
    tags[tag]!.view.setInt32(offset, val, Endian.little);
    return Status.ok.value;
  }

  @override
  int plc_tag_get_uint32(int tag, int offset) => tags[tag]!.view.getUint32(offset, Endian.little);
  @override
  int plc_tag_set_uint32(int tag, int offset, int val) {
    tags[tag]!.view.setUint32(offset, val, Endian.little);
    return Status.ok.value;
  }

  @override
  int plc_tag_get_int64(int tag, int offset) => tags[tag]!.view.getInt64(offset, Endian.little);
  @override
  int plc_tag_set_int64(int tag, int offset, int val) {
    tags[tag]!.view.setInt64(offset, val, Endian.little);
    return Status.ok.value;
  }

  @override
  int plc_tag_get_uint64(int tag, int offset) => tags[tag]!.view.getUint64(offset, Endian.little);
  @override
  int plc_tag_set_uint64(int tag, int offset, int val) {
    tags[tag]!.view.setUint64(offset, val, Endian.little);
    return Status.ok.value;
  }

  @override
  double plc_tag_get_float32(int tag, int offset) => tags[tag]!.view.getFloat32(offset, Endian.little);
  @override
  int plc_tag_set_float32(int tag, int offset, double val) {
    tags[tag]!.view.setFloat32(offset, val, Endian.little);
    return Status.ok.value;
  }

  @override
  double plc_tag_get_float64(int tag, int offset) => tags[tag]!.view.getFloat64(offset, Endian.little);
  @override
  int plc_tag_set_float64(int tag, int offset, double val) {
    tags[tag]!.view.setFloat64(offset, val, Endian.little);
    return Status.ok.value;
  }

  @override
  int plc_tag_get_raw_bytes(int tag, int start_offset, Uint8List buffer, int buffer_length) {
    final t = tags[tag];
    if (t == null) return Status.errorNotFound.value;
    for (var i = 0; i < buffer_length; i++) {
      buffer[i] = t.bytes[start_offset + i];
    }
    return Status.ok.value;
  }

  @override
  int plc_tag_set_raw_bytes(int tag, int start_offset, Uint8List buffer, int buffer_length) {
    final t = tags[tag];
    if (t == null) return Status.errorNotFound.value;
    for (var i = 0; i < buffer_length; i++) {
      t.bytes[start_offset + i] = buffer[i];
    }
    return Status.ok.value;
  }

  @override
  int plc_tag_get_string_length(int tag, int offset) {
    final t = tags[tag]!;
    var len = 0;
    while (offset + len < t.size && t.bytes[offset + len] != 0) len++;
    return len;
  }

  @override
  int plc_tag_get_string_capacity(int tag, int offset) => tags[tag]!.size - offset;

  @override
  int plc_tag_get_string_total_length(int tag, int offset) => plc_tag_get_string_length(tag, offset) + 1;

  @override
  int plc_tag_get_string(int tag, int offset, StringBuffer buffer, int buffer_length) {
    final t = tags[tag];
    if (t == null) return Status.errorNotFound.value;
    for (var i = 0; i < buffer_length; i++) {
      buffer.writeCharCode(t.bytes[offset + i]);
    }
    return Status.ok.value;
  }

  @override
  int plc_tag_set_string(int tag, int offset, String value) {
    final t = tags[tag];
    if (t == null) return Status.errorNotFound.value;
    final bytes = value.codeUnits;
    for (var i = 0; i < bytes.length; i++) {
      t.bytes[offset + i] = bytes[i];
    }
    t.bytes[offset + bytes.length] = 0;
    return Status.ok.value;
  }

  Map<String, String> _parseAttributes(String s) {
    final out = <String, String>{};
    for (final pair in s.split('&')) {
      final eq = pair.indexOf('=');
      if (eq < 0) continue;
      out[pair.substring(0, eq)] = pair.substring(eq + 1);
    }
    return out;
  }
}

class StatusOverride {
  final int code;
  StatusOverride(this.code);
}

class _MockTag {
  Uint8List bytes;
  ByteData view;
  final Map<String, int> attributes = {};
  _MockTag(int size)
      : bytes = Uint8List(size),
        view = ByteData(0) {
    view = ByteData.sublistView(bytes);
  }

  int get size => bytes.length;

  void resize(int newSize) {
    final next = Uint8List(newSize);
    final copyLen = newSize < bytes.length ? newSize : bytes.length;
    next.setRange(0, copyLen, bytes);
    bytes = next;
    view = ByteData.sublistView(bytes);
  }
}
