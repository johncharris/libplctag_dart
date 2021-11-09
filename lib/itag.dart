import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/protocol.dart';
import 'package:libplctag_dart/status.dart';

abstract class ITag {
  // TODO Figure this one out
  // int[] arrayDimensions;
  String? gateway;
  String? name;
  String? path;
  PlcType? plcType;
  Protocol? protocol;
  int? readCacheMillisecondDuration;
  Duration? timeout;
  bool? useConnectedMessaging;

  Status getStatus();
  void initialize();
  Future initializeAsync();
  void read();
  Future readAsync();
  void write();
  Future writeAsync();
}
