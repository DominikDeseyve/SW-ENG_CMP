import 'dart:io';

import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File _selectedImage;

  TextEditingController _usernameController;
  TextEditingController _firstnameController;
  TextEditingController _lastnameController;
  TextEditingController _birthdayController;
  TextEditingController _passwordController;

  bool _darkmode = true;

  void initState() {
    super.initState();

    this._usernameController = new TextEditingController();
    this._usernameController.text = "test";

    this._firstnameController = new TextEditingController();
    this._firstnameController.text = "test";

    this._lastnameController = new TextEditingController();
    this._lastnameController.text = "test";

    this._birthdayController = new TextEditingController();
    this._birthdayController.text = "test";

    this._passwordController = new TextEditingController();
    this._passwordController.text = "test";
  }

  void _chooseFile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this._selectedImage = image;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF253A4B),
          centerTitle: true,
          elevation: 0,
          title: Text("Einstellungen"),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.save_alt,
              ),
            ),
          ],
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
                    image: (this._selectedImage == null ? AssetImage('assets/images/plus.png') : FileImage(this._selectedImage)),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Profil",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: Color(0xFF253A4B),
                ),
                Container(
                  height: 40,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 35, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Allgemeines",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: Color(0xFF253A4B),
                ),
                Container(
                  height: 40,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Container(
                          width: 120,
                          child: Text(
                            "DarkMode",
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
                        child: Switch(
                            activeColor: Colors.redAccent,
                            value: _darkmode,
                            onChanged: (value) {
                              setState(() {
                                _darkmode = value;
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            child: FlatButton(
              onPressed: () async {
                await Controller().authentificator.signOut();
                Navigator.of(context, rootNavigator: true).pushReplacementNamed('/welcome');
              },
              padding: const EdgeInsets.all(10),
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Icons.directions_run,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Einstellungen speichern",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            child: FlatButton(
              onPressed: () async {
                await Controller().authentificator.signOut();
                Navigator.of(context, rootNavigator: true).pushReplacementNamed('/welcome');
              },
              padding: const EdgeInsets.all(10),
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Icons.directions_run,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Abmelden",
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
