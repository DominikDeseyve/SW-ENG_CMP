import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width, //definiert die Breite der App auf den Bildschirm
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "CMP",
              style: TextStyle(fontSize: 80.0, color: Colors.blue),
            ),
            Text(
              "Connected Musik Player".toUpperCase(),
              style: TextStyle(fontSize: 15.0, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            MaterialButton(
              height: 50.0,
              onPressed: () {},
              textColor: Colors.white,
              color: Colors.blue,
              child: Text(
                "login".toUpperCase(),
              ),
            ),
            MaterialButton(
              height: 50.0,
              onPressed: () {},
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("Registrieren12".toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
