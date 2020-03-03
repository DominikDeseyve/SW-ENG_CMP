import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';

class TinyLoader {
  static BuildContext _dialogContext;

  static void show(BuildContext pContext, String pText) {
    showDialog(
      context: pContext,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _dialogContext = context;
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.3),
          body: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Controller().theming.fontAccent,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          pText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Controller().theming.fontSecondary,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static hide() {
    Navigator.of(_dialogContext).pop();
  }
}
