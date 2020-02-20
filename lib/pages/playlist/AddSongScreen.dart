import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddSongScreen extends StatefulWidget {
  final Playlist _playlist;
  AddSongScreen(this._playlist);

  _AddSongScreenState createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  List<Song> selectedSong = [];

  initiateSearch(String pValue) async {
    if (pValue.isEmpty) return;
    List<Song> songs = await Controller().youTube.search(pValue);
    setState(() {
      selectedSong = [];
      songs.forEach((Song song) {
        selectedSong.add(song);
      });
    });
  }

  void _saveSong(Song pSong) async {
    await Controller().firebase.createSong(this.widget._playlist, pSong);
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            child: Text(
              "Song suchen",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50.0, color: Color(0xFF253A4B)),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: TextField(
              onChanged: this.initiateSearch,
              style: TextStyle(color: Colors.white, decorationColor: Colors.white),
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: "Playlist eingeben",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: this.selectedSong.length,
            itemBuilder: (BuildContext context, int index) {
              return SongtItem(this.selectedSong[index], this._saveSong);
            },
          ),
        ],
      ),
    );
  }
}

class SongtItem extends StatelessWidget {
  final Song _song;
  final Function(Song) _saveSongCallback;
  SongtItem(this._song, this._saveSongCallback);

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this._saveSongCallback(this._song);
      },
      child: ListTile(
        leading: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(_song.imageURL),
            ),
          ),
        ),
        title: Container(
          child: Text(
            _song.titel,
            style: TextStyle(color: Color(0xFF253A4B), fontSize: 20.0),
          ),
        ),
        subtitle: Text(
          this._song.artist,
          style: TextStyle(color: Color(0xFF253A4B)),
        ),
        trailing: Icon(
          Icons.more_vert,
          color: Color(0xFF253A4B),
        ),
      ),
    );
  }
}
