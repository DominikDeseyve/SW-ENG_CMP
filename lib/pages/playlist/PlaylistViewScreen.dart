import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/Request.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/widgets/PlaylistAvatar.dart';
import 'package:cmp/widgets/UserAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaylistViewScreen extends StatefulWidget {
  final String _playlistID;

  PlaylistViewScreen(this._playlistID);

  _PlaylistViewScreenState createState() => _PlaylistViewScreenState();
}

class _PlaylistViewScreenState extends State<PlaylistViewScreen> {
  Playlist _playlist;
  Request _request;
  List<User> _previewUser = [];

  void initState() {
    super.initState();
    Controller().firebase.getPlaylistDetails(this.widget._playlistID).then((Playlist pPlaylist) {
      setState(() {
        this._playlist = pPlaylist;
      });
      Controller().firebase.getPlaylistUser(this._playlist).then((List<User> pUsers) {
        setState(() {
          this._previewUser = pUsers;
        });
      });
      if (this._playlist.visibleness.key == 'PRIVATE') {
        Controller().firebase.getPlaylistRequests(this._playlist, pUser: Controller().authentificator.user).then((pList) {
          if (pList.length == 1) {
            setState(() {
              this._request = pList[0];
            });
          }
        });
      }
    });
  }

  Future<void> _fetchPlaylist() async {
    print('hier');
    if (this._playlist.visibleness.key == 'PRIVATE') {
      Controller().firebase.getPlaylistRequests(this._playlist, pUser: Controller().authentificator.user).then((pList) {
        if (pList.length == 1) {
          setState(() {
            print(pList[0]);
            this._request = pList[0];
          });
        }
      });
    }
  }

  String _getLabel() {
    if (this._playlist.visibleness.key == 'PUBLIC') {
      return "Teilnehmen";
    } else {
      if (this._request == null || this._request.status == 'DECLINE') {
        return "Anfrage senden";
      } else if (this._request.status == 'ACCEPT') {
        return "Zur Playlist";
      } else {
        return "Anfrage gesendet";
      }
    }
  }

  IconData _getIcon() {
    if (this._request == null) {
      return Icons.person_add;
    } else {
      return Icons.check;
    }
  }

  void _joinPlaylist() async {
    if (this._playlist.visibleness.key == 'PUBLIC') {
      bool success = await Controller().firebase.joinPlaylist(this._playlist, Controller().authentificator.user, Role(ROLE.MEMBER, false));
      if (success) {
        Navigator.of(context).pushReplacementNamed('/playlist', arguments: this._playlist.playlistID);
      } else {
        Controller().theming.showSnackbar(context, "Die maximale Anzahl an Teilnehmer wurde erreicht.");
      }
    } else {
      if (this._request == null || this._request.status == 'DECLINE') {
        setState(() {
          this._request = new Request('OPEN', Controller().authentificator.user);
          Controller().firebase.requestPlaylist(this._playlist, this._request);
        });
      } else if (this._request.status == 'ACCEPT') {
        Navigator.of(context).pushReplacementNamed('/playlist', arguments: this._playlist.playlistID);
      }
    }
  }

  Widget build(BuildContext context) {
    if (this._playlist == null) {
      return Container(
        color: Colors.white,
      );
    }
    return Scaffold(
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Column(
          children: <Widget>[
            AppBar(
              iconTheme: IconThemeData(
                color: Controller().theming.fontSecondary,
              ),
              backgroundColor: Controller().theming.primary,
              centerTitle: true,
              elevation: 0,
              title: Text(
                this._playlist.name,
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
      body: RefreshIndicator(
        onRefresh: this._fetchPlaylist,
        color: Controller().theming.fontAccent,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  PlaylistAvatar(
                    this._playlist,
                    width: 180,
                  ),
                  SizedBox(height: 15),
                  Text(
                    this._playlist.name,
                    style: TextStyle(
                      fontSize: 22,
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                  Text(
                    "erstellt von " + this._playlist.creator.username.toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                  (this._playlist.maxAttendees == this._playlist.joinedUserCount
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mood_bad,
                                size: 40,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Leider ist die Playlist bereits voll. \n Es tut uns sehr leid.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                          child: FlatButton(
                            onPressed: this._joinPlaylist,
                            padding: const EdgeInsets.all(10),
                            color: Controller().theming.accent,
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Icon(
                                    this._getIcon(),
                                    size: 20.0,
                                    color: Controller().theming.fontSecondary,
                                  ),
                                ),
                                Text(
                                  this._getLabel(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Controller().theming.fontSecondary,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Controller().theming.accent,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            width: 20,
                            height: 15,
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Teilnehmer",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                              color: Controller().theming.fontPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: this._previewUser.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          UserAvatar(
                            this._previewUser[index],
                            width: MediaQuery.of(context).size.width * 0.22,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            this._previewUser[index].username,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                              color: Controller().theming.fontPrimary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
