import 'dart:io';

import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/visibleness.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePlaylistScreen extends StatefulWidget {
  _CreatePlaylistScreenState createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  List<Visibleness> _visiblenessList;

  State _imageState;
  int _radioGroup = 0;

  File _selectedImage;
  TextEditingController _nameController;
  TextEditingController _maxAttendeesController;
  TextEditingController _descriptionController;
  Visibleness _visibleness;
  //List<Genre> _blackedGenre = [];

  void initState() {
    super.initState();

    this._nameController = new TextEditingController();
    this._nameController.text = "";

    this._maxAttendeesController = new TextEditingController();
    this._maxAttendeesController.text = "";

    this._descriptionController = new TextEditingController();
    this._descriptionController.text = " ";

    _visiblenessList = <Visibleness>[
      Visibleness('PUBLIC'),
      Visibleness('PRIVATE'),
    ];
    this._visibleness = this._visiblenessList[0];
  }

  void _chooseFile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this._selectedImage = image;
    });
  }

  Future _createPlaylist() async {
    Playlist playlist = new Playlist();

    playlist.name = this._nameController.text;
    playlist.maxAttendees = int.parse(this._maxAttendeesController.text);
    playlist.description = this._descriptionController.text;
    playlist.visibleness = this._visibleness;
    playlist.blackedGenre = [];
    playlist.creator = Controller().authentificator.user;
    playlist.playlistID = await Controller().firebase.createPlaylist(playlist);

    Role role = new Role(ROLE.ADMIN);
    await Controller().firebase.joinPlaylist(playlist, Controller().authentificator.user, role);

    if (this._selectedImage != null) {
      playlist.imageURL = await Controller().storage.uploadImage(this._selectedImage, 'playlist/' + playlist.playlistID);
    }

    Controller().theming.showSnackbar(context, "Ihre Playlist wurde erfolgreich erstellt");
    Navigator.of(context).pushNamed('/playlist', arguments: playlist);
  }

  void clearTextfields() {
    setState(() {
      _selectedImage = null;

      this._nameController.text = "";
      this._maxAttendeesController.text = "";
      this._descriptionController.text = " ";
      this._visibleness = this._visiblenessList[0];
    });
  }

/*
  String _generateBlackedGenreLabel() {
    String label = '';
    if (this._blackedGenre.length == 0) {
      label = "Blacked Genre";
    } else {
      int length = 3;
      if (this._blackedGenre.length < 3) {
        length = this._blackedGenre.length;
      }
      for (int i = 0; i < length; i++) {
        label += this._blackedGenre[i].name;
        if (i < this._blackedGenre.length - 1) {
          label += ', ';
        }
      }
    }
    return label;
  }
*/

  @override
  void dispose() {
    // Clean up the controller when the widget is closed

    _nameController.dispose();
    _descriptionController.dispose();
    _maxAttendeesController.dispose();
    super.dispose();
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
          title: Text("Playlist erstellen"),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
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
          ),
          //kompletter Bildschirm
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: MediaQuery.of(context).size.height * 0.01,
                  color: Colors.redAccent,
                ),
              ),
            ),
            child: ListView(
              children: <Widget>[
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
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Name der Playlist",
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
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextField(
                    controller: _maxAttendeesController,
                    style: TextStyle(fontSize: 18),
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    decoration: InputDecoration(
                      counter: Offstage(),
                      labelText: "max. Anzahl an Teilnehmer",
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
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Art des Events",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  activeColor: Colors.redAccent,
                                  value: 0,
                                  groupValue: _radioGroup,
                                  onChanged: (t) {
                                    setState(() {
                                      this._visibleness = this._visiblenessList[t];
                                      _radioGroup = t;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      this._visibleness = this._visiblenessList[0];
                                      _radioGroup = 0;
                                    });
                                  },
                                  child: Text("öffentliche Playlist"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  activeColor: Colors.redAccent,
                                  value: 1,
                                  groupValue: _radioGroup,
                                  onChanged: (t) {
                                    setState(() {
                                      this._visibleness = this._visiblenessList[t];
                                      _radioGroup = t;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      this._visibleness = this._visiblenessList[1];
                                      _radioGroup = 1;
                                    });
                                  },
                                  child: Text("private Playlist"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextField(
                    minLines: 3,
                    maxLines: null,
                    controller: _descriptionController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: "Beschreibung",
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                  child: FlatButton(
                    onPressed: () async {
                      await this._createPlaylist();
                      clearTextfields();
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
                            Icons.done,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Playlist erstellen",
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
          ),
        ],
      ),
    );
  }
}
