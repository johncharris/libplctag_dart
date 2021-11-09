import 'dart:typed_data';

import 'package:libplctag_dart/debug_level.dart';
import 'package:libplctag_dart/inativeTag.dart';
import 'package:libplctag_dart/libplctag_exception.dart';
import 'package:libplctag_dart/native/plctag.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/status.dart';

class NativeTagWrapper {
  static const int TIMEOUT_VALUE_THAT_INDICATES_ASYNC_OPERATION = 0;
  static const int ASYNC_STATUS_POLL_INTERVAL = 2;
  static final Duration _defaultTimeout = Duration(seconds: 10);
  static final Duration _maxTimeout = Duration(milliseconds: 2147483647);

  late int nativeTagHandle;
  // libplctag.NativeImport.plctag.callback_func coreLibCallbackFuncDelegate;

  bool _isDisposed = false;
  bool _isInitialized = false;

  final INativeTag _native;

  NativeTagWrapper(this._native);

  String? _name;
  String? get name => GetField(_name);
  void set name(String? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _name = value;
  }

  String? _protocol;
  String? get protocol => GetField(_protocol);
  void set protocol(String? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _protocol = value;
  }

  String? _gateway;
  String? get gateway => GetField(_gateway);
  void set gateway(String? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _gateway = value;
  }

  PlcType? _plcType;
  PlcType? get plcType => GetField(_plcType);
  void set plcType(PlcType? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _plcType = value;
  }

  String? _path;
  String? get path => GetField(_path);
  void set path(String? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _path = value;
  }

  int? _elementSize;
  int? get elementSize => GetField(_elementSize);
  void set elementSize(int? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _elementSize = value;
  }

  int? _elementCount;
  int? get elementCount => GetField(_elementCount);
  void set elementCount(int? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _elementCount = value;
  }

  bool? _useConnectedMessaging;
  bool? get useConnectedMessaging => GetField(_useConnectedMessaging);
  void set useConnectedMessaging(bool? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _useConnectedMessaging = value;
  }

  int? _readCacheMillisecondDuration;
  int? get ReadCacheMillisecondDuration {
    ThrowIfAlreadyDisposed();

    if (!_isInitialized) return _readCacheMillisecondDuration;

    return GetIntAttribute("read_cache_ms");
  }

  void set ReadCacheMillisecondDuration(int? value) {
    ThrowIfAlreadyDisposed();

    if (!_isInitialized) {
      _readCacheMillisecondDuration = value;
      return;
    }

    if (value != null) SetIntAttribute("read_cache_ms", value);
  }

  Duration? _timeout;
  Duration get Timeout {
    ThrowIfAlreadyDisposed();
    return _timeout ?? _defaultTimeout;
  }

  void set Timeout(Duration value) {
    ThrowIfAlreadyDisposed();
    if (value <= Duration.zero || value > _maxTimeout) throw new Exception("Timeout Must be greater than 0");
    _timeout = value;
  }

  Duration? _autoSyncReadInterval;
  Duration? get autoSyncReadInterval => GetField(_autoSyncReadInterval);
  void set autoSyncReadInterval(Duration? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _autoSyncReadInterval = value;
  }

  Duration? _autoSyncWriteInterval;
  Duration? get autoSyncWriteInterval => GetField(_autoSyncWriteInterval);
  void set autoSyncWriteInterval(Duration? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _autoSyncWriteInterval = value;
  }

  DebugLevel _debugLevel = DebugLevel.None;
  DebugLevel get debugLevel => GetField(_debugLevel);
  void set debugLevel(DebugLevel value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _debugLevel = value;
  }

  String? _int16ByteOrder;
  String? get int16ByteOrder => GetField(_int16ByteOrder);
  void set int16ByteOrder(String? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _int16ByteOrder = value;
  }

  String? _int32ByteOrder;
  String? get int32ByteOrder => GetField(_int32ByteOrder);
  void set int32ByteOrder(String? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _int32ByteOrder = value;
  }

