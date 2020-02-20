import 'package:flutter/material.dart';
import 'package:cmp/logic/Controller.dart';

//import 'package:login/home_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _mailController;
  TextEditingController _passwordController;

  void initState() {
    super.initState();
    this._mailController = new TextEditingController(text: 'dominik@deseyve.com');
    this._passwordController = new TextEditingController(text: 'test123');
  }

  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'cmp',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: FlutterLogo(
          size: 200,
        ),
      ),
    );

    Widget email = TextFormField(
      controller: this._mailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.email),
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    Widget password = TextFormField(
      controller: this._passwordController,
      autofocus: false,
      obscureText: true,
      validator: (input) => input.isEmpty ? "*Required" : null,
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        hintText: 'Passwort',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    Widget loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          String email = this._mailController.text;
          String password = this._passwordController.text;

          bool success = await Controller().authentificator.signIn(email, password);
          if (success) {
            Navigator.of(context).pushReplacementNamed('/root');
          }
          //Navigator.of(context).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Color(0xFF253A4B),
        child: Text('LOGIN', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Passwort vergessen?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
        body: Container(
      // Add box decoration
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.0, 1.0],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.grey[400],
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[logo, SizedBox(height: 48.0), email, SizedBox(height: 8.0), password, SizedBox(height: 24.0), loginButton, forgotLabel],
        ),
      ),
    ));
  }
}
