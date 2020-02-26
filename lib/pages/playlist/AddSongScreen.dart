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
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Color(0xFF253A4B),
              centerTitle: true,
              elevation: 0,
              title: Text("Songs suchen"),
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
        shrinkWrap: false,
        primary: true,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
            padding: EdgeInsets.only(right: 5),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: TextField(
              onSubmitted: this.initiateSearch,
              style: TextStyle(color: Colors.white, decorationColor: Colors.white),
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: "Song eingeben",
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
              if (index < this.selectedSong.length - 1) {
                return Column(
                  children: <Widget>[
                    SongtItem(this.selectedSong[index], this._saveSong),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                      child: Divider(
                        thickness: 0.4,
                        color: Colors.grey,
                        height: 4,
                      ),
                    ),
                  ],
                );
              }
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
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
      ),
    );
  }
}
