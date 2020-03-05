import 'package:cmp/logic/HTTP.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements HTTP {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('HTTP', () {
    test('throws an exception if the http call completes with an error', () {
      final mock = MockClient();


      //when(mock.Test()).thenAnswer((_) => 3);



      //verify(mock.getSoundURL("8jzDnsjYv9A"));
      //when(MockClient().getSoundURL("8jzDnsjYv9A")).thenReturn("test");
      expect(mock.test, 3);
    });
  });
}
