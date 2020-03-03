import 'package:cmp/logic/Controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test("testing a future2 ", () async {
    Controller controller = new Controller();
    bool future = await controller.authentificator.signIn("robin.wangen@gmail.com", "test123");
    expect(future, true);
  });
}
