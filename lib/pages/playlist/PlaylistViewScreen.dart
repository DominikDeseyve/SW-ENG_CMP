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
  final Playlist _playlist;

  PlaylistViewScreen(this._playlist);

  _PlaylistViewScreenState createState() => _PlaylistViewScreenState();
}

class _PlaylistViewScreenState extends State<PlaylistViewScreen> {
  Request _request;
  List<User> _previewUser = [];

  void initState() {
    super.initState();

    Controller().firebase.getPlaylistUser(this.widget._playlist).then((List<User> pUsers) {
      setState(() {
        this._previewUser = pUsers;
      });
    });

    if (this.widget._playlist.visibleness.key == 'PRIVATE') {
      Controller().firebase.getPlaylistRequests(this.widget._playlist, pUser: Controller().authentificator.user).then((pList) {
        if (pList.length == 1) {
          setState(() {
            this._request = pList[0];
          });
        }
      });
    }
  }

  String _getLabel() {
    if (this.widget._playlist.visibleness.key == 'PUBLIC') {
      return "Teilnehmen";
    } else {
      if (this._request == null) {
        return "Anfrage senden";
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
    if (this.widget._playlist.visibleness.key == 'PUBLIC') {
      bool success = await Controller().firebase.joinPlaylist(this.widget._playlist, Controller().authentificator.user, Role(ROLE.MEMBER, false));
      if (success) {
        Navigator.of(context).pushReplacementNamed('/playlist', arguments: this.widget._playlist);
      } else {
        Controller().theming.showSnackbar(context, "Die maximale Anzahl an Teilnehmer wurde erreicht.");
      }
    } else {
      if (this._request == null) {
        setState(() {
          this._request = new Request('OPEN', Controller().authentificator.user);
          Controller().firebase.requestPlaylist(this.widget._playlist, this._request);
        });
      }
    }
  }

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
              title: Text(this.widget._playlist.name),
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
            margin: EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                PlaylistAvatar(
                  this.widget._playlist,
                  width: 180,
                ),
                SizedBox(height: 15),
                Text(
                  this.widget._playlist.name,
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  "erstellt von " + this.widget._playlist.creator.username.toString(),
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  child: FlatButton(
                    onPressed: this._joinPlaylist,
                    padding: const EdgeInsets.all(10),
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            this._getIcon(),
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          this._getLabel(),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
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
                            color: Colors.redAccent,
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
                        Text(
                          this._previewUser[index].username,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
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
    );
  }
}
