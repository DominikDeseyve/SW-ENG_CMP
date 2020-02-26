import 'dart:io';

import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/visibleness.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:cmp/widgets/PlaylistAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditPlaylistScreen extends StatefulWidget {
  final Playlist _playlist;

  EditPlaylistScreen(this._playlist);

  _EditPlaylistScreenState createState() => _EditPlaylistScreenState();
}

class _EditPlaylistScreenState extends State<EditPlaylistScreen> {
  int _radioGroup = 0;

  File _selectedImage;
  TextEditingController _nameController;
  TextEditingController _maxAttendeesController;
  TextEditingController _descriptionController;

  Visibleness _visibleness;
  List<Visibleness> _visiblenessList;
  //List<Genre> _blackedGenre = [];

  void initState() {
    super.initState();

    this._nameController = new TextEditingController();
    this._nameController.text = this.widget._playlist.name;

    this._maxAttendeesController = new TextEditingController();
    this._maxAttendeesController.text = this.widget._playlist.maxAttendees.toString();

    this._descriptionController = new TextEditingController();
    this._descriptionController.text = this.widget._playlist.description;

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

  void _editPlaylist() async {
    this.widget._playlist.name = this._nameController.text;
    this.widget._playlist.maxAttendees = int.parse(this._maxAttendeesController.text);
    this.widget._playlist.visibleness = this._visibleness;
    this.widget._playlist.description = this._descriptionController.text;
    //playlist.blackedGenre = this.widget._playlist.blackedGenre;
    this.widget._playlist.creator = Controller().authentificator.user;
    this.widget._playlist.playlistID = this.widget._playlist.playlistID;

    if (this._selectedImage != null) {
      this.widget._playlist.imageURL = await Controller().storage.uploadImage(this._selectedImage, 'playlist/' + this.widget._playlist.playlistID);
    }
    await Controller().firebase.updatePlaylist(this.widget._playlist);

    Controller().theming.showSnackbar(context, "Die Playlist wurde erfolgreich bearbeitet!");
    Navigator.of(context).pop();
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
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Controller().theming.primary,
              centerTitle: true,
              elevation: 0,
              title: Text("Playlist bearbeiten"),
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
        children: <Widget>[
          Container(
            height: 150,
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 15),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: this._chooseFile,
              child: (this._selectedImage == null
                  ? PlaylistAvatar(
                      this.widget._playlist,
                      width: 150,
                    )
                  : Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: Image.file(
                        this._selectedImage,
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                      ),
                    )),
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
                              setState(
                                () {
                                  this._visibleness = this._visiblenessList[t];
                                  _radioGroup = t;
                                },
                              );
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
                this._editPlaylist();
                //Navigator.of(context).pop();
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
                    "Speichern",
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
