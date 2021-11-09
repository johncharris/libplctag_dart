import 'package:libplctag_dart/debug_level.dart';
import 'package:libplctag_dart/libplctag_dart.dart';
import 'package:libplctag_dart/native_tag.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/status.dart';

class Tag {
  final NativeTagWrapper _tag = new NativeTagWrapper(new NativeTag());

  // /// <summary>
  // /// True if <see cref="Initialize"/> or <see cref="InitializeAsync"/> has been called.
  // /// </summary>
  // bool get IsInitialized => _tag.IsInitialized;

  /// <summary>
  /// Optional An integer number of elements per tag .
  /// </summary>
  ///
  /// <remarks>
  /// All tags are treated as arrays.
  /// Tags that are not arrays are considered to have a length of one element.
  /// This attribute determines how many elements are in the tag.
  /// Defaults to one (1) if not found.
  /// </remarks>
  int? get ElementCount => _tag.elementCount;
  void set ElementCount(int? value) => _tag.elementCount = value;

  /// <summary>
  /// Optional An integer number of bytes per element
  /// </summary>
  ///
  /// <remarks>
  /// This attribute determines the size of a single element of the tag.
  /// Ignored for Modbus and for Allen-Bradley PLCs.
  /// </remarks>
  int? get ElementSize => _tag.elementSize;
  void set ElementSize(int? value) => _tag.elementSize = value;

  /// <summary>
  /// This tells the library what host name or IP address to use for the PLC
  /// or the gateway to the PLC (in the case that the PLC is remote).
  /// </summary>
  String? get Gateway => _tag.gateway;
  set Gateway(String? value) => _tag.gateway = value;

  /// <summary>
  /// This is the full name of the tag.
  /// For program tags, prepend `Program:{ProgramName}.`
  /// where {ProgramName} is the name of the program in which the tag is created.
  /// </summary>
  String? get Name => _tag.name;
  set Name(String? value) => _tag.name = value;

  /// <summary>
  /// This attribute is required for CompactLogix/ControlLogix tags
  /// and for tags using a DH+ protocol bridge (i.e. a DHRIO module) to get to a PLC/5, SLC 500, or MicroLogix PLC on a remote DH+ link.
  /// The attribute is ignored if it is not a DH+ bridge route, but will generate a warning if debugging is active.
  /// Note that Micro800 connections must not have a path attribute.
  /// </summary>
  String? get Path => _tag.path;
  set Path(String? value) => _tag.path = value;

  /// <summary>
  /// The type of PLC
  /// </summary>
  PlcType? get plcType => _tag.plcType;
  set plcType(value) => _tag.plcType = value;

  /// <summary>
  /// Determines the type of the PLC Protocol.
  /// </summary>
  String? get protocol => _tag.protocol;
  set protocol(value) => _tag.protocol = value;

  /// <summary>
  /// Optional. Use this attribute to cause the tag read operations to cache data the requested number of milliseconds.
  /// This can be used to lower the actual number of requests against the PLC.
  /// Example read_cache_ms=100 will result in read operations no more often than once every 100 milliseconds.
  /// </summary>
  int? get ReadCacheMillisecondDuration => _tag.ReadCacheMillisecondDuration;
  set ReadCacheMillisecondDuration(value) => _tag.ReadCacheMillisecondDuration = value;

  /// <summary>
  /// A timeout value that is used for Initialize/Read/Write methods.
  /// It applies to both synchronous and asynchronous calls.
  /// </summary>
  Duration? get Timeout => _tag.Timeout;
  set Timeout(value) => _tag.Timeout = value;

  /// <summary>
  /// Optional. Control whether to use connected or unconnected messaging.
  /// Only valid on Logix-class PLCs. Connected messaging is required on Micro800 and DH+ bridged links.
  /// Default is PLC-specific and link-type specific. Generally you do not need to set this.
  /// </summary>
  bool? get UseConnectedMessaging => _tag.useConnectedMessaging;
  set UseConnectedMessaging(value) => _tag.useConnectedMessaging = value;

  /// <summary>
  /// Optional. An integer number of milliseconds to periodically read data from the PLC.
  /// </summary>
  ///
  /// <remarks>
  /// Use this attribute to automatically read data from the PLC on a set interval.
  /// This can be used in conjunction with the <see cref="ReadStarted"/> and <see cref="ReadCompleted"/> events to respond to the data updates.
  /// </remarks>
  Duration? get AutoSyncReadInterval => _tag.autoSyncReadInterval;
  set AutoSyncReadInterval(value) => _tag.autoSyncReadInterval = value;

  /// <summary>
  /// Optional. An integer number of milliseconds to buffer tag data changes before writing to the PLC.
  /// </summary>
  ///
  /// <remarks>
  /// Use this attribute to automatically write data to the PLC a set duration after setting its value.
  /// This can be used to lower the actual number of write operations by locally buffering local writes, and only writing to the PLC the most recent one when the wait completes.
  /// You can determine when a write starts and completes by catching the <see cref="WriteStarted"/> and <see cref="WriteCompleted"/> events.
  /// </remarks>
  Duration? get AutoSyncWriteInterval => _tag.autoSyncWriteInterval;
  set AutoSyncWriteInterval(value) => _tag.autoSyncWriteInterval = value;

