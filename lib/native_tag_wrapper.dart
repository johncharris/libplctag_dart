import 'dart:typed_data';

import 'package:libplctag_dart/debug_level.dart';
import 'package:libplctag_dart/libplctag_exception.dart';
import 'package:libplctag_dart/native/plctag.dart';
import 'package:libplctag_dart/native_tag.dart';
import 'package:libplctag_dart/native_tag_base.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/status.dart';

/// State machine + attribute-string assembler that wraps a single native
/// tag handle. Most users interact through the [Tag] / [Tag] generic facade;
/// this class is the seam where the FFI calls actually happen.
class NativeTagWrapper {
  /// Sentinel passed to `plc_tag_read`/`plc_tag_write` to make them
  /// return immediately with [Status.pending] for asynchronous polling.
  static const int asyncOperationTimeoutMs = 0;

  /// Milliseconds between status polls while awaiting an async operation.
  static const int asyncStatusPollIntervalMs = 2;

  /// Sentinel passed to `plc_tag_get_int_attribute` to detect failure —
  /// `INT32_MIN`, chosen because no real attribute returns this value.
  static const int _intAttributeFailureSentinel = -2147483648;

  static const Duration _defaultTimeout = Duration(seconds: 10);
  static const Duration _maxTimeout = Duration(milliseconds: 2147483647);

  static final NativeTagBase _defaultNative = NativeTag();

  final NativeTagBase _native;

  late int nativeTagHandle;
  bool _isDisposed = false;
  bool _isInitialized = false;

  NativeTagWrapper(this._native);

  // -------------------------------------------------------------------
  // Configurable properties — must be set before [initialize].
  // -------------------------------------------------------------------

  String? _name;
  String? get name => _checkAlive(_name);
  set name(String? value) {
    _assertMutable();
    _name = value;
  }

  String? _protocol;
  String? get protocol => _checkAlive(_protocol);
  set protocol(String? value) {
    _assertMutable();
    _protocol = value;
  }

  String? _gateway;
  String? get gateway => _checkAlive(_gateway);
  set gateway(String? value) {
    _assertMutable();
    _gateway = value;
  }

  PlcType? _plcType;
  PlcType? get plcType => _checkAlive(_plcType);
  set plcType(PlcType? value) {
    _assertMutable();
    _plcType = value;
  }

  String? _path;
  String? get path => _checkAlive(_path);
  set path(String? value) {
    _assertMutable();
    _path = value;
  }

  int? _elementSize;
  int? get elementSize => _checkAlive(_elementSize);
  set elementSize(int? value) {
    _assertMutable();
    _elementSize = value;
  }

  int? _elementCount;
  int? get elementCount => _checkAlive(_elementCount);
  set elementCount(int? value) {
    _assertMutable();
    _elementCount = value;
  }

  bool? _useConnectedMessaging;
  bool? get useConnectedMessaging => _checkAlive(_useConnectedMessaging);
  set useConnectedMessaging(bool? value) {
    _assertMutable();
    _useConnectedMessaging = value;
  }

  /// Cached read interval. Pre-init this is local state; post-init it's
  /// read/written via `plc_tag_get_int_attribute` so the value reflects
  /// what the library is actually using.
  int? _readCacheMillisecondDuration;
  int? get readCacheMillisecondDuration {
    _assertNotDisposed();
    if (!_isInitialized) return _readCacheMillisecondDuration;
    return getIntAttribute('read_cache_ms');
  }

  set readCacheMillisecondDuration(int? value) {
    _assertNotDisposed();
    if (!_isInitialized) {
      _readCacheMillisecondDuration = value;
      return;
    }
    if (value != null) setIntAttribute('read_cache_ms', value);
  }

  Duration? _timeout;
  Duration get timeout {
    _assertNotDisposed();
    return _timeout ?? _defaultTimeout;
  }

  set timeout(Duration value) {
    _assertNotDisposed();
    if (value <= Duration.zero || value > _maxTimeout) {
      throw ArgumentError.value(value, 'timeout', 'must be > 0 and <= INT32_MAX ms');
    }
    _timeout = value;
  }

  Duration? _autoSyncReadInterval;
  Duration? get autoSyncReadInterval => _checkAlive(_autoSyncReadInterval);
  set autoSyncReadInterval(Duration? value) {
    _assertMutable();
    _autoSyncReadInterval = value;
  }

