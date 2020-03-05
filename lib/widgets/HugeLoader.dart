import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';

class HugeLoader {
  static Widget show() {
    //logout
    if (Controller().authentificator.user == null) {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
        ),
      );
    }

    //normal
    return Container(
      color: Controller().theming.background,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.redAccent),
        ),
      ),
    );
  }
}
