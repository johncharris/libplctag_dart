import 'dart:typed_data';

import 'package:bit_array/bit_array.dart';
import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/tag.dart';

class TimerPlcMapper extends PlcMapperBase<AbTimer> {
  int? get elementSize => 12;

  AbTimer decodeAtOffset(Tag tag, int offset) {
    // Needed to look at RsLogix documentation for structure of TIMER
    var DINT2 = tag.GetInt32(offset);
    var DINT1 = tag.GetInt32(offset + 4);
    var DINT0 = tag.GetInt32(offset + 8);

    // The third DINT packs a few BOOLs into it
    var bitArray = BitArray.fromByteBuffer(Uint32List.fromList([DINT2]).buffer);

    var timer = new AbTimer(
        accumulated: DINT0, // ACC
        preset: DINT1, // PRE
        done: bitArray[29], // DN
        inProgress: bitArray[30], // TT
        enabled: bitArray[31]); // EN

    return timer;
  }

  void encodeAtOffset(Tag tag, int offset, AbTimer value) {
    var DINT0 = value.accumulated;
    var DINT1 = value.preset;

    var asdf = new BitArray(32);
    asdf[29] = value.done;
    asdf[30] = value.inProgress;
    asdf[31] = value.enabled;
    var DINT2 = BitArrayToInt(asdf);

    tag.SetInt32(offset, DINT2);
    tag.SetInt32(offset + 4, DINT1);
    tag.SetInt32(offset + 8, DINT0);
  }

  static int BitArrayToInt(BitArray? binary) {
    if (binary == null) throw new Exception("binary");
    if (binary.length != 32) throw new Exception("Must be at most 32 bits long");

    return binary.asUint32Iterable().first;
  }
}

class AbTimer {
  final int preset;
  final int accumulated;
  final bool enabled;
  final bool inProgress;
  final bool done;

  AbTimer(
      {required this.preset,
      required this.accumulated,
      required this.enabled,
      required this.inProgress,
      required this.done});
}
