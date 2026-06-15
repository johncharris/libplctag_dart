import 'package:test/test.dart';

import 'lifecycle_test.dart' as lifecycle;
import 'attribute_string_test.dart' as attribute_string;
import 'mapper_test.dart' as mappers;
import 'status_test.dart' as status;
import 'event_test.dart' as events;

void main() {
  group('NativeTagWrapper lifecycle', lifecycle.main);
  group('Attribute string', attribute_string.main);
  group('Mappers', mappers.main);
  group('Status', status.main);
  group('Events', events.main);
}
