import 'dart:io';

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

  @override
  void initState() {
    super.initState();

    this._usernameController = new TextEditingController();
    this._usernameController.text = Controller().authentificator.user.username;

    this._birthdayController = new TextEditingController();
    this._birthdayController.text = DateFormat("dd.MM.yyyy").format(Controller().authentificator.user.birthday);

    this._passwordController = new TextEditingController();
    this._passwordController.text = "test";
  }

  void _chooseFile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this._selectedImage = image;
    });
  }

  void _editUser() async {
    Controller().authentificator.user.username = this._usernameController.text;
    Controller().authentificator.user.birthday = DateFormat("dd.MM.yyyy").parse(this._birthdayController.text);

    if (this._selectedImage != null) {
      Controller().authentificator.user.imageURL = await Controller().storage.uploadImage(this._selectedImage, 'user/' + Controller().authentificator.user.userID);
    }

    await Controller().firebase.updateUserData(Controller().authentificator.user);

    if (this._passwordController.text != null && this._passwordController.text != "test") {
      await Controller().authentificator.updatePasswort(this._passwordController.text);
    }

    Controller().theming.showSnackbar(context, "Dein Profil wurde gespeichert!");
    Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Controller().theming.primary,
              centerTitle: true,
              elevation: 0,
              title: Text(
                "Profil",
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
            height: 40,
            margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2) - 40,
                    child: Text(
                      "Benutzername",
                      style: TextStyle(
                        color: Controller().theming.fontPrimary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextFormField(
                    controller: _usernameController,
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return 'Das Feld darf nicht leer sein';
                      }
                      return value;
                    },
                    style: TextStyle(
                      fontSize: 18,
                      color: Controller().theming.fontPrimary,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
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
                        color: Controller().theming.fontTertiary,
                        fontSize: 18,
                      ),
                      focusColor: Controller().theming.tertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2) - 40,
                    child: Text(
                      "Geburtsdatum",
                      style: TextStyle(
                        color: Controller().theming.fontPrimary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextField(
                    controller: _birthdayController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () {
                      setState(() {
                        _chooseDate().then((value) => _birthdayController.text = value);
                      });
                    },
                    decoration: InputDecoration(
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
                        color: Colors.redAccent,
                        fontSize: 18,
                      ),
                      focusColor: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2) - 40,
                    child: Text(
                      "Passwort",
                      style: TextStyle(
                        color: Controller().theming.fontPrimary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return 'Feld darf nicht leer sein!';
                      }
                      return value;
                    },
                    style: TextStyle(
                      fontSize: 18,
                      color: Controller().theming.fontPrimary,
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    onTap: () {
                      if (this._passwordController.text == "test") {
                        setState(() {
                          this._passwordController.text = "";
                        });
                      }
                    },
                    onEditingComplete: () {
                      if (this._passwordController.text == "") {
                        this._passwordController.text = "test";
                      }
                    },
                    decoration: InputDecoration(
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
                      ),
                      focusColor: Controller().theming.tertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
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
                    "Profil speichern",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Controller().theming.fontSecondary,
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
