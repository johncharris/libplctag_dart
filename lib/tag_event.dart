import 'package:libplctag_dart/status.dart';

/// Event identifiers emitted by the native libplctag library
/// for a tag's registered callback.
class TagEventType {
  static const int readStarted = 1;
  static const int readCompleted = 2;
  static const int writeStarted = 3;
  static const int writeCompleted = 4;
  static const int aborted = 5;
  static const int destroyed = 6;
}

/// A typed event raised by the native library for a tag.
abstract class TagEvent {
  final int tagId;
  final Status status;
  const TagEvent(this.tagId, this.status);

  /// Construct the appropriate subclass for a raw event ID. Returns null
  /// when the ID does not map to a known event.
  static TagEvent? fromRaw(int tagId, int eventId, int statusCode) {
    final status = Status.fromInt(statusCode);
    switch (eventId) {
      case TagEventType.readStarted:
        return ReadStartedEvent(tagId, status);
      case TagEventType.readCompleted:
        return ReadCompletedEvent(tagId, status);
      case TagEventType.writeStarted:
        return WriteStartedEvent(tagId, status);
      case TagEventType.writeCompleted:
        return WriteCompletedEvent(tagId, status);
      case TagEventType.aborted:
        return AbortedEvent(tagId, status);
      case TagEventType.destroyed:
        return DestroyedEvent(tagId, status);
      default:
        return null;
    }
  }
}

class ReadStartedEvent extends TagEvent {
  const ReadStartedEvent(int tagId, Status status) : super(tagId, status);
}

class ReadCompletedEvent extends TagEvent {
  const ReadCompletedEvent(int tagId, Status status) : super(tagId, status);
}

class WriteStartedEvent extends TagEvent {
  const WriteStartedEvent(int tagId, Status status) : super(tagId, status);
}

class WriteCompletedEvent extends TagEvent {
  const WriteCompletedEvent(int tagId, Status status) : super(tagId, status);
}

class AbortedEvent extends TagEvent {
  const AbortedEvent(int tagId, Status status) : super(tagId, status);
}

class DestroyedEvent extends TagEvent {
  const DestroyedEvent(int tagId, Status status) : super(tagId, status);
}
