import 'dart:typed_data';

import 'package:bit_array/bit_array.dart';
import 'package:libplctag_dart/data_types/plc_mapper_base.dart';
import 'package:libplctag_dart/tag.dart';

/// Maps Allen-Bradley TIMER structures (three DINTs + status bits).
///
/// Layout (from RSLogix):
///   * `DINT2` packs the status bits — bit 29 (DN), 30 (TT), 31 (EN).
///   * `DINT1` is the preset (PRE).
///   * `DINT0` is the accumulated time (ACC).
class TimerPlcMapper extends PlcMapperBase<AbTimer> {
  static const int _bitDone = 29;
  static const int _bitInProgress = 30;
  static const int _bitEnabled = 31;

  @override
  int? get elementSize => 12;

  @override
  AbTimer decodeAtOffset(Tag tag, int offset) {
    final statusWord = tag.getInt32(offset);
    final preset = tag.getInt32(offset + 4);
    final accumulated = tag.getInt32(offset + 8);

    final bits = BitArray.fromByteBuffer(Uint32List.fromList([statusWord]).buffer);

    return AbTimer(
      preset: preset,
      accumulated: accumulated,
      done: bits[_bitDone],
      inProgress: bits[_bitInProgress],
      enabled: bits[_bitEnabled],
    );
  }

  @override
  void encodeAtOffset(Tag tag, int offset, AbTimer value) {
    final bits = BitArray(32)
      ..[_bitDone] = value.done
      ..[_bitInProgress] = value.inProgress
      ..[_bitEnabled] = value.enabled;

    tag.setInt32(offset, _bitArrayToInt32(bits));
    tag.setInt32(offset + 4, value.preset);
    tag.setInt32(offset + 8, value.accumulated);
  }

  static int _bitArrayToInt32(BitArray bits) {
    if (bits.length != 32) {
      throw ArgumentError.value(bits.length, 'bits.length', 'must be exactly 32');
    }
    return bits.asUint32Iterable().first;
  }
}

/// A decoded Allen-Bradley TIMER value.
class AbTimer {
  final int preset;
  final int accumulated;
  final bool enabled;
  final bool inProgress;
  final bool done;

  AbTimer({
    required this.preset,
    required this.accumulated,
    required this.enabled,
    required this.inProgress,
    required this.done,
  });
}