  DebugLevel get debugLevel => _tag.debugLevel;
  set debugLevel(value) => _tag.debugLevel = value;

  /// <summary>
  /// Configures. the byte order of 16-bit integers.
  /// </summary>
  String? get int16ByteOrder => _tag.int16ByteOrder;
  set int16ByteOrder(value) => _tag.int16ByteOrder = value;

  /// <summary>
  /// Optional. Configures the byte order of 32-bit integers.
  /// </summary>
  String? get int32ByteOrder => _tag.int32ByteOrder;
  set int32ByteOrder(value) => _tag.int32ByteOrder = value;

  /// <summary>
  /// Optional. Configures the byte order of 64-bit integers.
  /// </summary>
  String? get Int64ByteOrder => _tag.int64ByteOrder;
  set Int64ByteOrder(value) => _tag.int64ByteOrder = value;

  /// <summary>
  /// Optional. Configures the byte order of 32-bit floating point values.
  /// </summary>
  String? get Float32ByteOrder => _tag.float32ByteOrder;
  set Float32ByteOrder(value) => _tag.float32ByteOrder = value;

  /// <summary>
  /// Optional. Configures the byte order of 64-bit floating point values.
  /// </summary>
  String? get Float64ByteOrder => _tag.float64ByteOrder;
  set Float64ByteOrder(value) => _tag.float64ByteOrder = value;

  /// <summary>
  /// Optional. A positive integer value of 1, 2, 4, or 8 determining how big the leading count word is in a string.
  /// </summary>
  int? get stringCountWordBytes => _tag.stringCountWordBytes;
  set stringCountWordBytes(value) => _tag.stringCountWordBytes = value;

  /// <summary>
  /// Optional. Determines whether character bytes are swapped within 16-bit words.
  /// </summary>
  bool? get StringIsByteSwapped => _tag.stringIsByteSwapped;
  set StringIsByteSwapped(value) => _tag.stringIsByteSwapped = value;

  /// <summary>
  /// Optional. Determines whether strings have a count word or not.
  /// </summary>
  bool? get StringIsCounted => _tag.stringIsCounted;
  set StringIsCounted(value) => _tag.stringIsCounted = value;

  /// <summary>
  /// Optional. Determines whether strings have a fixed length that they occupy.
  /// </summary>
  bool? get StringIsFixedLength => _tag.stringIsFixedLength;
  set StringIsFixedLength(value) => _tag.stringIsFixedLength = value;

  /// <summary>
  /// Optional. Determines whether strings are zero-terminated as is done in C.
  /// </summary>
  bool? get StringIsZeroTerminated => _tag.stringIsZeroTerminated;
  set StringIsZeroTerminated(value) => _tag.stringIsZeroTerminated = value;

  /// <summary>
  /// Optional. Determines the maximum number of character bytes in a string.
  /// </summary>
  int? get StringMaxCapacity => _tag.stringMaxCapacity;
  set StringMaxCapacity(value) => _tag.stringMaxCapacity = value;

  /// <summary>
  /// Optional. A positive integer value determining the total number of padding bytes at the end of a string.
  /// </summary>
  int? get StringPadBytes => _tag.stringPadBytes;
  set StringPadBytes(value) => _tag.stringPadBytes = value;

  /// <summary>
  /// Optional. A positive integer value determining the total number of bytes used in the tag buffer by a string. Must be used with str_is_fixed_length.
  /// </summary>
  int? get StringTotalLength => _tag.stringTotalLength;
  set StringTotalLength(value) => _tag.stringTotalLength = value;

  /// <summary>
  /// Creates the underlying data structures and references required before tag operations.
  /// </summary>
  ///
  /// <remarks>
  /// Initializes the tag by establishing necessary connections.
  /// Can only be called once per instance.
  /// Timeout is controlled via class property.
  /// </remarks>
  void Initialize() => _tag.Initialize();

  // /// <summary>
  // /// Creates the underlying data structures and references required before tag operations.
  // /// </summary>
  // ///
  // /// <remarks>
  // /// Initializes the tag by establishing necessary connections.
  // /// Can only be called once per instance.
  // /// Timeout is controlled via class property.
  // /// </remarks>
  // Future InitializeAsync(CancellationToken token = default) => _tag.InitializeAsync(token);

  /// <summary>
  /// Executes a synchronous read on a tag.
  /// Timeout is controlled via class property.
  /// </summary>
  ///
  /// <remarks>
  /// Reading a tag brings the data at the time of read into the local memory of the PC running the library.
  /// The data is not automatically kept up to date.
  /// If you need to find out the data periodically, you need to read the tag periodically.
  /// </remarks>
  void Read() => _tag.Read();

