import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/Firebase.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Playlist> selectedPlaylists = [];

  initiateSearch(value) async {
    /*List<Song> songs = await Controller().youTube.search(value);
    //Controller().soundPlayer.song = songs[0];
    songs.forEach((Song song) {
      print(song.titel);
    });*/
    if (value.length == 0) {
      setState(() {
        selectedPlaylists = [];
      });
    }

    SearchService().searchByName(value).then((QuerySnapshot docs) {
      print(docs.documents.length);
      setState(() {
        selectedPlaylists = [];

        for (int i = 0; i < docs.documents.length; ++i) {
          Playlist playlist = new Playlist.fromFirebase(docs.documents[i]);
          selectedPlaylists.add(playlist);
        }
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
                  "Suchen",
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
                  onChanged: (val) {
                    initiateSearch(val);
                  },
                  style: TextStyle(color: Colors.white, decorationColor: Colors.white),
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: "Playlist eingeben",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.camera_alt, color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: this.selectedPlaylists.length,
                itemBuilder: (BuildContext context, int index) {
                  return PlaylistItem(this.selectedPlaylists[index]);
                },
              ),
            ])));
  }
}

class PlaylistItem extends StatelessWidget {
  final Playlist _playlist;
  PlaylistItem(this._playlist);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/playlist', arguments: _playlist);
      },
      child: ListTile(
        leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  //image: AssetImage('assets/images/playlist.jpg')
                  image: NetworkImage(_playlist.imageURL),
                  //image: Image.network(data['url']),
                ))),
        title: Container(
          child: Text(
            _playlist.name,
            style: TextStyle(color: Color(0xFF253A4B), fontSize: 20.0),
          ),
        ),
        subtitle: Text(
          "Playlist",
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

class SearchService {
  searchByName(String searchKeyword) {
    return Firestore.instance.collection('playlist').where('keywords', arrayContains: searchKeyword).getDocuments();
  }
}
