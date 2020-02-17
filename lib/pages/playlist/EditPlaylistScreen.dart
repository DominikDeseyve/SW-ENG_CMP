import 'dart:io';

import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/genre.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/visibleness.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPlaylistScreen extends StatefulWidget {
  _EditPlaylistScreenState createState() => _EditPlaylistScreenState();
}

class _EditPlaylistScreenState extends State<EditPlaylistScreen> {
  List<Visibleness> _visiblenessList;

  File _selectedImage;
  TextEditingController _nameController;
  TextEditingController _maxAttendeesController;
  Visibleness _visibleness;
  List<Genre> _blackedGenre = [];

  void initState() {
    super.initState();

    this._nameController = new TextEditingController();
    this._maxAttendeesController = new TextEditingController();
    _visiblenessList = <Visibleness>[
      Visibleness('PUBLIC'),
      Visibleness('PRIVATE'),
    ];
    this._visibleness = this._visiblenessList[0];
  }

  Widget _buildVisibilityDialog(BuildContext dialogContext) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(dialogContext).size.width,
            child: FlatButton(
              onPressed: () {
                this._visibleness = this._visiblenessList[0];
                Navigator.of(dialogContext).pop(null);
              },
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Text(
                this._visiblenessList[0].longValue,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Divider(),
          Container(
            width: MediaQuery.of(dialogContext).size.width,
            child: FlatButton(
              onPressed: () {
                this._visibleness = this._visiblenessList[1];
                Navigator.of(dialogContext).pop(null);
              },
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Text(
                this._visiblenessList[1].longValue,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _chooseFile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this._selectedImage = image;
    });
  }

  void _editPlaylist() async {
    Playlist playlist = new Playlist();
    playlist.name = this._nameController.text;
    playlist.maxAttendees = int.parse(this._maxAttendeesController.text);
    playlist.visibleness = this._visibleness;
    //playlist.blackedGenre = this._blackedGenre;
    playlist.creator = Controller().authentificator.user;
    playlist.playlistID = await Controller().firebase.createPlaylist(playlist);
    await Controller().firebase.joinPlaylist(playlist, Controller().authentificator.user);

    if (this._selectedImage != null) {
      playlist.imageURL = await Controller().storage.uploadImage(this._selectedImage, 'playlist/' + playlist.playlistID);
      await Controller().firebase.updatePlaylist(playlist);
    }
    Controller().theming.showSnackbar(context, "Die Playlist wurde erfolgreich bearbeitet!");
    Navigator.of(context).pushNamed('/playlist', arguments: playlist);
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
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(Colors.redAccent, 0.015, 0.015, 0.015),
            ),
          ),
          //kompletter Bildschirm
          Container(
            child: ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Material(
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    color: Colors.white,
                    child: InkWell(
                      onTap: this._chooseFile,
                      child: Image(
                        width: 150,
                        height: 150,
                        image: (this._selectedImage == null ? AssetImage('assets/images/playlist.jpg') : FileImage(this._selectedImage)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: this._nameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.title,
                        color: Colors.white,
                      ),
                      labelText: 'Name der Playlist',
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: TextFormField(
                    controller: this._maxAttendeesController,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      labelText: 'Max Anzahl an Teilnehmer',
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: RawMaterialButton(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                          constraints: BoxConstraints(),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) => _buildVisibilityDialog(dialogContext),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              this._visibleness.longValue,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /*Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.category,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/playlist/blacked-genre', arguments: this._blackedGenre).then((pBlackedGenre) {
                          setState(() {
                            this._blackedGenre = pBlackedGenre;
                          });
                        });
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          this._generateBlackedGenreLabel(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
                FlatButton(
                  padding: const EdgeInsets.all(15),
                  onPressed: this._editPlaylist,
                  color: Colors.redAccent,
                  child: Text(
                    "Speichern",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
