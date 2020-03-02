import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/HTTP.dart';
import 'package:cmp/models/genre.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/models/visibleness.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cmp/logic/Firebase.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  group('HTTP', (){
    //HTTP http = HTTP();

    test('Test if uri is returned', () async {
      String text = await HTTP.getSoundURL("kDAp2ifE_jE");

      expect(text, '');
    });
  });
}