import 'package:cmp/logic/Authentificator.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class Mocking extends Mock implements Authentificator {}

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Authentificator', (){
    Controller controller = new Controller();
    Authentificator auth = new Authentificator(controller);

    test('Test if user can login', () async {
      final cl = Mocking();

      when(cl.initializeUser())
      .thenAnswer((_) async => true);//auth.signIn('dominik.deseyve@gmx.de', 'test1a23'));

      //await auth.initializeUser();
      //bool checkLogin = await auth.signIn('dominik.deseyve@gmx.de', 'test1a23');
      //print(checkLogin);
      expect(await auth.signIn('dominik.deseyve@gmx.de', 'test123'), true);
    });
  });
}