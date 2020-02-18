import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/Firebase.dart';
import 'package:cmp/logic/YouTube.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song.dart';
import 'package:flutter/material.dart';

class AddSong extends StatefulWidget {
  _AddSong createState() => _AddSong();
}

class _AddSong extends State<AddSong> {
  List<Song> selectedSong = [];

  initiateSearch(value) async {
    List<Song> songs = await Controller().youTube.search(value);
    setState(() {
      selectedSong = [];
      songs.forEach((Song song) {
        print(song.titel);
        selectedSong.add(song);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            margin: EdgeInsets.only(top: 50.0),
            alignment: Alignment.center,
            child: Column(children: <Widget>[
              Container(
                child: Text(
                  "Song Suchen",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50.0, color: Color(0xFF253A4B)),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: TextField(
                  onChanged: (val) {
                    initiateSearch(val);
                  },
                  style: TextStyle(
                      color: Colors.white, decorationColor: Colors.white),
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: "Song eingeben",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.camera_alt, color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: this.selectedSong.length,
                itemBuilder: (BuildContext context, int index) {
                  return SongtItem(this.selectedSong[index]);
                },
              ),
            ])));
  }
}

class SongtItem extends StatelessWidget {
  final Song _song;
  SongtItem(this._song);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.pushNamed(context, '/playlist', arguments: _song);
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
                ))),
        title: Container(
          child: Text(
            _song.titel,
            style: TextStyle(color: Color(0xFF253A4B), fontSize: 20.0),
          ),
        ),
        subtitle: Text(
          "Song",
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
