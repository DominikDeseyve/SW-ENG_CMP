import 'package:cmp/logic/Authentificator.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Authentificator', (){
    Controller controller = Controller();
    Authentificator auth = Authentificator(controller);
    test('Test if user can login', (){
      Future<bool> checkLogin = auth.signIn('dominik.deseyve@gmx.de', 'test123');
      expect(checkLogin, true);
    });
  });
}