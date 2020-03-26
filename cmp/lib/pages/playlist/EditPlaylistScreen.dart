import 'dart:io';

import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/visibleness.dart';
import 'package:cmp/widgets/PlaylistAvatar.dart';
import 'package:cmp/widgets/TinyLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditPlaylistScreen extends StatefulWidget {
  final Playlist _playlist;

  EditPlaylistScreen(this._playlist);

  _EditPlaylistScreenState createState() => _EditPlaylistScreenState();
}

class _EditPlaylistScreenState extends State<EditPlaylistScreen> {
  int _radioGroup;

  File _selectedImage;
  TextEditingController _nameController;
  TextEditingController _maxAttendeesController;
  TextEditingController _descriptionController;

  Visibleness _visibleness;
  List<Visibleness> _visiblenessList;

  bool _nameError;
  bool _amountError;
  bool _descriptionError;
  void initState() {
    super.initState();
    print("INIT");
    this._nameError = false;
    this._nameController = new TextEditingController();
    this._nameController.text = this.widget._playlist.name;

    this._amountError = false;
    this._maxAttendeesController = new TextEditingController();
    this._maxAttendeesController.text = this.widget._playlist.maxAttendees.toString();

    this._descriptionError = false;
    this._descriptionController = new TextEditingController();
    this._descriptionController.text = this.widget._playlist.description;

    if (this.widget._playlist.visibleness.key == 'PUBLIC') {
      this._radioGroup = 0;
    } else {
      this._radioGroup = 1;
    }

    _visiblenessList = <Visibleness>[
      Visibleness('PUBLIC'),
      Visibleness('PRIVATE'),
    ];
    this._visibleness = this._visiblenessList[0];
  }

  void _chooseFile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      print(this._nameController.text);
      this._selectedImage = image;
    });
  }

  void _validateInput(String pField, String pText) async {
    switch (pField) {
      case 'NAME':
        setState(() {
          if (pText.length <= 4 || pText.isEmpty) {
            this._nameError = true;
          } else {
            this._nameError = false;
          }
        });
        break;
      case 'AMOUNT':
        setState(() {
          if (pText.isEmpty || int.parse(pText) == 0 || int.parse(pText) > 1000) {
            this._amountError = true;
          } else {
            this._amountError = false;
          }
        });
        break;
      case 'DESCRIPTION':
        setState(() {
          if (pText.length <= 10 || pText.isEmpty) {
            this._descriptionError = true;
          } else {
            this._descriptionError = false;
          }
        });
        break;
      default:
        break;
    }
  }

  void _editPlaylist() async {
    if (this._nameError || this._amountError || this._descriptionError) {
      Controller().theming.showSnackbar(context, Controller().translater.language.getLanguagePack("wrong_values"));
      return;
    }
    TinyLoader.show(context, Controller().translater.language.getLanguagePack("edit_playlist_loading"));
    this.widget._playlist.name = this._nameController.text;
    this.widget._playlist.maxAttendees = int.parse(this._maxAttendeesController.text);
    this.widget._playlist.visibleness = this._visibleness;
    this.widget._playlist.description = this._descriptionController.text;
    this.widget._playlist.creator = Controller().authentificator.user;
    this.widget._playlist.playlistID = this.widget._playlist.playlistID;

    if (this._selectedImage != null) {
      this.widget._playlist.imageURL = await Controller().storage.uploadImage(this._selectedImage, 'playlist/' + this.widget._playlist.playlistID);
    }
    await Controller().firebase.updatePlaylist(this.widget._playlist);
    TinyLoader.hide();
    Controller().theming.showSnackbar(context, Controller().translater.language.getLanguagePack("playlist_edited"));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    print("dispose");
    // Clean up the controller when the widget is closed
    _nameController.dispose();
    _descriptionController.dispose();
    _maxAttendeesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build here");
    print(this._nameController.text);
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
                Controller().translater.language.getLanguagePack("edit_playlist"),
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
              child: Stack(
                children: [
                  (this._selectedImage == null
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
                  Container(
                    width: 150,
                    height: 150,
                    decoration: new BoxDecoration(
                      color: Controller().theming.tertiary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Controller().theming.fontSecondary,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              onChanged: (String pText) => this._validateInput('NAME', pText),
              controller: _nameController,
              style: TextStyle(
                fontSize: 18,
                color: Controller().theming.fontPrimary,
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: (this._nameError ? Controller().translater.language.getLanguagePack("playlistname_invalid") : Controller().translater.language.getLanguagePack("name_of_playlist")),
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
                  color: (!this._nameError ? Controller().theming.fontPrimary : Colors.redAccent),
                  fontSize: 18,
                ),
                focusColor: Controller().theming.fontPrimary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              onChanged: (String pText) => this._validateInput('AMOUNT', pText),
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
                labelText: (this._amountError ? Controller().translater.language.getLanguagePack("maxmembers_invalid") : Controller().translater.language.getLanguagePack("max_members")),
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
                  color: (!this._amountError ? Controller().theming.fontPrimary : Colors.redAccent),
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
                  Controller().translater.language.getLanguagePack("type_of_playlist"),
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
                            activeColor: Controller().theming.accent,
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
                              Controller().translater.language.getLanguagePack("public"),
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
                            activeColor: Controller().theming.accent,
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
                            child: Text(
                              Controller().translater.language.getLanguagePack("private"),
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
              onChanged: (String pText) => this._validateInput('DESCRIPTION', pText),
              minLines: 3,
              maxLines: null,
              maxLength: 300,
              controller: _descriptionController,
              style: TextStyle(
                fontSize: 18,
                color: Controller().theming.fontPrimary,
              ),
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: (this._nameError ? Controller().translater.language.getLanguagePack("description_invalid") : Controller().translater.language.getLanguagePack("description")),
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
                  color: (!this._descriptionError ? Controller().theming.fontPrimary : Colors.redAccent),
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
                this._editPlaylist();
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
                    Controller().translater.language.getLanguagePack("save"),
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