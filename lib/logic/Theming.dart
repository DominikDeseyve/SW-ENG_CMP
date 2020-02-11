import 'package:flutter/material.dart';

class Theming {
  void showSnackbar(BuildContext pContext, String pText) {
    final snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Text(pText),
      ),
    );

    Scaffold.of(pContext).showSnackBar(snackBar);
  }
}
