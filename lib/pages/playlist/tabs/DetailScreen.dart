import 'package:cmp/models/playlist.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final Playlist _playlist;
  DetailScreen(this._playlist);

  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Beschreibung",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Divider(
                thickness: 1.5,
                color: Color(0xFF253A4B),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  this.widget._playlist.description,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(25, 35, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Maximale Anzahl an Teilnehmer: ",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Divider(
                thickness: 1.5,
                color: Color(0xFF253A4B),
              ),
              Text(
                this.widget._playlist.maxAttendees.toString(),
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(25, 35, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Sichtbarkeit der Playlist",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Divider(
                thickness: 1.5,
                color: Color(0xFF253A4B),
              ),
              Text(
                this.widget._playlist.visibleness.longValue,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        /*
        Container(
          margin: EdgeInsets.fromLTRB(25, 30, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Blacked Genres",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Divider(
                thickness: 1.5,
                color: Color(0xFF253A4B),
              ),
            ],
          ),
        ),
        Container(
          child: ListView(
            shrinkWrap: true,
            primary: false,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (AssetImage('assets/images/playlist.jpg')),
                      ),
                    ),
                  ),
                  title: Text(
                    "Pop",
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    "Helene Fischer, ...",
                    style: TextStyle(fontSize: 14, color: Colors.redAccent),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (AssetImage('assets/images/playlist.jpg')),
                      ),
                    ),
                  ),
                  title: Text(
                    "Schlager",
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    "Helene Fischer, ...",
                    style: TextStyle(fontSize: 14, color: Colors.redAccent),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (AssetImage('assets/images/playlist.jpg')),
                      ),
                    ),
                  ),
                  title: Text(
                    "Techno",
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    "Helene Fischer, ...",
                    style: TextStyle(fontSize: 14, color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
        */
      ],
    );
  }
}
