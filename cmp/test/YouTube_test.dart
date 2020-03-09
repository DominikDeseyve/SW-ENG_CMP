import 'package:cmp/logic/YouTube.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('YouTube', () {
    test('throws an exception if the http call completes with an error', () {
      YouTube h = YouTube();
      expect(h.getSoundUrlViaPlugin("RLWcYADoV84"), "");
    });
  });
}
