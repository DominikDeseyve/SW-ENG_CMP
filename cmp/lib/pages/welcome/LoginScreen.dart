import 'package:cmp/widgets/TinyLoader.dart';
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

  final _formKey = GlobalKey<FormState>();
  bool _validate = false;

  String error = "";

  void initState() {
    super.initState();
    this._mailController = new TextEditingController();
    this._passwordController = new TextEditingController();
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
                    image: AssetImage('assets/icons/icon-blue-256x256.png'),
                  ),
                )),
            SizedBox(height: 48.0),
            InkWell(
              child: Text(
                error,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/register', (route) => false);
              },
            ),
            SizedBox(height: 5.0),
            TextFormField(
              controller: this._mailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              validator: (value) {
                Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value)) {
                  return 'Geben Sie eine gültige Email an';
                } //else if (await Controller().firebase.isEmailExisting(value)) {
                // return 'Kein Account mit dieser Email. Registrieren';
                // }
                else
                  return null;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Email',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
                  setState(() {
                    error = "";
                  });

                  try {
                    TinyLoader.show(context, "Du wirst angemeldet...");
                    String email = this._mailController.text;
                    String password = this._passwordController.text;

                    if (_formKey.currentState.validate()) {
                      bool success = await Controller().authentificator.signIn(email, password);
                      TinyLoader.hide();
                      if (success) {
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      } else {
                        setState(() {
                          error = "E-Mail wurde nicht bestätigt";
                        });
                        //Controller().theming.showSnackbar(context, "Fehler beim Anmelden");
                      }
                    }
                  } catch (e) {
                    TinyLoader.hide();
                    setState(() {
                      error = "Email oder Passwort sind falsch. Noch kein Account?\nJetzt registrieren!";
                    });
                    //Controller().theming.showSnackbar(context, e.code);
                    print(e);
                  }

                  //Navigator.of(context).pushNamed(HomePage.tag);
                },
                padding: EdgeInsets.all(12),
                color: Colors.redAccent,
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            FlatButton(
              child: Text(
                'Passwort vergessen?',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () async {
                /*showDialog(
          context: context,
          builder: (BuildContext context) => PasswordDialog(),*/

                try {
                  String email = this._mailController.text;

                  await Controller().authentificator.resetPasswort(email);
                } catch (e) {
                  print(e.code);
                }
                //Navigator.of(context).pushNamed(HomePage.tag);
              },
            ),
          ],
        ),
      ),
    ));
  }
}

class PasswordDialog extends StatefulWidget {
  PasswordDialog();
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  TextEditingController _mailController = new TextEditingController();
  void initState() {
    super.initState();
  }

  void _send() {
    String mail = this._mailController.text;
    if (mail.isEmpty) {
      return;
    }
    Controller().authentificator.resetPasswort(mail).then((String pError) {
      print(pError);
      if (pError != 'ERROR_INVALID_EMAIL' && pError != 'ERROR_USER_NOT_FOUND') {
        //Controller().theming.showSnackbar(context, 'Bitte überprüfen Sie ihr Postfach bei ' + mail);
        setState(() {
          this._mailController.text = '';
        });
        Navigator.of(context).pop();
      }
    });
  }

  Widget build(BuildContext dialogContext) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(15),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: this._mailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              hintText: 'Email',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          ),
          Divider(
            thickness: 0.5,
            color: Colors.black87,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: this._send,
                  color: Colors.redAccent,
                  child: Text(
                    'Senden',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
