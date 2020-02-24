import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:flutter/material.dart';

class PlaylistSearchScreen extends StatefulWidget {
  _PlaylistSearchScreenState createState() => _PlaylistSearchScreenState();
}

class _PlaylistSearchScreenState extends State<PlaylistSearchScreen> {
  List<Playlist> selectedPlaylists = [];

  initiateSearch(String value) {
    Controller().firebase.searchPlaylist(value).then((List<Playlist> pPlaylists) {
      setState(() {
        this.selectedPlaylists = pPlaylists;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF253A4B),
          centerTitle: true,
          elevation: 0,
          title: Text("Playlist suchen"),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: MediaQuery.of(context).size.height * 0.01,
              color: Colors.redAccent,
            ),
          ),
        ),
        child: ListView(
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
                onChanged: this.initiateSearch,
                style: TextStyle(color: Colors.white, decorationColor: Colors.white),
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: "Playlist eingeben",
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    color: Colors.white,
                    onPressed: () {},
                  ),
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
          ],
        ),
      ),
    );
  }
}

class PlaylistItem extends StatelessWidget {
  final Playlist _playlist;
  PlaylistItem(this._playlist);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
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
                    image: (_playlist.imageURL == null ? AssetImage("assets/images/playlist.jpg") : NetworkImage(_playlist.imageURL)),
                    //image: Image.network(data['url']),
                  ))),
          title: Container(
            child: Text(
              _playlist.name,
              style: TextStyle(color: Color(0xFF253A4B), fontSize: 20.0),
            ),
          ),
          subtitle: Text(
            "erstellt von " + this._playlist.creator.username,
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
