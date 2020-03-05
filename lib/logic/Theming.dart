import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';

class Theming {
  Color _primary, _secondary, _accent, _tertiary;
  Color _fontPrimary, _fontSecondary, _fontAccent, _fontTertiary;
  Color _background, _navigation;

  Theming();

  void initDark() {
    _primary = Color(0xFF080d12);
    _secondary = Colors.white;
    _tertiary = Colors.grey;
    _accent = Colors.redAccent;

    _fontPrimary = Colors.white;
    _fontSecondary = Colors.white;
    _fontTertiary = Colors.grey;
    _fontAccent = Colors.redAccent;

    _background = Color(0xFF111b24);
    _navigation = Color(0xFF080d12);
  }

  void initLight() {
    _primary = Color(0xFF253A4B);
    _secondary = Colors.white;
    _tertiary = Colors.grey;
    _accent = Colors.redAccent;

    _fontPrimary = Colors.black;
    _fontSecondary = Colors.white;
    _fontTertiary = Colors.grey;
    _fontAccent = Colors.redAccent;

    _background = Colors.white;
    _navigation = Color(0xFFf0f0f0);
  }

  // Getter
  Color get primary {
    return this._primary;
  }

  Color get secondary {
    return this._secondary;
  }

  Color get tertiary {
    return this._tertiary;
  }

  Color get accent {
    return this._accent;
  }

  Color get fontPrimary {
    return this._fontPrimary;
  }

  Color get fontSecondary {
    return this._fontSecondary;
  }

  Color get fontTertiary {
    return this._fontTertiary;
  }

  Color get fontAccent {
    return this._fontAccent;
  }

  Color get background {
    return this._background;
  }

  Color get navigation {
    return this._navigation;
  }

  //Flushbar alternative
  void showSnackbar(BuildContext pContext, String pText) {
    final snackBar = SnackBar(
      duration: Duration(milliseconds: 2000),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Text(
          pText,
          textAlign: TextAlign.center,
        ),
      ),
      action: SnackBarAction(
        label: 'OK',
        textColor: Controller().theming.fontAccent,
        onPressed: () {},
      ),
    );

    Scaffold.of(pContext).showSnackBar(snackBar);
  }
}
