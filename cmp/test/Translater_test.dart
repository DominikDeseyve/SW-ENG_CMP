import 'package:cmp/includes.dart/english.dart';
import 'package:cmp/includes.dart/german.dart';
import 'package:cmp/logic/Translater.dart';
import 'package:cmp/models/language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Language ger = german;
  Language eng = english;
  Translater trGl = Translater();

  group('Translater switch language', () {
    test('Test if language is german first', () {
      // This test should not fail
      expect(trGl.language, ger);
    });
    test('Test if language is switched', () {
      trGl.switchLanguage("ENGLISH");

      // This test should not fail
      expect(trGl.language, eng);
    });
    test('Test if language is german (not switched)', () {
      // This test should fail
      expect(trGl.language, ger);
    });
  });

  group('Translater check language', () {
    test('Test if language is german', () {
      Translater tr = Translater();

      expect(tr.language, ger);
    });

    test('Test if language is english', () {
      Translater tr = Translater();
      tr.switchLanguage("ENGLISH");

      expect(tr.language, eng);
    });
  });
}
