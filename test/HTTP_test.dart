import 'package:cmp/logic/HTTP.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('HTTP', () {
    test('throws an exception if the http call completes with an error', () {
      HTTP h = HTTP();
      expect(h.getSoundURI("RLWcYADoV84"), "");
    });
  });
}