  Duration? _autoSyncWriteInterval;
  Duration? get autoSyncWriteInterval => _checkAlive(_autoSyncWriteInterval);
  set autoSyncWriteInterval(Duration? value) {
    _assertMutable();
    _autoSyncWriteInterval = value;
  }

  DebugLevel _debugLevel = DebugLevel.none;
  DebugLevel get debugLevel => _checkAlive(_debugLevel);
  set debugLevel(DebugLevel value) {
    _assertMutable();
    _debugLevel = value;
  }

  String? _int16ByteOrder;
  String? get int16ByteOrder => _checkAlive(_int16ByteOrder);
  set int16ByteOrder(String? value) {
    _assertMutable();
    _int16ByteOrder = value;
  }

  String? _int32ByteOrder;
  String? get int32ByteOrder => _checkAlive(_int32ByteOrder);
  set int32ByteOrder(String? value) {
    _assertMutable();
    _int32ByteOrder = value;
  }

  String? _int64ByteOrder;
  String? get int64ByteOrder => _checkAlive(_int64ByteOrder);
  set int64ByteOrder(String? value) {
    _assertMutable();
    _int64ByteOrder = value;
  }

  String? _float32ByteOrder;
  String? get float32ByteOrder => _checkAlive(_float32ByteOrder);
  set float32ByteOrder(String? value) {
    _assertMutable();
    _float32ByteOrder = value;
  }

  String? _float64ByteOrder;
  String? get float64ByteOrder => _checkAlive(_float64ByteOrder);
  set float64ByteOrder(String? value) {
    _assertMutable();
    _float64ByteOrder = value;
  }

  int? _stringCountWordBytes;
  int? get stringCountWordBytes => _checkAlive(_stringCountWordBytes);
  set stringCountWordBytes(int? value) {
    _assertMutable();
    _stringCountWordBytes = value;
  }

  bool? _stringIsByteSwapped;
  bool? get stringIsByteSwapped => _checkAlive(_stringIsByteSwapped);
  set stringIsByteSwapped(bool? value) {
    _assertMutable();
    _stringIsByteSwapped = value;
  }

  bool? _stringIsCounted;
  bool? get stringIsCounted => _checkAlive(_stringIsCounted);
  set stringIsCounted(bool? value) {
    _assertMutable();
    _stringIsCounted = value;
  }

  bool? _stringIsFixedLength;
  bool? get stringIsFixedLength => _checkAlive(_stringIsFixedLength);
  set stringIsFixedLength(bool? value) {
    _assertMutable();
    _stringIsFixedLength = value;
  }

  bool? _stringIsZeroTerminated;
  bool? get stringIsZeroTerminated => _checkAlive(_stringIsZeroTerminated);
  set stringIsZeroTerminated(bool? value) {
    _assertMutable();
    _stringIsZeroTerminated = value;
  }

  int? _stringMaxCapacity;
  int? get stringMaxCapacity => _checkAlive(_stringMaxCapacity);
  set stringMaxCapacity(int? value) {
    _assertMutable();
    _stringMaxCapacity = value;
  }

  int? _stringPadBytes;
  int? get stringPadBytes => _checkAlive(_stringPadBytes);
  set stringPadBytes(int? value) {
    _assertMutable();
    _stringPadBytes = value;
  }

  int? _stringTotalLength;
  int? get stringTotalLength => _checkAlive(_stringTotalLength);
  set stringTotalLength(int? value) {
    _assertMutable();
    _stringTotalLength = value;
  }

  // -------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------

  bool get isInitialized => _isInitialized;
  bool get isDisposed => _isDisposed;

  void initialize() {
    _assertNotDisposed();
    _assertNotInitialized();

    final attributeString = getAttributeString();
    final result = _native.plc_tag_create(attributeString, timeout.inMilliseconds);
    if (result < 0) throw LibPlcTagException(Status.fromInt(result));

    nativeTagHandle = result;
    _isInitialized = true;
  }

  void dispose() {
    if (_isDisposed) return;
    if (_isInitialized) {
      _throwIfNotOk(Status.fromInt(_native.plc_tag_destroy(nativeTagHandle)));
    }
    _isDisposed = true;
  }

