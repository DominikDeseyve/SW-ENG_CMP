import 'package:flutter/foundation.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider();

  void init() {}

  void change() {
    this.notifyListeners();
  }
}
