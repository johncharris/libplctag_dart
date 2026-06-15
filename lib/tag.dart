import 'dart:async';
import 'dart:typed_data';

import 'package:libplctag_dart/debug_level.dart';
import 'package:libplctag_dart/native/plctag.dart';
import 'package:libplctag_dart/native_tag.dart';
import 'package:libplctag_dart/native_tag_wrapper.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/protocol.dart';
import 'package:libplctag_dart/status.dart';
import 'package:libplctag_dart/tag_event.dart';

/// Untyped tag facade: exposes the raw byte-level read/write API plus the
/// configuration attributes used to construct the underlying native tag.
///
/// For a strongly-typed handle that decodes/encodes a Dart value through
/// a [PlcMapper], use `Tag<T>` from `package:libplctag_dart/tag_of_t.dart`.
class Tag {
  /// Run-once finalizer that destroys the native handle if the user
  /// forgets to call [dispose]. Adopted by every [Tag] on construction.
  static final Finalizer<NativeTagWrapper> _finalizer =
      Finalizer<NativeTagWrapper>((wrapper) => wrapper.dispose());

  final NativeTagWrapper _tag;
  StreamController<TagEvent>? _eventController;

  Tag() : _tag = NativeTagWrapper(NativeTag()) {
    _finalizer.attach(this, _tag, detach: this);
  }

  // -------------------------------------------------------------------
  // Configurable properties — see libplctag's attribute string docs.
  // -------------------------------------------------------------------

  /// Number of elements in the tag. All tags are treated as arrays;
  /// non-arrays have length 1.
  int? get elementCount => _tag.elementCount;
  set elementCount(int? value) => _tag.elementCount = value;

  /// Bytes per element. Ignored for Modbus and Allen-Bradley PLCs.
  int? get elementSize => _tag.elementSize;
  set elementSize(int? value) => _tag.elementSize = value;

  /// Hostname or IP address of the PLC (or gateway to it).
  String? get gateway => _tag.gateway;
  set gateway(String? value) => _tag.gateway = value;

  /// Fully-qualified tag name. Prepend `Program:{ProgramName}.` for program-scoped tags.
  String? get name => _tag.name;
  set name(String? value) => _tag.name = value;

  /// Routing path. Required for CompactLogix/ControlLogix tags and DH+
  /// bridge routes; must be omitted for Micro800.
  String? get path => _tag.path;
  set path(String? value) => _tag.path = value;

  /// PLC family. Written as `plc=<wireName>` in the attribute string.
  PlcType? get plcType => _tag.plcType;
  set plcType(PlcType? value) => _tag.plcType = value;

  /// Wire protocol. Written as `protocol=<wireName>` in the attribute string.
  Protocol? get protocol => _protocol;
  set protocol(Protocol? value) {
    _protocol = value;
    _tag.protocol = value?.wireName;
  }

  Protocol? _protocol;

  /// Cache reads for at most this many milliseconds — useful to throttle
  /// frequent reads of the same tag.
  int? get readCacheMillisecondDuration => _tag.readCacheMillisecondDuration;
  set readCacheMillisecondDuration(int? value) =>
      _tag.readCacheMillisecondDuration = value;

  /// Timeout for [initialize], [read], [write], and their async variants.
  Duration get timeout => _tag.timeout;
  set timeout(Duration value) => _tag.timeout = value;

  /// Whether to use connected messaging. Only meaningful on Logix PLCs;
  /// required on Micro800 and DH+ bridged links. Defaults vary by PLC.
  bool? get useConnectedMessaging => _tag.useConnectedMessaging;
  set useConnectedMessaging(bool? value) => _tag.useConnectedMessaging = value;

  /// Periodic auto-read interval. Used in conjunction with [events] to
  /// react to PLC-side changes.
  Duration? get autoSyncReadInterval => _tag.autoSyncReadInterval;
  set autoSyncReadInterval(Duration? value) => _tag.autoSyncReadInterval = value;