  void abort() {
    _assertNotDisposed();
    _throwIfNotOk(Status.fromInt(_native.plc_tag_abort(nativeTagHandle)));
  }

  void read() {
    _assertNotDisposed();
    _initializeIfRequired();
    _throwIfNotOk(Status.fromInt(_native.plc_tag_read(nativeTagHandle, timeout.inMilliseconds)));
  }

  void write() {
    _assertNotDisposed();
    _initializeIfRequired();
    _throwIfNotOk(Status.fromInt(_native.plc_tag_write(nativeTagHandle, timeout.inMilliseconds)));
  }

  /// Kicks off a non-blocking read and resolves when it finishes (or [timeout] elapses).
  Future<void> readAsync() async {
    _assertNotDisposed();
    _initializeIfRequired();

    final initial = Status.fromInt(_native.plc_tag_read(nativeTagHandle, asyncOperationTimeoutMs));
    if (initial == Status.ok) return;
    if (initial != Status.pending) throw LibPlcTagException(initial);

    await _awaitPending();
  }

  /// Kicks off a non-blocking write and resolves when it finishes (or [timeout] elapses).
  Future<void> writeAsync() async {
    _assertNotDisposed();
    _initializeIfRequired();

    final initial = Status.fromInt(_native.plc_tag_write(nativeTagHandle, asyncOperationTimeoutMs));
    if (initial == Status.ok) return;
    if (initial != Status.pending) throw LibPlcTagException(initial);

    await _awaitPending();
  }

  Future<void> _awaitPending() async {
    final deadline = DateTime.now().add(timeout);
    while (true) {
      if (_isDisposed) throw LibPlcTagException(Status.errorAbort);

      final status = Status.fromInt(_native.plc_tag_status(nativeTagHandle));
      if (status == Status.ok) return;
      if (status != Status.pending) throw LibPlcTagException(status);

      if (DateTime.now().isAfter(deadline)) {
        _native.plc_tag_abort(nativeTagHandle);
        throw LibPlcTagException(Status.errorTimeout);
      }

      await Future<void>.delayed(const Duration(milliseconds: asyncStatusPollIntervalMs));
    }
  }

  int getSize() {
    _assertNotDisposed();
    final result = _native.plc_tag_get_size(nativeTagHandle);
    if (result < 0) throw LibPlcTagException(Status.fromInt(result));
    return result;
  }

  void setSize(int newSize) {
    _assertNotDisposed();
    _throwIfNotOk(Status.fromInt(_native.plc_tag_set_size(nativeTagHandle, newSize)));
  }

  Status getStatus() {
    _assertNotDisposed();
    return Status.fromInt(_native.plc_tag_status(nativeTagHandle));
  }

  Uint8List getBuffer() {
    _assertNotDisposed();
    final size = getSize();
    final buffer = Uint8List(size);
    _throwIfNotOk(Status.fromInt(_native.plc_tag_get_raw_bytes(nativeTagHandle, 0, buffer, size)));
    return buffer;
  }

  int getIntAttribute(String attributeName) {
    _assertNotDisposed();
    final result = _native.plc_tag_get_int_attribute(
        nativeTagHandle, attributeName, _intAttributeFailureSentinel);
    if (result == _intAttributeFailureSentinel) _throwIfStatusBad();
    return result;
  }

  void setIntAttribute(String attributeName, int value) {
    _assertNotDisposed();
    _throwIfNotOk(Status.fromInt(
        _native.plc_tag_set_int_attribute(nativeTagHandle, attributeName, value)));
  }

  void registerCallback(TagCallback callback) {
    _assertNotDisposed();
    _throwIfNotOk(
        Status.fromInt(_native.plc_tag_register_callback(nativeTagHandle, callback)));
  }

  void unregisterCallback() {
    _assertNotDisposed();
    _throwIfNotOk(Status.fromInt(_native.plc_tag_unregister_callback(nativeTagHandle)));
  }

  // -------------------------------------------------------------------
  // Library-wide (not per-tag) operations
  // -------------------------------------------------------------------

  static void shutdownLibrary([NativeTagBase? native]) =>
      (native ?? _defaultNative).plc_tag_shutdown();

