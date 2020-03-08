import 'package:cmp/logic/Authentificator.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Authentificator', (){
    Controller controller = Controller();
    Authentificator auth = Authentificator(controller);
    User user = User();

    test('Test if user can login', () async {
      expect(auth.signUp("testmail123@web.de", "test123", user), "1");
    });
  });
}