  String? _int64ByteOrder;
  String? get int64ByteOrder => GetField(_int64ByteOrder);
  void set int64ByteOrder(String? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _int64ByteOrder = value;
  }

  String? _float32ByteOrder;
  String? get float32ByteOrder => GetField(_float32ByteOrder);
  void set float32ByteOrder(String? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _float32ByteOrder = value;
  }

  String? _float64ByteOrder;
  String? get float64ByteOrder => GetField(_float64ByteOrder);
  void set float64ByteOrder(String? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _float64ByteOrder = value;
  }

  int? _stringCountWordBytes;
  int? get stringCountWordBytes => GetField(_stringCountWordBytes);
  void set stringCountWordBytes(int? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _stringCountWordBytes = value;
  }

  bool? _stringIsByteSwapped;
  bool? get stringIsByteSwapped => GetField(_stringIsByteSwapped);
  void set stringIsByteSwapped(bool? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _stringIsByteSwapped = value;
  }

  bool? _stringIsCounted;
  bool? get stringIsCounted => GetField(_stringIsCounted);
  void set stringIsCounted(bool? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _stringIsCounted = value;
  }

  bool? _stringIsFixedLength;
  bool? get stringIsFixedLength => GetField(_stringIsFixedLength);
  void set stringIsFixedLength(bool? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _stringIsFixedLength = value;
  }

  bool? _stringIsZeroTerminated;
  bool? get stringIsZeroTerminated => GetField(_stringIsZeroTerminated);
  void set stringIsZeroTerminated(bool? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _stringIsZeroTerminated = value;
  }

  int? _stringMaxCapacity;
  int? get stringMaxCapacity => GetField(_stringMaxCapacity);
  void set stringMaxCapacity(int? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _stringMaxCapacity = value;
  }

  int? _stringPadBytes;
  int? get stringPadBytes => GetField(_stringPadBytes);
  void set stringPadBytes(int? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _stringPadBytes = value;
  }

  int? _stringTotalLength;
  int? get stringTotalLength => GetField(_stringTotalLength);
  void set stringTotalLength(int? value) {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();
    _stringTotalLength = value;
  }

  void Dispose() {
    if (_isDisposed) return;

    if (_isInitialized) {
      RemoveEvents();
      var result = Status.fromInt(_native.plc_tag_destroy(nativeTagHandle));
      ThrowIfStatusNotOk(result);
    }

    _isDisposed = true;
  }

  void Abort() {
    ThrowIfAlreadyDisposed();
    var result = Status.fromInt(_native.plc_tag_abort(nativeTagHandle));
    ThrowIfStatusNotOk(result);
  }

  void Initialize() {
    ThrowIfAlreadyDisposed();
    ThrowIfAlreadyInitialized();

    var millisecondTimeout = Timeout.inMilliseconds;

    var attributeString = GetAttributeString();

    var result = _native.plc_tag_create(attributeString, millisecondTimeout);
    if (result < 0)
      throw new LibPlcTagException(Status.fromInt(result));
    else
      nativeTagHandle = result;

    SetUpEvents();

    _isInitialized = true;
  }

  // Future InitializeAsync() async
  // {

  //     ThrowIfAlreadyDisposed();
  //     ThrowIfAlreadyInitialized();

  //     using (var cts = CancellationTokenSource.CreateLinkedTokenSource(token))
  //     {
  //         cts.CancelAfter(Timeout);

  //         using (cts.Token.Register(() =>
  //         {
  //             Abort();
  //             RemoveEvents();

  //             if (readTasks.TryPop(out var readTask))
  //             {
  //                 if (token.IsCancellationRequested)
  //                     readTask.SetCanceled();
  //                 else
  //                     readTask.SetException(new LibPlcTagException(Status.ErrorTimeout));
  //             }
  //         }))
  //         {
  //             var readTask = new TaskCompletionSource<object>(TaskCreationOptions.RunContinuationsAsynchronously);
  //             readTasks.Push(readTask);