  static int checkLibraryVersion(int requiredMajor, int requiredMinor, int requiredPatch,
          [NativeTagBase? native]) =>
      (native ?? _defaultNative)
          .plc_tag_check_lib_version(requiredMajor, requiredMinor, requiredPatch);

  static void registerLogger(LogCallback callback, [NativeTagBase? native]) {
    final status = Status.fromInt((native ?? _defaultNative).plc_tag_register_logger(callback));
    if (status != Status.ok) throw LibPlcTagException(status);
  }

  static void unregisterLogger([NativeTagBase? native]) {
    final status = Status.fromInt((native ?? _defaultNative).plc_tag_unregister_logger());
    if (status != Status.ok) throw LibPlcTagException(status);
  }

  // -------------------------------------------------------------------
  // Typed accessors. These mirror plc_tag_get_*/plc_tag_set_* in libplctag.
  //
  // Some signed/unsigned `get` calls return `INT32_MIN`/`INT32_MAX` as
  // an error sentinel; we re-check status when we see that value.
  // -------------------------------------------------------------------

  static const int _int32Max = 2147483647;
  static const int _int32Min = -2147483648;

  bool getBit(int offset) {
    _assertNotDisposed();
    final result = _native.plc_tag_get_bit(nativeTagHandle, offset);
    return switch (result) {
      0 => false,
      1 => true,
      _ => throw LibPlcTagException(Status.fromInt(result)),
    };
  }

  void setBit(int offset, bool value) =>
      _setNativeTagValue<int>(_native.plc_tag_set_bit, offset, value ? 1 : 0);

  int getUInt64(int offset) =>
      _getNativeValueWithSentinel(_native.plc_tag_get_uint64, offset, _int32Max);
  void setUInt64(int offset, int value) =>
      _setNativeTagValue<int>(_native.plc_tag_set_uint64, offset, value);

  int getInt64(int offset) =>
      _getNativeValueWithSentinel(_native.plc_tag_get_int64, offset, _int32Max);
  void setInt64(int offset, int value) =>
      _setNativeTagValue<int>(_native.plc_tag_set_int64, offset, value);

  int getUInt32(int offset) =>
      _getNativeValueWithSentinel(_native.plc_tag_get_uint32, offset, _int32Max);
  void setUInt32(int offset, int value) =>
      _setNativeTagValue<int>(_native.plc_tag_set_uint32, offset, value);

  int getInt32(int offset) =>
      _getNativeValueWithSentinel(_native.plc_tag_get_int32, offset, _int32Min);
  void setInt32(int offset, int value) =>
      _setNativeTagValue<int>(_native.plc_tag_set_int32, offset, value);

  int getUInt16(int offset) =>
      _getNativeValueWithSentinel(_native.plc_tag_get_uint16, offset, _int32Max);
  void setUInt16(int offset, int value) =>
      _setNativeTagValue<int>(_native.plc_tag_set_uint16, offset, value);

  int getInt16(int offset) =>
      _getNativeValueWithSentinel(_native.plc_tag_get_int16, offset, _int32Min);
  void setInt16(int offset, int value) =>
      _setNativeTagValue<int>(_native.plc_tag_set_int16, offset, value);

  int getUInt8(int offset) =>
      _getNativeValueWithSentinel(_native.plc_tag_get_uint8, offset, _int32Max);
  void setUInt8(int offset, int value) =>
      _setNativeTagValue<int>(_native.plc_tag_set_uint8, offset, value);

  int getInt8(int offset) =>
      _getNativeValueWithSentinel(_native.plc_tag_get_int8, offset, _int32Min);
  void setInt8(int offset, int value) =>
      _setNativeTagValue<int>(_native.plc_tag_set_int8, offset, value);

  double getFloat64(int offset) =>
      _getNativeValueWithSentinel(_native.plc_tag_get_float64, offset, double.minPositive);
  void setFloat64(int offset, double value) =>
      _setNativeTagValue<double>(_native.plc_tag_set_float64, offset, value);

  double getFloat32(int offset) =>
      _getNativeValueWithSentinel(_native.plc_tag_get_float32, offset, double.minPositive);
  void setFloat32(int offset, double value) =>
      _setNativeTagValue<double>(_native.plc_tag_set_float32, offset, value);

