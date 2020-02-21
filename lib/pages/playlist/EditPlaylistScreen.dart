import 'dart:io';

import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/genre.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/visibleness.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPlaylistScreen extends StatefulWidget {
  Playlist _playlist;

  EditPlaylistScreen(this._playlist);

  _EditPlaylistScreenState createState() => _EditPlaylistScreenState();
}

class _EditPlaylistScreenState extends State<EditPlaylistScreen> {
  int _radioGroup = 0;

  var _selectedImage;
  TextEditingController _nameController;
  TextEditingController _maxAttendeesController;
  TextEditingController _descriptionController;

  Visibleness _visibleness;
  List<Visibleness> _visiblenessList;
  //List<Genre> _blackedGenre = [];

  void initState() {
    super.initState();

    this._selectedImage = this.widget._playlist.imageURL;

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
      if (image == null) {
        var image = this.widget._playlist.imageURL;
        this._selectedImage = image;
      } else {
        this._selectedImage = image;
      }
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
      if (this._selectedImage.runtimeType == String) {
        this.widget._playlist.imageURL = this._selectedImage;
      } else {
        this.widget._playlist.imageURL = await Controller().storage.uploadImage(this._selectedImage, 'playlist/' + this.widget._playlist.playlistID);
      }

      await Controller().firebase.updatePlaylist(this.widget._playlist);
    }

    Controller().theming.showSnackbar(context, "Die Playlist wurde erfolgreich bearbeitet!");
    Navigator.of(context).pushNamed('/playlist', arguments: this.widget._playlist);
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
          title: Text("Playlist bearbeiten"),
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
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (this._selectedImage == null ? AssetImage('assets/images/playlist.jpg') : (this._selectedImage.runtimeType == String ? NetworkImage(this._selectedImage) : FileImage(this._selectedImage))),
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
                    keyboardType: TextInputType.text,
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
                                Text("öffentliche Playlist"),
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
                                Text("private Playlist"),
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
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.015,
            child: CustomPaint(
              painter: CurvePainter(Colors.redAccent, 1, 1, 1),
            ),
          ),
        ],
      ),
    );
  }
}