  //             var attributeString = GetAttributeString();
  //             var result = _native.plc_tag_create(attributeString, TIMEOUT_VALUE_THAT_INDICATES_ASYNC_OPERATION);
  //             if (result < 0)
  //                 throw new LibPlcTagException((Status)result);
  //             else
  //                 nativeTagHandle = result;

  //             SetUpEvents();

  //             await readTask.Task;

  //             _isInitialized = true;
  //         }
  //     }
  // }

  void Read() {
    ThrowIfAlreadyDisposed();
    InitializeIfRequired();

    var millisecondTimeout = Timeout.inMilliseconds;

    var result = Status.fromInt(_native.plc_tag_read(nativeTagHandle, millisecondTimeout));
    ThrowIfStatusNotOk(result);
  }

  // Future ReadAsync() async
  // {
  //     ThrowIfAlreadyDisposed();

  //     using (var cts = CancellationTokenSource.CreateLinkedTokenSource(token))
  //     {
  //         cts.CancelAfter(Timeout);

  //         await InitializeAsyncIfRequired(cts.Token);

  //         using (cts.Token.Register(() =>
  //         {
  //             Abort();

  //             if (readTasks.TryPop(out var readTask))
  //             {
  //                 if (token.IsCancellationRequested)
  //                     readTask.SetCanceled();
  //                 else
  //                     readTask.SetException(new LibPlcTagException(Status.ErrorTimeout));
  //             }
  //         }))
  //         {
  //             var readTask = new TaskCompletionSource<object>(TaskCreationOptions.RunContinuationsAsynchronously);
  //             readTasks.Push(readTask);
  //             _native.plc_tag_read(nativeTagHandle, TIMEOUT_VALUE_THAT_INDICATES_ASYNC_OPERATION);
  //             await readTask.Task;
  //         }
  //     }
  // }

  void Write() {
    ThrowIfAlreadyDisposed();
    InitializeIfRequired();

    var millisecondTimeout = Timeout.inMilliseconds;

    var result = Status.fromInt(_native.plc_tag_write(nativeTagHandle, millisecondTimeout));
    ThrowIfStatusNotOk(result);
  }

  // Future WriteAsync() async
  // {
  //     ThrowIfAlreadyDisposed();

  //     using (var cts = CancellationTokenSource.CreateLinkedTokenSource(token))
  //     {
  //         cts.CancelAfter(Timeout);

  //         await InitializeAsyncIfRequired(cts.Token);

  //         using (cts.Token.Register(() =>
  //         {
  //             Abort();

  //             if (writeTasks.TryPop(out var writeTask))
  //             {
  //                 if (token.IsCancellationRequested)
  //                     writeTask.SetCanceled();
  //                 else
  //                     writeTask.SetException(new LibPlcTagException(Status.ErrorTimeout));
  //             }
  //         }))
  //         {
  //             var writeTask = new TaskCompletionSource<object>(TaskCreationOptions.RunContinuationsAsynchronously);
  //             writeTasks.Push(writeTask);
  //             _native.plc_tag_write(nativeTagHandle, TIMEOUT_VALUE_THAT_INDICATES_ASYNC_OPERATION);
  //             await writeTask.Task;
  //         }
  //     }
  // }

  int GetSize() {
    ThrowIfAlreadyDisposed();

    var result = _native.plc_tag_get_size(nativeTagHandle);
    if (result < 0)
      throw new LibPlcTagException(Status.fromInt(result));
    else
      return result;
  }

  void SetSize(int newSize) {
    ThrowIfAlreadyDisposed();
    var result = Status.fromInt(_native.plc_tag_set_size(nativeTagHandle, newSize));
    ThrowIfStatusNotOk(result);
  }

  Status GetStatus() {
    ThrowIfAlreadyDisposed();
    return Status.fromInt(_native.plc_tag_status(nativeTagHandle));
  }

