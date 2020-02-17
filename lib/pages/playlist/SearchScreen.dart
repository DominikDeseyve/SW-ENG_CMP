import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/Firebase.dart';
import 'package:cmp/models/song.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) async {
    List<Song> songs = await Controller().youTube.search(value);
    //Controller().soundPlayer.song = songs[0];
    songs.forEach((Song song) {
      print(song.titel);
    });
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
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
              ListView(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  primary: false,
                  shrinkWrap: true,
                  children: tempSearchStore.map((element) {
                    return builtItems(element);
                  }).toList()),
            ])));
  }
}

Widget builtItems(data) {
  return Container(
    child: ListTile(
      leading: Container(width: 60.0, height: 60.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/playlist.jpg')))),
      title: Container(
        child: Text(
          data['name'],
          style: TextStyle(color: Color(0xFF253A4B), fontSize: 20.0),
        ),
      ),
      subtitle: Text(
        "Apache",
        style: TextStyle(color: Color(0xFF253A4B)),
      ),
      trailing: Icon(
        Icons.more_vert,
        color: Color(0xFF253A4B),
      ),
    ),
  );
}

class SearchService {
  searchByName(String searchField) {
    return Firestore.instance.collection('playlist').where('searchKey', isEqualTo: searchField.substring(0, 1).toUpperCase()).getDocuments();
  }
}
