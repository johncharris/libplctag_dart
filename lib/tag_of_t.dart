import 'package:libplctag_dart/data_types/plc_mapper.dart';
import 'package:libplctag_dart/debug_level.dart';
import 'package:libplctag_dart/native/plctag.dart' show LogCallback, TagCallback;
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/protocol.dart';
import 'package:libplctag_dart/status.dart';
import 'package:libplctag_dart/tag_event.dart';
import 'tag.dart' as untyped;

/// Strongly-typed PLC tag whose value is encoded/decoded through a [PlcMapper].
///
/// `T` is the Dart-side value type — for example `int` (a single DINT),
/// `List<int>` (a DINT array), or a domain type like `AbTimer`.
class Tag<T> {
  final PlcMapper<T> _mapper;
  final untyped.Tag _tag;

  Tag(this._mapper) : _tag = untyped.Tag()..elementSize = _mapper.elementSize;

  // -------------------------------------------------------------------
  // Configuration — forwards to the underlying [untyped.Tag].
  // -------------------------------------------------------------------

  int? get elementCount => _tag.elementCount;
  set elementCount(int? value) => _tag.elementCount = value;

  int? get elementSize => _tag.elementSize;
  set elementSize(int? value) => _tag.elementSize = value;

  String? get gateway => _tag.gateway;
  set gateway(String? value) => _tag.gateway = value;

  String? get name => _tag.name;
  set name(String? value) => _tag.name = value;

  String? get path => _tag.path;
  set path(String? value) => _tag.path = value;

  PlcType? get plcType => _tag.plcType;
  set plcType(PlcType? value) => _tag.plcType = value;

  Protocol? get protocol => _tag.protocol;
  set protocol(Protocol? value) => _tag.protocol = value;

  int? get readCacheMillisecondDuration => _tag.readCacheMillisecondDuration;
  set readCacheMillisecondDuration(int? value) =>
      _tag.readCacheMillisecondDuration = value;

  Duration get timeout => _tag.timeout;
  set timeout(Duration value) => _tag.timeout = value;

  bool? get useConnectedMessaging => _tag.useConnectedMessaging;
  set useConnectedMessaging(bool? value) => _tag.useConnectedMessaging = value;

  Duration? get autoSyncReadInterval => _tag.autoSyncReadInterval;
  set autoSyncReadInterval(Duration? value) => _tag.autoSyncReadInterval = value;

  Duration? get autoSyncWriteInterval => _tag.autoSyncWriteInterval;
  set autoSyncWriteInterval(Duration? value) => _tag.autoSyncWriteInterval = value;

  DebugLevel get debugLevel => _tag.debugLevel;
  set debugLevel(DebugLevel value) => _tag.debugLevel = value;

  /// Dimensions of [value] if it represents an array — e.g. `[10]` for a
  /// 10-element 1D array, `[2, 10]` for a 2-row x 10-col 2D array.
  /// Leave null for non-array tags.
  List<int>? get arrayDimensions => _mapper.arrayDimensions;
  set arrayDimensions(List<int>? value) {
    _mapper.arrayDimensions = value;
    _tag.elementCount = _mapper.getElementCount();
  }

  // -------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------

  /// Allocate native resources, connect to the PLC, and decode an initial [value].
  void initialize() {
    final mapperCount = _mapper.getElementCount();
    if (mapperCount != null) _tag.elementCount = mapperCount;
    _tag.initialize();
    _decodeAll();
  }

  /// Synchronous read followed by a decode into [value].
  void read() {
    _tag.read();
    _decodeAll();
  }

  /// Non-blocking read; [value] is updated when the future completes.
  Future<void> readAsync() async {
    await _tag.readAsync();
    _decodeAll();
  }

  /// Encode [value] and write synchronously.
  void write() {
    _encodeAll();
    _tag.write();
  }

  /// Encode [value] and write non-blockingly.
  Future<void> writeAsync() async {
    _encodeAll();
    await _tag.writeAsync();
  }

  Status getStatus() => _tag.getStatus();

  void abort() => _tag.abort();

  /// Release native resources.
  void dispose() => _tag.dispose();

  void _decodeAll() {
    value = _mapper.decode(_tag);
  }

  void _encodeAll() {
    final v = value;
    if (v == null) throw StateError('Cannot encode a null value');
    _mapper.encode(_tag, v);
  }

  // -------------------------------------------------------------------
  // Per-tag attributes + callbacks + events
  // -------------------------------------------------------------------

  int getIntAttribute(String attributeName) => _tag.getIntAttribute(attributeName);
  void setIntAttribute(String attributeName, int value) =>
      _tag.setIntAttribute(attributeName, value);

  void registerCallback(TagCallback callback) => _tag.registerCallback(callback);
  void unregisterCallback() => _tag.unregisterCallback();

  /// Broadcast stream of typed tag events. See [untyped.Tag.events].
  Stream<TagEvent> get events => _tag.events;

  // -------------------------------------------------------------------
  // Library-wide operations (delegate to [untyped.Tag]).
  // -------------------------------------------------------------------

  static void shutdownLibrary() => untyped.Tag.shutdownLibrary();
  static int checkLibraryVersion(int major, int minor, int patch) =>
      untyped.Tag.checkLibraryVersion(major, minor, patch);
  static void registerLogger(LogCallback callback) =>
      untyped.Tag.registerLogger(callback);
  static void unregisterLogger() => untyped.Tag.unregisterLogger();

  /// The Dart-side value mirroring the PLC tag. Updated on [read] /
  /// [readAsync] and pushed to the PLC on [write] / [writeAsync].
  T? value;
}