  // /// <summary>
  // /// Executes an asynchronous read on a tag.
  // /// Timeout is controlled via class property.
  // /// </summary>
  // ///
  // /// <remarks>
  // /// Reading a tag brings the data at the time of read into the local memory of the PC running the library.
  // /// The data is not automatically kept up to date.
  // /// If you need to find out the data periodically, you need to read the tag periodically.
  // /// </remarks>
  // Task ReadAsync(CancellationToken token = default) => _tag.ReadAsync(token);

  /// <summary>
  /// Executes a synchronous write on a tag.
  /// Timeout is controlled via class property.
  /// </summary>
  ///
  /// <remarks>
  /// Writing a tag sends the data from local memory to the target PLC.
  /// </remarks>
  void Write() => _tag.Write();

  // /// <summary>
  // /// Executes an asynchronous write on a tag.
  // /// Timeout is controlled via class property.
  // /// </summary>
  // ///
  // /// <remarks>
  // /// Writing a tag sends the data from local memory to the target PLC.
  // /// </remarks>
  // Task WriteAsync(CancellationToken token = default) => _tag.WriteAsync(token);

  void Abort() => _tag.Abort();
  void Dispose() => _tag.Dispose();

  // /// <summary>
  // /// This function retrieves a segment of raw, unprocessed bytes from the tag buffer.
  // /// </summary>
  // byte[] GetBuffer()                           => _tag.GetBuffer();
  int GetSize() => _tag.GetSize();
  void SetSize(int newSize) => _tag.SetSize(newSize);

  /// <summary>
  /// Check the operational status of the tag
  /// </summary>
  /// <returns>Tag's current status</returns>
  Status GetStatus() => _tag.GetStatus();

  bool GetBit(int offset) => _tag.GetBit(offset);
  void SetBit(int offset, bool value) => _tag.SetBit(offset, value);

  double GetFloat32(int offset) => _tag.GetFloat32(offset);
  void SetFloat32(int offset, double value) => _tag.SetFloat32(offset, value);

  double GetFloat64(int offset) => _tag.GetFloat64(offset);
  void SetFloat64(int offset, double value) => _tag.SetFloat64(offset, value);

  int GetInt8(int offset) => _tag.GetInt8(offset);
  void SetInt8(int offset, int value) => _tag.SetInt8(offset, value);

  int GetInt16(int offset) => _tag.GetInt16(offset);
  void SetInt16(int offset, int value) => _tag.SetInt16(offset, value);

  int GetInt32(int offset) => _tag.GetInt32(offset);
  void SetInt32(int offset, int value) => _tag.SetInt32(offset, value);

  int GetInt64(int offset) => _tag.GetInt64(offset);
  void SetInt64(int offset, int value) => _tag.SetInt64(offset, value);

  int GetUInt8(int offset) => _tag.GetUInt8(offset);
  void SetUInt8(int offset, int value) => _tag.SetUInt8(offset, value);

  int GetUInt16(int offset) => _tag.GetUInt16(offset);
  void SetUInt16(int offset, int value) => _tag.SetUInt16(offset, value);

  int GetUInt32(int offset) => _tag.GetUInt32(offset);
  void SetUInt32(int offset, int value) => _tag.SetUInt32(offset, value);

  int GetUInt64(int offset) => _tag.GetUInt64(offset);
  void SetUInt64(int offset, int value) => _tag.SetUInt64(offset, value);

  // void SetString(int offset, String value)     => _tag.SetString(offset, value);
  // int GetStringLength(int offset)              => _tag.GetStringLength(offset);
  // int GetStringTotalLength(int offset)         => _tag.GetStringTotalLength(offset);
  // int GetStringCapacity(int offset)            => _tag.GetStringCapacity(offset);
  // string GetString(int offset)                 => _tag.GetString(offset);

  // event EventHandler<TagEventArgs> ReadStarted
  // {
  //     add => _tag.ReadStarted += value;
  //     remove => _tag.ReadStarted -= value;
  // }
  // event EventHandler<TagEventArgs> ReadCompleted
  // {
  //     add => _tag.ReadCompleted += value;
  //     remove => _tag.ReadCompleted -= value;
  // }
  // event EventHandler<TagEventArgs> WriteStarted
  // {
  //     add => _tag.WriteStarted += value;
  //     remove => _tag.WriteStarted -= value;
  // }
  // event EventHandler<TagEventArgs> WriteCompleted
  // {
  //     add => _tag.WriteCompleted += value;
  //     remove => _tag.WriteCompleted -= value;
  // }
  // event EventHandler<TagEventArgs> Aborted
  // {
  //     add => _tag.Aborted += value;
  //     remove => _tag.Aborted -= value;
  // }
  // event EventHandler<TagEventArgs> Destroyed
  // {
  //     add => _tag.Destroyed += value;
  //     remove => _tag.Destroyed -= value;
  // }

  // ~Tag()
  // {
  //     Dispose();
  // }

}
