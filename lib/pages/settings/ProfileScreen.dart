import 'dart:io';

import 'package:cmp/widgets/TinyLoader.dart';
import 'package:cmp/widgets/UserAvatar.dart';
import 'package:intl/intl.dart';

import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _selectedImage;

  TextEditingController _usernameController;
  TextEditingController _birthdayController;
  TextEditingController _passwordController;

  bool _usernameError;
  bool _passwordError;

  void initState() {
    super.initState();

    this._usernameError = false;
    this._usernameController = new TextEditingController();
    this._usernameController.text = Controller().authentificator.user.username;

    this._birthdayController = new TextEditingController();
    this._birthdayController.text = DateFormat("dd.MM.yyyy").format(Controller().authentificator.user.birthday);

    this._passwordError = false;
    this._passwordController = new TextEditingController();
    this._passwordController.text = "test12";
  }

  void _chooseFile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this._selectedImage = image;
    });
  }

  void _validateInput(String pField, String pText) async {
    switch (pField) {
      case 'USERNAME':
        setState(() {
          if (pText.length <= 4 || pText.isEmpty) {
            this._usernameError = true;
          } else {
            this._usernameError = false;
          }
        });
        break;
      case 'PASSWORD':
        setState(() {
          if (pText.isEmpty || pText.length <= 6) {
            this._passwordError = true;
          } else {
            this._passwordError = false;
          }
        });
        break;

      default:
        break;
    }
  }

  void _editUser() async {
    if (this._usernameError && this._passwordError) {
      Controller().theming.showSnackbar(context, "Bitte passende Werte eingeben!");
    } else {
      TinyLoader.show(context, 'Benutzer wird gespeichert...');
      Controller().authentificator.user.username = this._usernameController.text;
      Controller().authentificator.user.birthday = DateFormat("dd.MM.yyyy").parse(this._birthdayController.text);

      if (this._selectedImage != null) {
        Controller().authentificator.user.imageURL = await Controller().storage.uploadImage(this._selectedImage, 'user/' + Controller().authentificator.user.userID);
      }

      await Controller().firebase.updateUserData(Controller().authentificator.user);

      if (this._passwordController.text != null && this._passwordController.text != "test12") {
        try {
          await Controller().authentificator.updatePasswort(this._passwordController.text);
          Controller().theming.showSnackbar(context, "Das Passwort wurde geändert!");
        } catch (e) {}
      }
      TinyLoader.hide();
      Controller().theming.showSnackbar(context, "Dein Profil wurde gespeichert!");
      Navigator.of(context).pop();
    }
  }

  Future<String> _chooseDate() async {
    int year = DateTime.now().year + 1;

    DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(year),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    return DateFormat("dd.MM.yyyy").format(selectedDate);
  }

  void _showOptionAlert() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Konto löschen'),
        content: Text('Willst du dein Konto wirklich löschen?'),
        actions: <Widget>[
          FlatButton(
            child: Text(Controller().translater.language.getLanguagePack("yes")),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              TinyLoader.show(context, 'Dein Konto wird gelöscht...');
              await Controller().authentificator.delete();
              await Controller().firebase.deleteUser();
              await Controller().authentificator.signOut();
              Navigator.of(context, rootNavigator: true).pushReplacementNamed('/welcome');
              TinyLoader.hide();
              Controller().theming.showSnackbar(context, 'Dein Konto wurde erfolgreich gelöscht');
            },
          ),
          FlatButton(
            child: Text(Controller().translater.language.getLanguagePack("no")),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Column(
          children: <Widget>[
            AppBar(
              iconTheme: IconThemeData(
                color: Controller().theming.fontSecondary,
              ),
              backgroundColor: Controller().theming.primary,
              centerTitle: true,
              elevation: 0,
              title: Text(
                Controller().translater.language.getLanguagePack("profile"),
                style: TextStyle(
                  color: Controller().theming.fontSecondary,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 7,
              color: Controller().theming.accent,
            ),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: false,
        primary: true,
        children: <Widget>[
          Container(
            height: 150,
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 15),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: this._chooseFile,
              child: (this._selectedImage == null
                  ? UserAvatar(
                      Controller().authentificator.user,
                      width: 150,
                    )
                  : Image.file(
                      this._selectedImage,
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    )),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              onChanged: (String pText) => this._validateInput('USERNAME', pText),
              controller: _usernameController,
              style: TextStyle(
                fontSize: 18,
                color: Controller().theming.fontPrimary,
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: (this._usernameError ? Controller().translater.language.getLanguagePack("username_invalid") : Controller().translater.language.getLanguagePack("username")),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                helperStyle: TextStyle(fontSize: 18),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Controller().theming.fontPrimary,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Controller().theming.fontTertiary,
                  ),
                ),
                labelStyle: TextStyle(
                  color: (!this._usernameError ? Controller().theming.fontPrimary : Controller().theming.fontAccent),
                  fontSize: 18,
                ),
                focusColor: Controller().theming.fontPrimary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              controller: _birthdayController,
              style: TextStyle(
                fontSize: 18,
                color: Controller().theming.fontPrimary,
              ),
              keyboardType: TextInputType.datetime,
              readOnly: true,
              onTap: () {
                setState(() {
                  try {
                    _chooseDate().then((value) => _birthdayController.text = value);
                  } catch (e) {}
                });
              },
              decoration: InputDecoration(
                labelText: Controller().translater.language.getLanguagePack("birthday"),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                helperStyle: TextStyle(fontSize: 18),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Controller().theming.fontPrimary,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Controller().theming.fontTertiary,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Controller().theming.fontPrimary,
                  fontSize: 18,
                ),
                focusColor: Colors.redAccent,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              onChanged: (String pText) => this._validateInput('PASSWORD', pText),
              controller: _passwordController,
              style: TextStyle(
                fontSize: 18,
                color: Controller().theming.fontPrimary,
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
              onTap: () {
                if (this._passwordController.text == "test12") {
                  setState(() {
                    this._passwordController.text = "";
                  });
                }
              },
              decoration: InputDecoration(
                labelText: (this._passwordError ? Controller().translater.language.getLanguagePack("password_invalid") : Controller().translater.language.getLanguagePack("password")),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                helperStyle: TextStyle(fontSize: 18),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Controller().theming.fontPrimary,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Controller().theming.fontTertiary,
                  ),
                ),
                labelStyle: TextStyle(
                  fontSize: 18,
                  color: (!this._passwordError ? Controller().theming.fontPrimary : Controller().theming.fontAccent),
                ),
                focusColor: Controller().theming.tertiary,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 25, 50, 10),
            child: FlatButton(
              onPressed: () async {
                this._editUser();
              },
              padding: const EdgeInsets.all(10),
              color: Controller().theming.accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Icons.check,
                      size: 20.0,
                      color: Controller().theming.fontSecondary,
                    ),
                  ),
                  Text(
                    Controller().translater.language.getLanguagePack("save_profile"),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Controller().theming.fontSecondary,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 5, 50, 25),
            child: FlatButton(
              onPressed: () {
                this._showOptionAlert();
              },
              padding: const EdgeInsets.all(10),
              color: Controller().theming.tertiary.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(
                  width: 1,
                  color: Controller().theming.fontPrimary,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Icons.clear,
                      size: 20.0,
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                  Text(
                    Controller().translater.language.getLanguagePack("delete_profile"),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Controller().theming.fontPrimary,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
