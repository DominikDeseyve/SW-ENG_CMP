import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';

class Theming {
  Color _primary, _secondary, _accent, _tertiary, _quaternary, _quinary, _senary, _septenary, _octonary, _nonary, _denary;
  Color _fontPrimary, _fontSecondary, _fontAccent, _fontTertiary, _fontQuaternary;

  Theming() {}

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

  void initDark() {
    _primary = Colors.black;
    _secondary = Colors.white;
    _tertiary = Colors.grey;
    _accent = Colors.cyan;

    _fontPrimary = Colors.black;
    _fontSecondary = Colors.white;
    _fontTertiary = Colors.grey;
    _fontAccent = Colors.green;
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
  }

  void showSnackbar(BuildContext pContext, String pText) {
    final snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Text(pText),
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
