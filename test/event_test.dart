import 'package:libplctag_dart/native_tag_wrapper.dart';
import 'package:libplctag_dart/status.dart';
import 'package:libplctag_dart/tag_event.dart';
import 'package:test/test.dart';

import 'mock_native_tag.dart';

void main() {
  test('registerCallback forwards events to the callback', () {
    final mock = MockNativeTag();
    final tag = NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = 'x'
      ..name = 'y'
      ..initialize();

    final received = <List<int>>[];
    tag.registerCallback((tagId, eventId, status) => received.add([tagId, eventId, status]));
    mock.fireCallback(tag.nativeTagHandle, TagEventType.readCompleted, 0);
    expect(received, hasLength(1));
    expect(received.single[1], equals(TagEventType.readCompleted));
  });

  test('TagEvent.fromRaw maps each known event id to its typed event', () {
    expect(
        TagEvent.fromRaw(1, TagEventType.readStarted, 0), isA<ReadStartedEvent>());
    expect(
        TagEvent.fromRaw(1, TagEventType.readCompleted, 0), isA<ReadCompletedEvent>());
    expect(
        TagEvent.fromRaw(1, TagEventType.writeStarted, 0), isA<WriteStartedEvent>());
    expect(
        TagEvent.fromRaw(1, TagEventType.writeCompleted, 0), isA<WriteCompletedEvent>());
    expect(TagEvent.fromRaw(1, TagEventType.aborted, 0), isA<AbortedEvent>());
    expect(TagEvent.fromRaw(1, TagEventType.destroyed, 0), isA<DestroyedEvent>());
  });

  test('TagEvent.fromRaw returns null for an unknown event id', () {
    expect(TagEvent.fromRaw(1, 999, 0), isNull);
  });

  test('TagEvent carries the decoded Status', () {
    final evt = TagEvent.fromRaw(7, TagEventType.readCompleted, Status.errorTimeout.value);
    expect(evt!.tagId, equals(7));
    expect(evt.status, equals(Status.errorTimeout));
  });

  test('readAsync resolves when the underlying read succeeds', () async {
    final mock = MockNativeTag();
    final tag = NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = 'x'
      ..name = 'y'
      ..initialize();
    await tag.readAsync();
  });

  test('readAsync surfaces an error status as an exception', () async {
    final mock = MockNativeTag()..statusOverride = StatusOverride(Status.errorBadConnection.value);
    final tag = NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = 'x'
      ..name = 'y';
    expect(() async => await tag.readAsync(), throwsException);
  });
}