  /// Buffer interval before writes are pushed to the PLC. Reduces wire
  /// traffic by coalescing rapid updates.
  Duration? get autoSyncWriteInterval => _tag.autoSyncWriteInterval;
  set autoSyncWriteInterval(Duration? value) => _tag.autoSyncWriteInterval = value;

  DebugLevel get debugLevel => _tag.debugLevel;
  set debugLevel(DebugLevel value) => _tag.debugLevel = value;

  /// Byte order of 16-bit integers (e.g. `'10'` for little-endian).
  String? get int16ByteOrder => _tag.int16ByteOrder;
  set int16ByteOrder(String? value) => _tag.int16ByteOrder = value;

  String? get int32ByteOrder => _tag.int32ByteOrder;
  set int32ByteOrder(String? value) => _tag.int32ByteOrder = value;

  String? get int64ByteOrder => _tag.int64ByteOrder;
  set int64ByteOrder(String? value) => _tag.int64ByteOrder = value;

  String? get float32ByteOrder => _tag.float32ByteOrder;
  set float32ByteOrder(String? value) => _tag.float32ByteOrder = value;

  String? get float64ByteOrder => _tag.float64ByteOrder;
  set float64ByteOrder(String? value) => _tag.float64ByteOrder = value;

  /// Size of the leading count word in a string (1, 2, 4 or 8 bytes).
  int? get stringCountWordBytes => _tag.stringCountWordBytes;
  set stringCountWordBytes(int? value) => _tag.stringCountWordBytes = value;

  bool? get stringIsByteSwapped => _tag.stringIsByteSwapped;
  set stringIsByteSwapped(bool? value) => _tag.stringIsByteSwapped = value;

  bool? get stringIsCounted => _tag.stringIsCounted;
  set stringIsCounted(bool? value) => _tag.stringIsCounted = value;

  bool? get stringIsFixedLength => _tag.stringIsFixedLength;
  set stringIsFixedLength(bool? value) => _tag.stringIsFixedLength = value;

  bool? get stringIsZeroTerminated => _tag.stringIsZeroTerminated;
  set stringIsZeroTerminated(bool? value) => _tag.stringIsZeroTerminated = value;

  int? get stringMaxCapacity => _tag.stringMaxCapacity;
  set stringMaxCapacity(int? value) => _tag.stringMaxCapacity = value;

  int? get stringPadBytes => _tag.stringPadBytes;
  set stringPadBytes(int? value) => _tag.stringPadBytes = value;

  int? get stringTotalLength => _tag.stringTotalLength;
  set stringTotalLength(int? value) => _tag.stringTotalLength = value;

  // -------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------

  /// Allocate native resources and connect to the PLC. May only be called once.
  void initialize() => _tag.initialize();

  /// Synchronous read into the local tag buffer.
  void read() => _tag.read();

  /// Non-blocking read; completes when the operation finishes or [timeout] elapses.
  Future<void> readAsync() => _tag.readAsync();

  /// Synchronous write from the local tag buffer to the PLC.
  void write() => _tag.write();

  /// Non-blocking write; completes when the operation finishes or [timeout] elapses.
  Future<void> writeAsync() => _tag.writeAsync();

  /// Abort the current in-flight operation, if any.
  void abort() => _tag.abort();

  /// Release native resources. Safe to call multiple times. Once called,
  /// any further use of this [Tag] throws.
  void dispose() {
    _finalizer.detach(this);
    _eventController?.close();
    _eventController = null;
    _tag.dispose();
  }

  /// Raw, unprocessed tag buffer. Length equals [getSize].
  Uint8List getBuffer() => _tag.getBuffer();

  int getSize() => _tag.getSize();
  void setSize(int newSize) => _tag.setSize(newSize);

  /// Current operational status of the tag.
  Status getStatus() => _tag.getStatus();

  // -------------------------------------------------------------------
  // Raw byte-level accessors
  // -------------------------------------------------------------------

  bool getBit(int offset) => _tag.getBit(offset);
  void setBit(int offset, bool value) => _tag.setBit(offset, value);

