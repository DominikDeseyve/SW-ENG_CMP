import 'dart:io';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/visibleness.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CreatePlaylistScreen extends StatefulWidget {
  _CreatePlaylistScreenState createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  List<Visibleness> _visiblenessList;

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

    Role role = new Role(ROLE.ADMIN, true);
    await Controller().firebase.joinPlaylist(playlist, Controller().authentificator.user, role);

    if (this._selectedImage != null) {
      playlist.imageURL = await Controller().storage.uploadImage(this._selectedImage, 'playlist/' + playlist.playlistID);
    }
    await Controller().firebase.updatePlaylist(playlist);
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
              title: Text(
                "Playlist erstellen",
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
        children: <Widget>[
          Container(
            height: 150,
            margin: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: this._chooseFile,
              child: Container(
                child: Icon(
                  Icons.add,
                  color: Controller().theming.fontSecondary,
                  size: 35,
                ),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Controller().theming.tertiary.withOpacity(0.2),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Controller().theming.tertiary.withOpacity(0.4), BlendMode.darken),
                    image: (this._selectedImage == null ? AssetImage('assets/images/default-playlist-avatar.jpg') : FileImage(this._selectedImage)),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              controller: _nameController,
              style: TextStyle(
                fontSize: 18,
                color: Controller().theming.fontPrimary,
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Name der Playlist",
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
                focusColor: Controller().theming.fontPrimary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              controller: _maxAttendeesController,
              style: TextStyle(
                fontSize: 18,
                color: Controller().theming.fontPrimary,
              ),
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              maxLength: 3,
              decoration: InputDecoration(
                counter: Offstage(),
                labelText: "max. Anzahl an Teilnehmer",
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
                focusColor: Controller().theming.fontPrimary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Controller().theming.fontPrimary,
                ),
              ),
            ),
            margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Art des Events",
                  style: TextStyle(
                    color: Controller().theming.fontPrimary,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Radio(
                            activeColor: Controller().theming.fontAccent,
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
                            child: Text(
                              "öffentliche Playlist",
                              style: TextStyle(
                                color: Controller().theming.fontPrimary,
                              ),
                            ),
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
                            activeColor: Controller().theming.fontAccent,
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
                            child: Text(
                              "private Playlist",
                              style: TextStyle(
                                color: Controller().theming.fontPrimary,
                              ),
                            ),
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
              style: TextStyle(
                fontSize: 18,
                color: Controller().theming.fontPrimary,
              ),
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Beschreibung",
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
                focusColor: Controller().theming.fontPrimary,
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
              color: Controller().theming.accent,
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Icons.done,
                      size: 20.0,
                      color: Controller().theming.fontSecondary,
                    ),
                  ),
                  Text(
                    "Playlist erstellen",
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
