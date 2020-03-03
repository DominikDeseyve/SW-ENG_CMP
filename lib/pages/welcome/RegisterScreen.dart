import 'package:cmp/models/user.dart';
import 'package:cmp/widgets/TinyLoader.dart';
import 'package:flutter/material.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:intl/intl.dart';

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

  final _formKey = GlobalKey<FormState>();
  bool _validate = false;

  Future<DateTime> selectedDate;
  String geburtsdatum = "";

  DateTime selected;

  _showDateTimePicker() async {
    selected = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );

    setState(() {});
  }

  void initState() {
    super.initState();
    this._userController = new TextEditingController();
    this._mailController = new TextEditingController();
    this._birthController = new TextEditingController(text: geburtsdatum);
    this._passwordController = new TextEditingController();
    this._passwordConfirmController = new TextEditingController();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Form(
        key: _formKey,
        autovalidate: _validate,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 100.0),
            Hero(
              tag: 'cmp',
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 48.0,
                child: Image(
                  image: AssetImage('assets/images/symbol_rot.jpeg'),
                ),
              ),
            ),
            SizedBox(height: 60.0),
            TextFormField(
              controller: this._userController,
              autofocus: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Geben Sie einen Benutzernamen an';
                } else if (value.length <= 4) {
                  return 'Benutzername muss aus mind. 5 Buchstaben bestehen';
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                hintText: 'Benutzername',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: this._mailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              validator: (value) {
                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value))
                  return 'Geben Sie eine gültige Email an';
                else
                  return null;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Email',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: this._birthController,
              onTap: () async {
                await _showDateTimePicker();
                FocusScope.of(context).requestFocus(new FocusNode());

                var now = selected;
                var formatter = new DateFormat("dd.MM.yyyy");
                String formatted = formatter.format(now);
                print(formatted);
                _birthController.text = formatted;
              },
              autofocus: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Geben Sie einen Geburtsdatum an';
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.date_range),
                hintText: 'Geburtsdatum',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: this._passwordController,
              autofocus: false,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Geben Sie ein Passwort an';
                } else if (value.length < 6) {
                  return 'Passwort muss aus mind. 6 Zeichen bestehen';
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: 'Passwort',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: this._passwordConfirmController,
              autofocus: false,
              obscureText: true,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwörter stimmen nicht überein';
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: "Passwort wiederholen",
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: 24.0),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    String email = this._mailController.text;
                    String password = this._passwordController.text;

                    try {
                      TinyLoader.show(context, 'Benutzer wird erstellt...');
                      User user = new User();
                      user.username = this._userController.text;
                      user.birthday = DateTime.now();
                      bool success = await Controller()
                          .authentificator
                          .signUp(email, password, user);
                      TinyLoader.hide();
                      if (success) {
                        Navigator.of(context).pushReplacementNamed(
                            '/register/email',
                            arguments: email);
                      }
                    } catch (e) {
                      print(e.code);
                      //Navigator.of(context)
                      //    .pushReplacementNamed('/register', arguments: email);
                    }
                  } else {
                    setState(() {
                      _validate = true;
                    });
                  }
                },
                padding: EdgeInsets.all(12),
                color: Colors.redAccent,
                child:
                    Text('REGISTRIEREN', style: TextStyle(color: Colors.white)),
              ),
            ),
            FlatButton(
              child: Text(
                'Sie haben bereits einen Account? Login',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            )
          ],
        ),
      ),
    ));
  }
}
