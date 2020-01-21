import 'package:flutter/material.dart';
import 'package:cmp_test/common/app_card.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFFF5252), Color(0xDD000000)],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppCard(
              child: Text(
                "CMP",
                style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            AppCard(
              child: Container(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: "Email"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Passwort"),
                    ),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 20.0),
                        child: FlatButton(
                          color: Colors.black,
                          textColor: Colors.white,
                          onPressed: () {},
                          child: Text("Login"),
                        )),
                    Container(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                            onPressed: () {},
                            child: Text("Passwort vergessen?")))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
