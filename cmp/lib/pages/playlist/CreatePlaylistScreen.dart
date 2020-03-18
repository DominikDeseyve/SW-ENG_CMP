import 'dart:io';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/visibleness.dart';
import 'package:cmp/pages/navigation.dart';
import 'package:cmp/widgets/TinyLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';

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

  bool _nameError;
  bool _amountError;
  bool _descriptionError;
  //List<Genre> _blackedGenre = [];

  void initState() {
    super.initState();

    this._nameError = false;
    this._nameController = new TextEditingController();
    this._nameController.text = "";

    this._amountError = false;
    this._maxAttendeesController = new TextEditingController();
    this._maxAttendeesController.text = "";

    this._descriptionError = false;
    this._descriptionController = new TextEditingController();
    this._descriptionController.text = " ";

    _visiblenessList = <Visibleness>[
      Visibleness('PUBLIC'),
      Visibleness('PRIVATE'),
    ];
    this._visibleness = null;
  }

  void _chooseFile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
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

  Future _createPlaylist() async {
    if (this._nameError || this._amountError || this._descriptionError || this._maxAttendeesController.text.isEmpty) {
      Controller().theming.showSnackbar(context, Controller().translater.language.getLanguagePack("wrong_values"));
      return;
    }

    TinyLoader.show(context, Controller().translater.language.getLanguagePack("create_playlist_loading"));
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
    Controller().theming.showSnackbar(context, Controller().translater.language.getLanguagePack("playlist_created"));
    this.clearTextfields();
    TinyLoader.hide();
    await NestedNavigatorsBlocProvider.of(context).selectAndNavigate(
      Navigation.home,
      (navigator) => navigator.pushNamed(
        '/playlist',
        arguments: playlist.playlistID,
      ),
    );
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
                Controller().translater.language.getLanguagePack("create_playlist"),
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
                  size: 60,
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
                  color: (!this._nameError ? Controller().theming.fontPrimary : Controller().theming.fontAccent),
                  fontSize: 18,
                ),
                focusColor: Controller().theming.fontPrimary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  child: Icon(
                    Icons.group,
                    color: Controller().theming.fontPrimary,
                  ),
                ),
                Expanded(
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
                          color: Controller().theming.background,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Controller().theming.fontTertiary,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: (!this._amountError ? Controller().theming.fontPrimary : Controller().theming.fontAccent),
                        fontSize: 18,
                      ),
                      focusColor: Controller().theming.fontPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          /*Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: InkWell(
              onTap: () {
                int _selectedVisibleness;
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Platformen'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile(
                              title: Text("YouTube"),
                              groupValue: 0,
                              value: 1,
                              onChanged: (val) {
                                setState(() {
                                  // _currentIndex = val;
                                });
                              },
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text(
                              'Fertig',
                              style: TextStyle(color: Controller().theming.fontAccent),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              },
              child: Text(
                'Platform wählen',
                style: TextStyle(
                  color: (!this._amountError ? Controller().theming.fontPrimary : Controller().theming.fontAccent),
                  fontSize: 18,
                ),
              ),
            ),
          ),*/
          Container(
            margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  child: Icon(
                    Icons.music_note,
                    color: Controller().theming.fontPrimary,
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Controller().theming.background,
                    ),
                    child: DropdownButton<Visibleness>(
                      value: this._visibleness,
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.arrow_drop_down_circle,
                          color: Controller().theming.fontPrimary,
                        ),
                      ),
                      iconSize: 25,
                      hint: new Text(Controller().translater.language.getLanguagePack("type_of_playlist"),
                          style: TextStyle(
                            fontSize: 18,
                            color: Controller().theming.fontPrimary,
                          )),
                      iconEnabledColor: Controller().theming.fontPrimary,
                      isExpanded: true,
                      style: TextStyle(
                        fontSize: 18,
                        color: Controller().theming.fontPrimary,
                      ),
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (Visibleness newCat) {
                        setState(() {
                          this._visibleness = newCat;
                        });
                      },
                      items: this._visiblenessList.map((Visibleness pCategory) {
                        return DropdownMenuItem<Visibleness>(
                          value: pCategory,
                          child: Text(
                            pCategory.longValue,
                            style: TextStyle(
                              color: Controller().theming.fontPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
            child: TextField(
              onChanged: (String pText) => this._validateInput('DESCRIPTION', pText),
              maxLines: null,
              minLines: 2,
              maxLength: 300,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              style: TextStyle(
                fontSize: 18,
                color: Controller().theming.fontPrimary,
              ),
              decoration: InputDecoration(
                labelText: (this._descriptionError ? Controller().translater.language.getLanguagePack("description_invalid") : Controller().translater.language.getLanguagePack("description")),
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
                  color: (!this._descriptionError ? Controller().theming.fontPrimary : Controller().theming.fontAccent),
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
                    Controller().translater.language.getLanguagePack("create_playlist"),
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
