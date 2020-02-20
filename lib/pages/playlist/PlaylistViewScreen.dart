import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/Request.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaylistViewScreen extends StatefulWidget {
  final Playlist _playlist;

  PlaylistViewScreen(this._playlist);

  _PlaylistViewScreenState createState() => _PlaylistViewScreenState();
}

class _PlaylistViewScreenState extends State<PlaylistViewScreen> {
  Request _request;

  void initState() {
    super.initState();

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
      await Controller().firebase.joinPlaylist(this.widget._playlist, Controller().authentificator.user, Role(ROLE.MEMBER));
      Navigator.of(context).pushReplacementNamed('/playlist', arguments: this.widget._playlist);
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF253A4B),
          centerTitle: true,
          elevation: 0,
          title: Text(this.widget._playlist.name),
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
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 180.0,
                        height: 180.0,
                        margin: EdgeInsets.fromLTRB(0, 35, 0, 22),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (this.widget._playlist.imageURL != null ? NetworkImage(this.widget._playlist.imageURL) : AssetImage('assets/images/playlist.jpg')),
                          ),
                        ),
                      ),
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
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Teilnehmer",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Divider(
                              thickness: 1.5,
                              color: Color(0xFF253A4B),
                            ),
                          ],
                        ),
                      ),
                      GridView.count(
                        primary: false,
                        shrinkWrap: true,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1,
                        crossAxisCount: 3,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.width * 0.22,
                                width: MediaQuery.of(context).size.width * 0.22,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (AssetImage('assets/images/playlist.jpg')),
                                  ),
                                ),
                              ),
                              Text(
                                "BastiSoftware",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.width * 0.22,
                                width: MediaQuery.of(context).size.width * 0.22,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (AssetImage('assets/images/playlist.jpg')),
                                  ),
                                ),
                              ),
                              Text(
                                "DanielSoftware",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.width * 0.22,
                                width: MediaQuery.of(context).size.width * 0.22,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (AssetImage('assets/images/playlist.jpg')),
                                  ),
                                ),
                              ),
                              Text(
                                "RobinSoftware",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.width * 0.22,
                                width: MediaQuery.of(context).size.width * 0.22,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (AssetImage('assets/images/playlist.jpg')),
                                  ),
                                ),
                              ),
                              Text(
                                "DeseyveSoftware",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.width * 0.22,
                                width: MediaQuery.of(context).size.width * 0.22,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (AssetImage('assets/images/playlist.jpg')),
                                  ),
                                ),
                              ),
                              Text(
                                "FlobeSoftware",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                              ),
                            ],
                          ),
                        ],
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
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.015,
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