  double getFloat32(int offset) => _tag.getFloat32(offset);
  void setFloat32(int offset, double value) => _tag.setFloat32(offset, value);

  double getFloat64(int offset) => _tag.getFloat64(offset);
  void setFloat64(int offset, double value) => _tag.setFloat64(offset, value);

  int getInt8(int offset) => _tag.getInt8(offset);
  void setInt8(int offset, int value) => _tag.setInt8(offset, value);

  int getInt16(int offset) => _tag.getInt16(offset);
  void setInt16(int offset, int value) => _tag.setInt16(offset, value);

  int getInt32(int offset) => _tag.getInt32(offset);
  void setInt32(int offset, int value) => _tag.setInt32(offset, value);

  int getInt64(int offset) => _tag.getInt64(offset);
  void setInt64(int offset, int value) => _tag.setInt64(offset, value);

  int getUInt8(int offset) => _tag.getUInt8(offset);
  void setUInt8(int offset, int value) => _tag.setUInt8(offset, value);

  int getUInt16(int offset) => _tag.getUInt16(offset);
  void setUInt16(int offset, int value) => _tag.setUInt16(offset, value);

  int getUInt32(int offset) => _tag.getUInt32(offset);
  void setUInt32(int offset, int value) => _tag.setUInt32(offset, value);

  int getUInt64(int offset) => _tag.getUInt64(offset);
  void setUInt64(int offset, int value) => _tag.setUInt64(offset, value);

  void setString(int offset, String value) => _tag.setString(offset, value);
  int getStringLength(int offset) => _tag.getStringLength(offset);
  int getStringTotalLength(int offset) => _tag.getStringTotalLength(offset);
  int getStringCapacity(int offset) => _tag.getStringCapacity(offset);
  String getString(int offset) => _tag.getString(offset);

  // -------------------------------------------------------------------
  // Runtime attributes + callbacks + events
  // -------------------------------------------------------------------

  /// Read a runtime integer attribute. Tag must be initialized.
  int getIntAttribute(String attributeName) => _tag.getIntAttribute(attributeName);

  /// Write a runtime integer attribute. Tag must be initialized.
  void setIntAttribute(String attributeName, int value) =>
      _tag.setIntAttribute(attributeName, value);

  /// Register a raw Dart callback for native tag events.
  ///
  /// Most callers should subscribe to [events] instead.
  void registerCallback(TagCallback callback) => _tag.registerCallback(callback);

  /// Unregister the callback previously installed by [registerCallback].
  void unregisterCallback() => _tag.unregisterCallback();

  /// Broadcast stream of typed [TagEvent]s for this tag. Lazily registers
  /// a native callback on first listen and unregisters on cancel.
  Stream<TagEvent> get events {
    final existing = _eventController;
    if (existing != null) return existing.stream;

    final controller = StreamController<TagEvent>.broadcast(
      onListen: () {
        _tag.registerCallback((tagId, eventId, status) {
          final evt = TagEvent.fromRaw(tagId, eventId, status);
          if (evt != null) _eventController?.add(evt);
        });
      },
      onCancel: () {
        try {
          _tag.unregisterCallback();
        } catch (_) {
          // The tag may already be disposed.
        }
      },
    );
    _eventController = controller;
    return controller.stream;
  }

  // -------------------------------------------------------------------
  // Library-wide operations
  // -------------------------------------------------------------------

  /// Shut down the native library. Call only after every tag is destroyed.
  static void shutdownLibrary() => NativeTagWrapper.shutdownLibrary();

  /// Check that the loaded native library is at least the given version.
  /// Returns [Status.ok].`value` (0) if so.
  static int checkLibraryVersion(int major, int minor, int patch) =>
      NativeTagWrapper.checkLibraryVersion(major, minor, patch);

  /// Register a global log callback.
  static void registerLogger(LogCallback callback) =>
      NativeTagWrapper.registerLogger(callback);

  /// Unregister the global log callback.
  static void unregisterLogger() => NativeTagWrapper.unregisterLogger();
}
