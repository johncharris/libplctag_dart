import 'dart:typed_data';

import 'package:libplctag_dart/debug_level.dart';
import 'package:libplctag_dart/native_tag_base.dart';
import 'package:libplctag_dart/libplctag_exception.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/status.dart';

class NativeTagWrapper {
  static const int TIMEOUT_VALUE_THAT_INDICATES_ASYNC_OPERATION = 0;
  static const int ASYNC_STATUS_POLL_INTERVAL = 2;
  static final Duration _defaultTimeout = Duration(seconds: 10);
  static final Duration _maxTimeout = Duration(milliseconds: 2147483647);

  late int nativeTagHandle;

  bool _isDisposed = false;
  bool _isInitialized = false;

  final NativeTagBase _native;

  NativeTagWrapper(this._native);

  String? _name;
  String? get name => getField(_name);
  void set name(String? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _name = value;
  }

  String? _protocol;
  String? get protocol => getField(_protocol);
  void set protocol(String? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _protocol = value;
  }

  String? _gateway;
  String? get gateway => getField(_gateway);
  void set gateway(String? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _gateway = value;
  }

  PlcType? _plcType;
  PlcType? get plcType => getField(_plcType);
  void set plcType(PlcType? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _plcType = value;
  }

  String? _path;
  String? get path => getField(_path);
  void set path(String? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _path = value;
  }

  int? _elementSize;
  int? get elementSize => getField(_elementSize);
  void set elementSize(int? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _elementSize = value;
  }

  int? _elementCount;
  int? get elementCount => getField(_elementCount);
  void set elementCount(int? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _elementCount = value;
  }

  bool? _useConnectedMessaging;
  bool? get useConnectedMessaging => getField(_useConnectedMessaging);
  void set useConnectedMessaging(bool? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _useConnectedMessaging = value;
  }

  int? _readCacheMillisecondDuration;
  int? get readCacheMillisecondDuration {
    throwIfAlreadyDisposed();

    if (!_isInitialized) return _readCacheMillisecondDuration;

    return getIntAttribute("read_cache_ms");
  }

  void set readCacheMillisecondDuration(int? value) {
    throwIfAlreadyDisposed();

    if (!_isInitialized) {
      _readCacheMillisecondDuration = value;
      return;
    }

    if (value != null) setIntAttribute("read_cache_ms", value);
  }

  Duration? _timeout;
  Duration get timeout {
    throwIfAlreadyDisposed();
    return _timeout ?? _defaultTimeout;
  }

  void set timeout(Duration value) {
    throwIfAlreadyDisposed();
    if (value <= Duration.zero || value > _maxTimeout) throw new Exception("Timeout Must be greater than 0");
    _timeout = value;
  }

  Duration? _autoSyncReadInterval;
  Duration? get autoSyncReadInterval => getField(_autoSyncReadInterval);
  void set autoSyncReadInterval(Duration? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _autoSyncReadInterval = value;
  }

  Duration? _autoSyncWriteInterval;
  Duration? get autoSyncWriteInterval => getField(_autoSyncWriteInterval);
  void set autoSyncWriteInterval(Duration? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _autoSyncWriteInterval = value;
  }

  DebugLevel _debugLevel = DebugLevel.None;
  DebugLevel get debugLevel => getField(_debugLevel);
  void set debugLevel(DebugLevel value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _debugLevel = value;
  }

  String? _int16ByteOrder;
  String? get int16ByteOrder => getField(_int16ByteOrder);
  void set int16ByteOrder(String? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _int16ByteOrder = value;
  }

  String? _int32ByteOrder;
  String? get int32ByteOrder => getField(_int32ByteOrder);
  void set int32ByteOrder(String? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _int32ByteOrder = value;
  }

  String? _int64ByteOrder;
  String? get int64ByteOrder => getField(_int64ByteOrder);
  void set int64ByteOrder(String? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _int64ByteOrder = value;
  }

  String? _float32ByteOrder;
  String? get float32ByteOrder => getField(_float32ByteOrder);
  void set float32ByteOrder(String? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _float32ByteOrder = value;
  }

