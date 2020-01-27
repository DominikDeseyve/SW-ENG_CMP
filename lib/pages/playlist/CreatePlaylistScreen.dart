import 'dart:io';

import 'package:cmp/models/visibility.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePlaylistScreen extends StatefulWidget {
  _CreatePlaylistScreenState createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  List<Visibleness> _visiblenessList;

  File _selectedImage;
  TextEditingController _nameController;
  TextEditingController _maxAttendeesController;
  Visibleness _visibleness;

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
            color: Colors.grey.withOpacity(0.5),
            width: MediaQuery.of(dialogContext).size.width,
            child: FlatButton(
              onPressed: () {
                this._visibleness = this._visiblenessList[0];
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
          Container(
            width: MediaQuery.of(dialogContext).size.width,
            child: FlatButton(
              onPressed: () {
                this._visibleness = this._visiblenessList[1];
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.black.withOpacity(0.85),
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: new Icon(
                    Icons.playlist_add,
                    size: 28,
                    color: Colors.white,
                  ),
                  onTap: () {},
                ),
                SizedBox(width: 24.0),
                GestureDetector(
                  child: Text(
                    'Playlist erstellen',
                    style: TextStyle(fontFamily: 'Lato light', color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.more_vert, size: 26),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.2, 0.9],
            colors: [
              Colors.black87,
              Colors.black54,
            ],
          ),
        ),
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
                        );
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
            Container(
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
                      onPressed: () {},
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Blacklisted Genres",
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
            FlatButton(
              padding: const EdgeInsets.all(15),
              onPressed: () {},
              color: Colors.redAccent,
              child: Text(
                "Erstellen",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
