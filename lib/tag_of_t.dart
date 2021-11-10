import 'package:libplctag_dart/data_types/iplc_mapper.dart';
import 'package:libplctag_dart/debug_level.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/status.dart';
import 'tag.dart' as nt;

/// <summary>
/// A class that allows for strongly-typed objects tied to PLC tags
/// </summary>
/// <typeparam name="M">A <see cref="IPlcMapper{T}"/> class that handles data conversion</typeparam>
/// <typeparam name="T">The desired C# type of Tag.Value</typeparam>
class Tag<T> {
  late final nt.Tag _tag;
  late final IPlcMapper<T> _plcMapper;

  Tag(this._plcMapper) {
    _tag = new nt.Tag()..ElementSize = _plcMapper.elementSize;
  }

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
  int? get ElementCount => _tag.ElementCount;
  void set ElementCount(int? value) => _tag.ElementCount = value;

  /// <summary>
  /// Optional An integer number of bytes per element
  /// </summary>
  ///
  /// <remarks>
  /// This attribute determines the size of a single element of the tag.
  /// Ignored for Modbus and for Allen-Bradley PLCs.
  /// </remarks>
  int? get ElementSize => _tag.ElementSize;
  void set ElementSize(int? value) => _tag.ElementSize = value;

  /// <summary>
  /// This tells the library what host name or IP address to use for the PLC
  /// or the gateway to the PLC (in the case that the PLC is remote).
  /// </summary>
  String? get Gateway => _tag.Gateway;
  set Gateway(String? value) => _tag.Gateway = value;

  /// <summary>
  /// This is the full name of the tag.
  /// For program tags, prepend `Program:{ProgramName}.`
  /// where {ProgramName} is the name of the program in which the tag is created.
  /// </summary>
  String? get Name => _tag.Name;
  set Name(String? value) => _tag.Name = value;

  /// <summary>
  /// This attribute is required for CompactLogix/ControlLogix tags
  /// and for tags using a DH+ protocol bridge (i.e. a DHRIO module) to get to a PLC/5, SLC 500, or MicroLogix PLC on a remote DH+ link.
  /// The attribute is ignored if it is not a DH+ bridge route, but will generate a warning if debugging is active.
  /// Note that Micro800 connections must not have a path attribute.
  /// </summary>
  String? get Path => _tag.Path;
  set Path(String? value) => _tag.Path = value;

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
  bool? get UseConnectedMessaging => _tag.UseConnectedMessaging;
  set UseConnectedMessaging(value) => _tag.UseConnectedMessaging = value;

  /// <summary>
  /// Optional. An integer number of milliseconds to periodically read data from the PLC.
  /// </summary>
  ///
  /// <remarks>
  /// Use this attribute to automatically read data from the PLC on a set interval.
  /// This can be used in conjunction with the <see cref="ReadStarted"/> and <see cref="ReadCompleted"/> events to respond to the data updates.
  /// </remarks>
  Duration? get AutoSyncReadInterval => _tag.AutoSyncReadInterval;
  set AutoSyncReadInterval(value) => _tag.AutoSyncReadInterval = value;

  /// <summary>
  /// Optional. An integer number of milliseconds to buffer tag data changes before writing to the PLC.
  /// </summary>
  ///
  /// <remarks>
  /// Use this attribute to automatically write data to the PLC a set duration after setting its value.
  /// This can be used to lower the actual number of write operations by locally buffering local writes, and only writing to the PLC the most recent one when the wait completes.
  /// You can determine when a write starts and completes by catching the <see cref="WriteStarted"/> and <see cref="WriteCompleted"/> events.
  /// </remarks>
  Duration? get AutoSyncWriteInterval => _tag.AutoSyncWriteInterval;
  set AutoSyncWriteInterval(value) => _tag.AutoSyncWriteInterval = value;

  DebugLevel get debugLevel => _tag.debugLevel;
  set debugLevel(value) => _tag.debugLevel = value;

  /// <summary>
  /// Dimensions of Value if it is an array
  /// Ex. {2, 10} for a 2 column, 10 row array
  /// Non-arrays can use null (default)
  /// </summary>
  List<int>? get arrayDimensions => _plcMapper.arrayDimensions;
  set arrayDimensions(value) {
    _plcMapper.arrayDimensions = value;
    _tag.ElementCount = _plcMapper.getElementCount();
  }

  /// <inheritdoc cref="Tag.Initialize"/>
  void Initialize() {
    _tag.Initialize();
    DecodeAll();
  }

  // /// <inheritdoc cref="Tag.InitializeAsync"/>
  //  async Task InitializeAsync(CancellationToken token = default)
  // {
  //     await _tag.InitializeAsync(token);
  //     DecodeAll();
  // }

  // /// <inheritdoc cref="Tag.ReadAsync"/>
  //  async Task ReadAsync(CancellationToken token = default)
  // {
  //     await _tag.ReadAsync(token);
  //     DecodeAll();
  // }

  /// <inheritdoc cref="Tag.Read"/>
  void Read() {
    _tag.Read();
    DecodeAll();
  }

  // /// <inheritdoc cref="Tag.WriteAsync"/>
  //  async Task WriteAsync(CancellationToken token = default)
  // {
  //     if (!_tag.IsInitialized)
  //         await _tag.InitializeAsync(token);

  //     EncodeAll();
  //     await _tag.WriteAsync(token);
  // }

  /// <inheritdoc cref="Tag.Write"/>
  void Write() {
    EncodeAll();
    _tag.Write();
  }

  void DecodeAll() {
    Value = _plcMapper.decode(_tag);
  }

  void EncodeAll() {
    _plcMapper.encode(_tag, Value!);
  }

  /// <inheritdoc cref="Tag.GetStatus"/>
  Status GetStatus() => _tag.GetStatus();

  void Dispose() => _tag.Dispose();

  // ~Tag()
  // {
  //     Dispose();
  // }

  /// <summary>
  /// The local memory value that can be transferred to/from the PLC
  /// </summary>
  T? get Value => _value;
  set Value(value) => _value = value;
  T? _value;

  //  event EventHandler<TagEventArgs> ReadStarted
  // {
  //     add => _tag.ReadStarted += value;
  //     remove => _tag.ReadStarted -= value;
  // }
  //  event EventHandler<TagEventArgs> ReadCompleted
  // {
  //     add => _tag.ReadCompleted += value;
  //     remove => _tag.ReadCompleted -= value;
  // }
  //  event EventHandler<TagEventArgs> WriteStarted
  // {
  //     add => _tag.WriteStarted += value;
  //     remove => _tag.WriteStarted -= value;
  // }
  //  event EventHandler<TagEventArgs> WriteCompleted
  // {
  //     add => _tag.WriteCompleted += value;
  //     remove => _tag.WriteCompleted -= value;
  // }
  //  event EventHandler<TagEventArgs> Aborted
  // {
  //     add => _tag.Aborted += value;
  //     remove => _tag.Aborted -= value;
  // }
  //  event EventHandler<TagEventArgs> Destroyed
  // {
  //     add => _tag.Destroyed += value;
  //     remove => _tag.Destroyed -= value;
  // }

}