  String? _float64ByteOrder;
  String? get float64ByteOrder => getField(_float64ByteOrder);
  void set float64ByteOrder(String? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _float64ByteOrder = value;
  }

  int? _stringCountWordBytes;
  int? get stringCountWordBytes => getField(_stringCountWordBytes);
  void set stringCountWordBytes(int? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _stringCountWordBytes = value;
  }

  bool? _stringIsByteSwapped;
  bool? get stringIsByteSwapped => getField(_stringIsByteSwapped);
  void set stringIsByteSwapped(bool? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _stringIsByteSwapped = value;
  }

  bool? _stringIsCounted;
  bool? get stringIsCounted => getField(_stringIsCounted);
  void set stringIsCounted(bool? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _stringIsCounted = value;
  }

  bool? _stringIsFixedLength;
  bool? get stringIsFixedLength => getField(_stringIsFixedLength);
  void set stringIsFixedLength(bool? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _stringIsFixedLength = value;
  }

  bool? _stringIsZeroTerminated;
  bool? get stringIsZeroTerminated => getField(_stringIsZeroTerminated);
  void set stringIsZeroTerminated(bool? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _stringIsZeroTerminated = value;
  }

  int? _stringMaxCapacity;
  int? get stringMaxCapacity => getField(_stringMaxCapacity);
  void set stringMaxCapacity(int? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _stringMaxCapacity = value;
  }

  int? _stringPadBytes;
  int? get stringPadBytes => getField(_stringPadBytes);
  void set stringPadBytes(int? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _stringPadBytes = value;
  }

  int? _stringTotalLength;
  int? get stringTotalLength => getField(_stringTotalLength);
  void set stringTotalLength(int? value) {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();
    _stringTotalLength = value;
  }

  void dispose() {
    if (_isDisposed) return;

    if (_isInitialized) {
      var result = Status.fromInt(_native.plc_tag_destroy(nativeTagHandle));
      throwIfStatusNotOk(result);
    }

    _isDisposed = true;
  }

  void abort() {
    throwIfAlreadyDisposed();
    var result = Status.fromInt(_native.plc_tag_abort(nativeTagHandle));
    throwIfStatusNotOk(result);
  }

  void initialize() {
    throwIfAlreadyDisposed();
    throwIfAlreadyInitialized();

    var millisecondTimeout = timeout.inMilliseconds;

    var attributeString = getAttributeString();

    var result = _native.plc_tag_create(attributeString, millisecondTimeout);
    if (result < 0)
      throw new LibPlcTagException(Status.fromInt(result));
    else
      nativeTagHandle = result;

    _isInitialized = true;
  }

  void read() {
    throwIfAlreadyDisposed();
    initializeIfRequired();

    var millisecondTimeout = timeout.inMilliseconds;

    var result = Status.fromInt(_native.plc_tag_read(nativeTagHandle, millisecondTimeout));
    throwIfStatusNotOk(result);
  }

  void write() {
    throwIfAlreadyDisposed();
    initializeIfRequired();

    var millisecondTimeout = timeout.inMilliseconds;

    var result = Status.fromInt(_native.plc_tag_write(nativeTagHandle, millisecondTimeout));
    throwIfStatusNotOk(result);
  }

  int getSize() {
    throwIfAlreadyDisposed();

    var result = _native.plc_tag_get_size(nativeTagHandle);
    if (result < 0)
      throw new LibPlcTagException(Status.fromInt(result));
    else
      return result;
  }

  void setSize(int newSize) {
    throwIfAlreadyDisposed();
    var result = Status.fromInt(_native.plc_tag_set_size(nativeTagHandle, newSize));
    throwIfStatusNotOk(result);
  }

  Status getStatus() {
    throwIfAlreadyDisposed();
    return Status.fromInt(_native.plc_tag_status(nativeTagHandle));
  }

