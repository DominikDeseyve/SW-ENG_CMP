import 'package:flutter/material.dart';

class SearchPlaylist extends StatefulWidget {
  _SearchPlaylist createState() => _SearchPlaylist();
}

class _SearchPlaylist extends State<SearchPlaylist> {
  String _playlistName;
  String _typ;
  String _artist;

  void initState() {
    super.initState();
    this._playlistName = "Platte";
    this._typ = "Album";
    this._artist = "Apache 207";
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 50.0),
        alignment: Alignment.center,
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  "Suchen",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50.0, color: Color(0xFF253A4B)),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50.0),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: TextField(
                  style: TextStyle(
                      color: Colors.white, decorationColor: Colors.white),
                  autocorrect: false,
                  //textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: "Playlist eingeben",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.camera_alt, color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(10.0),
                        //color: Color(0xFF253A4B),
                        child: ListTile(
                          leading: Container(
                              width: 60.0,
                              height: 60.0,
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/playlist.jpg')))),
                          title: Container(
                            child: Text(
                              _playlistName,
                              style: TextStyle(
                                  color: Color(0xFF253A4B), fontSize: 20.0),
                            ),
                          ),
                          subtitle: Text(
                            _typ + " - " + _artist,
                            style: TextStyle(color: Color(0xFF253A4B)),
                          ),
                          trailing: Icon(
                            Icons.more_vert,
                            color: Color(0xFF253A4B),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