  // Uint8List GetBuffer()
  // {
  //     ThrowIfAlreadyDisposed();

  //     var tagSize = GetSize();
  //     var temp = new byte[tagSize];

  //     var result = Status.fromInt(_native.plc_tag_get_raw_bytes(nativeTagHandle, 0, temp, temp.Length));
  //     ThrowIfStatusNotOk(result);

  //     return temp;
  // }

  int GetIntAttribute(String attributeName) {
    ThrowIfAlreadyDisposed();

    var result = _native.plc_tag_get_int_attribute(nativeTagHandle, attributeName, -2147483648);
    if (result == -2147483648) ThrowIfStatusNotOk();

    return result;
  }

  void SetIntAttribute(String attributeName, int value) {
    ThrowIfAlreadyDisposed();

    var result = Status.fromInt(_native.plc_tag_set_int_attribute(nativeTagHandle, attributeName, value));
    ThrowIfStatusNotOk(result);
  }

  bool GetBit(int offset) {
    ThrowIfAlreadyDisposed();

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

  void SetBit(int offset, bool value) => SetNativeTagValue<int>(_native.plc_tag_set_bit, offset, value == true ? 1 : 0);

  int GetUInt64(int offset) => GetNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_uint64, offset, intMaxValue);
  void SetUInt64(int offset, int value) => SetNativeTagValue<int>(_native.plc_tag_set_uint64, offset, value);

  int GetInt64(int offset) => GetNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_int64, offset, intMaxValue);
  void SetInt64(int offset, int value) => SetNativeTagValue(_native.plc_tag_set_int64, offset, value);

  int GetUInt32(int offset) => GetNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_uint32, offset, intMaxValue);
  void SetUInt32(int offset, int value) => SetNativeTagValue(_native.plc_tag_set_uint32, offset, value);

  int GetInt32(int offset) => GetNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_int32, offset, intMinValue);
  void SetInt32(int offset, int value) => SetNativeTagValue(_native.plc_tag_set_int32, offset, value);

  int GetUInt16(int offset) => GetNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_uint16, offset, intMaxValue);
  void SetUInt16(int offset, int value) => SetNativeTagValue(_native.plc_tag_set_uint16, offset, value);

  int GetInt16(int offset) => GetNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_int16, offset, intMinValue);
  void SetInt16(int offset, int value) => SetNativeTagValue(_native.plc_tag_set_int16, offset, value);

  int GetUInt8(int offset) => GetNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_uint8, offset, intMaxValue);
  void SetUInt8(int offset, int value) => SetNativeTagValue(_native.plc_tag_set_uint8, offset, value);

  int GetInt8(int offset) => GetNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_int8, offset, intMinValue);
  void SetInt8(int offset, int value) => SetNativeTagValue(_native.plc_tag_set_int8, offset, value);

  double GetFloat64(int offset) =>
      GetNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_float64, offset, double.minPositive);
  void SetFloat64(int offset, double value) => SetNativeTagValue(_native.plc_tag_set_float64, offset, value);

  double GetFloat32(int offset) =>
      GetNativeValueAndThrowOnSpecificResult(_native.plc_tag_get_float32, offset, double.minPositive);
  void SetFloat32(int offset, double value) => SetNativeTagValue(_native.plc_tag_set_float32, offset, value);