  Uint8List getBuffer() {
    throwIfAlreadyDisposed();

    var tagSize = getSize();
    var temp = new Uint8List(tagSize);

    var result = Status.fromInt(_native.plc_tag_get_raw_bytes(nativeTagHandle, 0, temp, tagSize));
    throwIfStatusNotOk(result);

    return temp;
  }

  int getIntAttribute(String attributeName) {
    throwIfAlreadyDisposed();

    var result = _native.plc_tag_get_int_attribute(nativeTagHandle, attributeName, -2147483648);
    if (result == -2147483648) throwIfStatusNotOk();

    return result;
  }

  void setIntAttribute(String attributeName, int value) {
    throwIfAlreadyDisposed();

    var result = Status.fromInt(_native.plc_tag_set_int_attribute(nativeTagHandle, attributeName, value));
    throwIfStatusNotOk(result);
  }

  bool getBit(int offset) {
    throwIfAlreadyDisposed();

    var result = _native.plc_tag_get_bit(nativeTagHandle, offset);
    if (result == 0)
      return false;
    else if (result == 1)
      return true;
    else
      throw new LibPlcTagException(Status.fromInt(result));
  }

  final intMaxValue = 2147483647;
  final intMinValue = -2147483648;

  void setBit(int offset, bool value) => setNativeTagValue<int>(_native.plc_tag_set_bit, offset, value == true ? 1 : 0);

