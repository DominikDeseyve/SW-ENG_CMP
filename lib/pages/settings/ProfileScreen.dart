import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _selectedImage;

  TextEditingController _usernameController;
  TextEditingController _birthdayController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    if (Controller().authentificator.user.imageURL != null) {
      this._selectedImage = Controller().authentificator.user.imageURL;
    }

    this._usernameController = new TextEditingController();
    this._usernameController.text = Controller().authentificator.user.username;

    this._birthdayController = new TextEditingController();
    this._birthdayController.text = DateFormat("dd.MM.yyyy").format(Controller().authentificator.user.birthday);

    this._passwordController = new TextEditingController();
    this._passwordController.text = "passwort hier!";
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
      if (this._selectedImage.runtimeType == String) {
        Controller().authentificator.user.imageURL = this._selectedImage;
      } else {
        Controller().authentificator.user.imageURL = await Controller().storage.uploadImage(this._selectedImage, 'user/' + Controller().authentificator.user.userID);
      }
    }

    await Controller().firebase.updateUser();

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF253A4B),
          centerTitle: true,
          elevation: 0,
          title: Text("Profil"),
        ),
      ),
      body: ListView(
        shrinkWrap: false,
        primary: true,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.015,
            color: Colors.redAccent,
          ),
          Container(
            height: 150,
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 15),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: this._chooseFile,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black26),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: (this._selectedImage == null ? AssetImage("assets/images/person.png") : (this._selectedImage.runtimeType == String ? NetworkImage(this._selectedImage) : FileImage(this._selectedImage))),
                  ),
                ),
              ),
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
                    width: 120,
                    child: Text(
                      "Benutzername",
                      style: TextStyle(
                        color: Colors.redAccent,
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
                    controller: _usernameController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      helperStyle: TextStyle(fontSize: 18),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
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
            margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Container(
                    width: 120,
                    child: Text(
                      "Geburtsdatum",
                      style: TextStyle(
                        color: Colors.redAccent,
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
                    onTap: () {
                      setState(() {
                        _chooseDate().then((value) => _birthdayController.text = value);
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      helperStyle: TextStyle(fontSize: 18),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
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
                    width: 120,
                    child: Text(
                      "Passwort",
                      style: TextStyle(
                        color: Colors.redAccent,
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
                    controller: _passwordController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      helperStyle: TextStyle(fontSize: 18),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
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
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            child: FlatButton(
              onPressed: () async {
                this._editUser();
              },
              padding: const EdgeInsets.all(10),
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Icons.check,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Profil speichern",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
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
