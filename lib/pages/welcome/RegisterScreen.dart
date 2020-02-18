import 'package:flutter/material.dart';
import 'package:cmp/logic/Controller.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _userController;
  TextEditingController _mailController;
  TextEditingController _birthController;
  TextEditingController _passwordController;
  TextEditingController _passwordConfirmController;

  void initState() {
    super.initState();
    this._userController = new TextEditingController();
    this._mailController = new TextEditingController();
    this._birthController = new TextEditingController();
    this._passwordController = new TextEditingController();
    this._passwordConfirmController = new TextEditingController();
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

    final username = TextFormField(
      controller: this._userController,
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.account_circle),
        hintText: 'Benutzername',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = TextFormField(
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

    final birthDate = TextFormField(
      controller: this._birthController,
      keyboardType: TextInputType.datetime,
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.date_range),
        hintText: 'Geburtsdatum',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: this._passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordConfirm = TextFormField(
      controller: this._passwordConfirmController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        hintText: 'Passwort wiederholen',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          String email = this._mailController.text;
          String password = this._passwordController.text;

          bool success =
              await Controller().authentificator.signUp(email, password);
          if (success) {
            Navigator.of(context)
                .pushReplacementNamed('/register/email', arguments: email);
          }
        },
        padding: EdgeInsets.all(12),
        color: Color(0xFF253A4B),
        child: Text('REGISTRIEREN', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Sie haben bereits einen Account? Login',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/login');
      },
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
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            username,
            SizedBox(height: 8.0),
            email,
            SizedBox(height: 8.0),
            birthDate,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 8.0),
            passwordConfirm,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    ));
  }
}