  int getUInt64(int offset) => getNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_uint64, offset, intMaxValue);
  void setUInt64(int offset, int value) => setNativeTagValue<int>(_native.plc_tag_set_uint64, offset, value);

  int getInt64(int offset) => getNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_int64, offset, intMaxValue);
  void setInt64(int offset, int value) => setNativeTagValue(_native.plc_tag_set_int64, offset, value);

  int getUInt32(int offset) => getNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_uint32, offset, intMaxValue);
  void setUInt32(int offset, int value) => setNativeTagValue(_native.plc_tag_set_uint32, offset, value);

  int getInt32(int offset) => getNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_int32, offset, intMinValue);
  void setInt32(int offset, int value) => setNativeTagValue(_native.plc_tag_set_int32, offset, value);

  int getUInt16(int offset) => getNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_uint16, offset, intMaxValue);
  void setUInt16(int offset, int value) => setNativeTagValue(_native.plc_tag_set_uint16, offset, value);

  int getInt16(int offset) => getNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_int16, offset, intMinValue);
  void setInt16(int offset, int value) => setNativeTagValue(_native.plc_tag_set_int16, offset, value);

  int getUInt8(int offset) => getNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_uint8, offset, intMaxValue);
  void setUInt8(int offset, int value) => setNativeTagValue(_native.plc_tag_set_uint8, offset, value);

  int getInt8(int offset) => getNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_int8, offset, intMinValue);
  void setInt8(int offset, int value) => setNativeTagValue(_native.plc_tag_set_int8, offset, value);

  double getFloat64(int offset) =>
      getNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_float64, offset, double.minPositive);
  void setFloat64(int offset, double value) => setNativeTagValue(_native.plc_tag_set_float64, offset, value);

  double getFloat32(int offset) =>
      getNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_float32, offset, double.minPositive);
  void setFloat32(int offset, double value) => setNativeTagValue(_native.plc_tag_set_float32, offset, value);

  void setString(int offset, String value) => setNativeTagValue(_native.plc_tag_set_string, offset, value);
  int getStringLength(int offset) => getNativeValueAndThrowOnNegativeResult(_native.plc_tag_get_string_length, offset);
  int getStringCapacity(int offset) =>
      getNativeValueAndThrowOnNegativeResult(_native.plc_tag_get_string_capacity, offset);
  int getStringTotalLength(int offset) =>
      getNativeValueAndThrowOnNegativeResult(_native.plc_tag_get_string_total_length, offset);
  String getString(int offset) {
    throwIfAlreadyDisposed();
    var stringLength = getStringLength(offset);
    var sb = new StringBuffer();
    var status = Status.fromInt(_native.plc_tag_get_string(nativeTagHandle, offset, sb, stringLength));
    throwIfStatusNotOk(status);
    return sb.toString();
  }

  void throwIfAlreadyDisposed() {
    if (_isDisposed) throw new Exception(this.runtimeType);
  }

  void initializeIfRequired() {
    if (!_isInitialized) initialize();
  }

  // Future InitializeAsyncIfRequired()
  // {
  //     if (!_isInitialized)
  //         return InitializeAsync();
  //     else
  //         return Future.value();
  // }

  void throwIfAlreadyInitialized() {
    if (_isInitialized) throw new Exception("Already initialized");
  }

  void throwIfStatusNotOk([Status? status = null]) {
    var statusToCheck = status ?? getStatus();
    if (statusToCheck != Status.Ok) throw new LibPlcTagException(statusToCheck);
  }

  void setNativeTagValue<T>(int Function(int, int, T) nativeMethod, int offset, T value) {
    throwIfAlreadyDisposed();
    var result = Status.fromInt(nativeMethod(nativeTagHandle, offset, value));
    throwIfStatusNotOk(result);
  }

  int getNativeValueAndThrowOnNegativeResult(int Function(int, int) nativeMethod, int offset) {
    throwIfAlreadyDisposed();
    var result = nativeMethod(nativeTagHandle, offset);
    if (result < 0) throw new LibPlcTagException(Status.fromInt(result));
    return result;
  }

  T getNativeValueAndThrowOnSpecificResult<T>(
      Function(int, int) nativeMethod, int offset, T valueIndicatingPossibleError) {
    throwIfAlreadyDisposed();
    var result = nativeMethod(nativeTagHandle, offset);
    if (result == valueIndicatingPossibleError) throwIfStatusNotOk();
    return result;
  }

  T getField<T>(T field) {
    throwIfAlreadyDisposed();
    return field;
  }

  String getAttributeString() {
    String? formatNullableBoolean(bool? value) => value != null ? (value ? "1" : "0") : null;

    String? formatPlcType(PlcType? type) {
      if (type == null)
        return null;
      else if (type == PlcType.Omron)
        return "omron-njnx";
      else
        return type.toString().replaceAll("PlcType.", "").toLowerCase();
    }

    var attributes = {
      "protocol": protocol.toString(),
      "gateway": gateway,
      "path": path,
      "plc": formatPlcType(plcType),
      "elem_size": elementSize?.toString(),
      "elem_count": elementCount?.toString(),
      "name": name,
      "read_cache_ms": readCacheMillisecondDuration?.toString(),
      "use_connected_msg": formatNullableBoolean(useConnectedMessaging),
      "auto_sync_read_ms": autoSyncReadInterval?.inMilliseconds.toString(),
      "auto_sync_write_ms": autoSyncWriteInterval?.inMilliseconds.toString(),
      "debug": debugLevel == DebugLevel.None ? null : debugLevel.value.toString(),
      "int16_byte_order": int16ByteOrder,
      "int32_byte_order": int32ByteOrder,
      "int64_byte_order": int64ByteOrder,
      "float32_byte_order": float32ByteOrder,
      "float64_byte_order": float64ByteOrder,
      "str_count_word_bytes": stringCountWordBytes?.toString(),
      "str_is_byte_swapped": formatNullableBoolean(stringIsByteSwapped),
      "str_is_counted": formatNullableBoolean(stringIsCounted),
      "str_is_fixed_length": formatNullableBoolean(stringIsFixedLength),
      "str_is_zero_terminated": formatNullableBoolean(stringIsFixedLength),
      "str_max_capacity": stringMaxCapacity?.toString(),
      "str_pad_bytes": stringPadBytes?.toString(),
      "str_total_length": stringTotalLength?.toString(),
    };

    String separator = "&";
    var attributeStrings = <String>[];
    for (var key in attributes.keys) {
      var attr = attributes[key];
      if (attr != null) {
        attributeStrings.add("$key=$attr");
      }
    }
    return attributeStrings.join(separator);
  }
}
