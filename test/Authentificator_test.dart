import 'package:cmp/logic/Authentificator.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Authentificator', (){
    Controller controller = new Controller();
    Authentificator auth = new Authentificator(controller);

    test('Test if user can login', () async {
      
      
    });
  });
}