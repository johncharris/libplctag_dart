import 'package:libplctag_dart/native_tag_wrapper.dart';
import 'package:test/test.dart';

import 'mock_native_tag.dart';

void main() {
  test('read before initialize triggers initialize', () {
    final mock = MockNativeTag();
    final tag = NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = '127.0.0.1'
      ..name = 'TestTag';

    tag.read();

    expect(mock.createAttributeStrings, hasLength(1));
    expect(mock.tags, hasLength(1));
  });

  test('initialize cannot be called twice', () {
    final mock = MockNativeTag();
    final tag = NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = '127.0.0.1'
      ..name = 'TestTag'
      ..initialize();

    expect(() => tag.initialize(), throwsStateError);
  });

  test('setting attribute after initialize throws', () {
    final mock = MockNativeTag();
    final tag = NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = '127.0.0.1'
      ..name = 'TestTag'
      ..initialize();

    expect(() => tag.name = 'OtherTag', throwsStateError);
  });

  test('operations after dispose throw', () {
    final mock = MockNativeTag();
    final tag = NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = '127.0.0.1'
      ..name = 'TestTag'
      ..initialize()
      ..dispose();

    expect(() => tag.read(), throwsStateError);
    expect(() => tag.write(), throwsStateError);
    expect(() => tag.getSize(), throwsStateError);
  });

  test('dispose is idempotent', () {
    final mock = MockNativeTag();
    final tag = NativeTagWrapper(mock)
      ..protocol = 'ab_eip'
      ..gateway = '127.0.0.1'
      ..name = 'TestTag'
      ..initialize();

    expect(() {
      tag.dispose();
      tag.dispose();
    }, returnsNormally);
  });
}