  void setString(int offset, String value) =>
      _setNativeTagValue<String>(_native.plc_tag_set_string, offset, value);
  int getStringLength(int offset) =>
      _getNativeValueAndThrowOnNegative(_native.plc_tag_get_string_length, offset);
  int getStringCapacity(int offset) =>
      _getNativeValueAndThrowOnNegative(_native.plc_tag_get_string_capacity, offset);
  int getStringTotalLength(int offset) =>
      _getNativeValueAndThrowOnNegative(_native.plc_tag_get_string_total_length, offset);
  String getString(int offset) {
    _assertNotDisposed();
    final length = getStringLength(offset);
    final buffer = StringBuffer();
    _throwIfNotOk(Status.fromInt(
        _native.plc_tag_get_string(nativeTagHandle, offset, buffer, length)));
    return buffer.toString();
  }

  // -------------------------------------------------------------------
  // Internal helpers
  // -------------------------------------------------------------------

  T _checkAlive<T>(T value) {
    _assertNotDisposed();
    return value;
  }

  void _assertNotDisposed() {
    if (_isDisposed) {
      throw StateError('NativeTagWrapper has been disposed');
    }
  }

  void _assertNotInitialized() {
    if (_isInitialized) {
      throw StateError('NativeTagWrapper is already initialized');
    }
  }

  void _assertMutable() {
    _assertNotDisposed();
    _assertNotInitialized();
  }

  void _initializeIfRequired() {
    if (!_isInitialized) initialize();
  }

  void _throwIfNotOk(Status status) {
    if (status != Status.ok) throw LibPlcTagException(status);
  }

  void _throwIfStatusBad() {
    final status = getStatus();
    if (status != Status.ok) throw LibPlcTagException(status);
  }

  void _setNativeTagValue<T>(int Function(int, int, T) nativeMethod, int offset, T value) {
    _assertNotDisposed();
    _throwIfNotOk(Status.fromInt(nativeMethod(nativeTagHandle, offset, value)));
  }

  int _getNativeValueAndThrowOnNegative(int Function(int, int) nativeMethod, int offset) {
    _assertNotDisposed();
    final result = nativeMethod(nativeTagHandle, offset);
    if (result < 0) throw LibPlcTagException(Status.fromInt(result));
    return result;
  }

  T _getNativeValueWithSentinel<T>(
      T Function(int, int) nativeMethod, int offset, T errorSentinel) {
    _assertNotDisposed();
    final result = nativeMethod(nativeTagHandle, offset);
    if (result == errorSentinel) _throwIfStatusBad();
    return result;
  }

  // -------------------------------------------------------------------
  // Attribute string assembly
  // -------------------------------------------------------------------

  String getAttributeString() {
    String? formatBool(bool? value) =>
        value == null ? null : (value ? '1' : '0');

    final attributes = <String, String?>{
      'protocol': protocol,
      'gateway': gateway,
      'path': path,
      'plc': plcType?.wireName,
      'elem_size': elementSize?.toString(),
      'elem_count': elementCount?.toString(),
      'name': name,
      'read_cache_ms': readCacheMillisecondDuration?.toString(),
      'use_connected_msg': formatBool(useConnectedMessaging),
      'auto_sync_read_ms': autoSyncReadInterval?.inMilliseconds.toString(),
      'auto_sync_write_ms': autoSyncWriteInterval?.inMilliseconds.toString(),
      'debug': debugLevel == DebugLevel.none ? null : debugLevel.value.toString(),
      'int16_byte_order': int16ByteOrder,
      'int32_byte_order': int32ByteOrder,
      'int64_byte_order': int64ByteOrder,
      'float32_byte_order': float32ByteOrder,
      'float64_byte_order': float64ByteOrder,
      'str_count_word_bytes': stringCountWordBytes?.toString(),
      'str_is_byte_swapped': formatBool(stringIsByteSwapped),
      'str_is_counted': formatBool(stringIsCounted),
      'str_is_fixed_length': formatBool(stringIsFixedLength),
      'str_is_zero_terminated': formatBool(stringIsZeroTerminated),
      'str_max_capacity': stringMaxCapacity?.toString(),
      'str_pad_bytes': stringPadBytes?.toString(),
      'str_total_length': stringTotalLength?.toString(),
    };

    return attributes.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${e.value}')
        .join('&');
  }
}