//TODO Reenable this
  // void SetString(int offset, String value)     => SetNativeTagValue(_native.plc_tag_set_string, offset, value);
  // int GetStringLength(int offset)              => GetNativeValueAndThrowOnNegativeResult(_native.plc_tag_get_string_length, offset);
  // int GetStringCapacity(int offset)            => GetNativeValueAndThrowOnNegativeResult(_native.plc_tag_get_string_capacity, offset);
  // int GetStringTotalLength(int offset)         => GetNativeValueAndThrowOnNegativeResult(_native.plc_tag_get_string_total_length, offset);
  // string GetString(int offset)
  // {
  //     ThrowIfAlreadyDisposed();
  //     var stringLength = GetStringLength(offset);
  //     var sb = new StringBuilder(stringLength);
  //     var status = (Status)_native.plc_tag_get_string(nativeTagHandle, offset, sb, stringLength);
  //     ThrowIfStatusNotOk(status);
  //     return sb.ToString().Substring(0, stringLength);
  // }

  void ThrowIfAlreadyDisposed() {
    if (_isDisposed) throw new Exception(this.runtimeType);
  }

  void InitializeIfRequired() {
    if (!_isInitialized) Initialize();
  }

  // Future InitializeAsyncIfRequired()
  // {
  //     if (!_isInitialized)
  //         return InitializeAsync();
  //     else
  //         return Future.value();
  // }

  void ThrowIfAlreadyInitialized() {
    if (_isInitialized) throw new Exception("Already initialized");
  }

  void ThrowIfStatusNotOk([Status? status = null]) {
    var statusToCheck = status ?? GetStatus();
    if (statusToCheck != Status.Ok) throw new LibPlcTagException(statusToCheck);
  }

  void SetNativeTagValue<T>(int Function(int, int, T) nativeMethod, int offset, T value) {
    ThrowIfAlreadyDisposed();
    var result = Status.fromInt(nativeMethod(nativeTagHandle, offset, value));
    ThrowIfStatusNotOk(result);
  }

  int GetNativeValueAndThrowOnNegativeResult(Function<int>(int, int) nativeMethod, int offset) {
    ThrowIfAlreadyDisposed();
    var result = nativeMethod(nativeTagHandle, offset);
    if (result < 0) throw new LibPlcTagException(Status.fromInt(result));
    return result;
  }

  T GetNativeValueAndThrowOnSpecificResult<T>(
      Function(int, int) nativeMethod, int offset, T valueIndicatingPossibleError) {
    ThrowIfAlreadyDisposed();
    var result = nativeMethod(nativeTagHandle, offset);
    if (result.Equals(valueIndicatingPossibleError)) ThrowIfStatusNotOk();
    return result;
  }

  T GetField<T>(T field) {
    ThrowIfAlreadyDisposed();
    return field;
  }

  String GetAttributeString() {
    String? FormatNullableBoolean(bool? value) => value != null ? (value ? "1" : "0") : null;

    String? FormatPlcType(PlcType? type) {
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
      "plc": FormatPlcType(plcType),
      "elem_size": elementSize?.toString(),
      "elem_count": elementCount?.toString(),
      "name": name,
      "read_cache_ms": ReadCacheMillisecondDuration?.toString(),
      "use_connected_msg": FormatNullableBoolean(useConnectedMessaging),
      "auto_sync_read_ms": autoSyncReadInterval?.inMilliseconds.toString(),
      "auto_sync_write_ms": autoSyncWriteInterval?.inMilliseconds.toString(),
      "debug": debugLevel == DebugLevel.None ? null : debugLevel.value.toString(),
      "int16_byte_order": int16ByteOrder,
      "int32_byte_order": int32ByteOrder,
      "int64_byte_order": int64ByteOrder,
      "float32_byte_order": float32ByteOrder,
      "float64_byte_order": float64ByteOrder,
      "str_count_word_bytes": stringCountWordBytes?.toString(),
      "str_is_byte_swapped": FormatNullableBoolean(stringIsByteSwapped),
      "str_is_counted": FormatNullableBoolean(stringIsCounted),
      "str_is_fixed_length": FormatNullableBoolean(stringIsFixedLength),
      "str_is_zero_terminated": FormatNullableBoolean(stringIsFixedLength),
      "str_max_capacity": stringMaxCapacity?.toString(),
      "str_pad_bytes": stringPadBytes?.toString(),
      "str_total_length": stringTotalLength?.toString(),
    };

    String separator = "&";
    var attributeStrings = <String>[];
    for (var key in attributes.keys) {
      var attr = attributes[key];
      if (attr != null) {
        attributeStrings.add("{attr.Key}={attr.Value}");
      }
    }
    return attributeStrings.join(separator);
  }

  void SetUpEvents() {
    // // Used to finalize the asynchronous read/write task completion sources
    // ReadCompleted += ReadTaskCompleter;
    // WriteCompleted += WriteTaskCompleter;

    // // Need to keep a reference to the delegate in memory so it doesn't get garbage collected
    // coreLibCallbackFuncDelegate = new libplctag.NativeImport.plctag.callback_func(coreLibEventCallback);

    // var callbackRegistrationResult = (Status)_native.plc_tag_register_callback(nativeTagHandle, coreLibCallbackFuncDelegate);
    // ThrowIfStatusNotOk(callbackRegistrationResult);
  }

  void RemoveEvents() {
    // // Used to finalize the  read/write task completion sources
    // ReadCompleted -= ReadTaskCompleter;
    // WriteCompleted -= WriteTaskCompleter;

    // var callbackRemovalResult = (Status)_native.plc_tag_unregister_callback(nativeTagHandle);
    // ThrowIfStatusNotOk(callbackRemovalResult);
  }

  // readonly ConcurrentStack<TaskCompletionSource<object>> readTasks = new ConcurrentStack<TaskCompletionSource<object>>();
  // void ReadTaskCompleter(object sender, TagEventArgs e)
  // {
  //     if (readTasks.TryPop(out var readTask))
  //     {
  //         switch (e.Status)
  //         {
  //             case Status.Ok:
  //                 readTask?.SetResult(null);
  //                 break;
  //             case Status.Pending:
  //                 // Do nothing, wait for another ReadCompleted callback when Status is Ok.
  //                 break;
  //             default:
  //                 readTask?.SetException(new LibPlcTagException(e.Status));
  //                 break;
  //         }
  //     }
  // }

  // readonly ConcurrentStack<TaskCompletionSource<object>> writeTasks = new ConcurrentStack<TaskCompletionSource<object>>();
  // void WriteTaskCompleter(object sender, TagEventArgs e)
  // {
  //     if (writeTasks.TryPop(out var writeTask))
  //     {
  //         switch (e.Status)
  //         {
  //             case Status.Ok:
  //                 writeTask?.SetResult(null);
  //                 break;
  //             case Status.Pending:
  //                 // Do nothing, wait for another WriteCompleted callback when Status is Ok.
  //                 break;
  //             default:
  //                 writeTask?.SetException(new LibPlcTagException(e.Status));
  //                 break;

  //         }
  //     }
  // }

  // event EventHandler<TagEventArgs> ReadStarted;
  // event EventHandler<TagEventArgs> ReadCompleted;
  // event EventHandler<TagEventArgs> WriteStarted;
  // event EventHandler<TagEventArgs> WriteCompleted;
  // event EventHandler<TagEventArgs> Aborted;
  // event EventHandler<TagEventArgs> Destroyed;

  // void coreLibEventCallback(int eventTagHandle, int eventCode, int statusCode)
  // {

  //     var @event = (Event)eventCode;
  //     var status = (Status)statusCode;
  //     var eventArgs = new TagEventArgs() { Status = status };

  //     switch (@event)
  //     {
  //         case Event.ReadCompleted:
  //             ReadCompleted?.Invoke(this, eventArgs);
  //             break;
  //         case Event.ReadStarted:
  //             ReadStarted?.Invoke(this, eventArgs);
  //             break;
  //         case Event.WriteStarted:
  //             WriteStarted?.Invoke(this, eventArgs);
  //             break;
  //         case Event.WriteCompleted:
  //             WriteCompleted?.Invoke(this, eventArgs);
  //             break;
  //         case Event.Aborted:
  //             Aborted?.Invoke(this, eventArgs);
  //             break;
  //         case Event.Destroyed:
  //             Destroyed?.Invoke(this, eventArgs);
  //             break;
  //         default:
  //             throw new NotImplementedException();
  //     }
  // }

}
