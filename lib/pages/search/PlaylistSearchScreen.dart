import 'package:barcode_scan/barcode_scan.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/widgets/PlaylistAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlaylistSearchScreen extends StatefulWidget {
  _PlaylistSearchScreenState createState() => _PlaylistSearchScreenState();
}

class _PlaylistSearchScreenState extends State<PlaylistSearchScreen> {
  List<Playlist> selectedPlaylists = [];
  List<Playlist> _cachedPlaylists = [];
  TextEditingController _searchController;
  String _barcode;

  void initState() {
    super.initState();
    this._searchController = new TextEditingController();

    this._cachedPlaylists = [];
    Future.forEach(Controller().localStorage.searchedPlaylists, (String pPlaylistID) async {
      Playlist playlist = await Controller().firebase.getPlaylistDetails(pPlaylistID);
      if (playlist != null) {
        this._cachedPlaylists.add(playlist);
      }
    }).then((_) {
      setState(() {});
    });
  }

  initiateSearch(String value) {
    Controller().firebase.searchPlaylist(value).then((List<Playlist> pPlaylists) {
      setState(() {
        this.selectedPlaylists = pPlaylists;
      });
    });
  }

  Future scan() async {
    String barcode;
    bool error = false;
    try {
      barcode = await BarcodeScanner.scan();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        barcode = 'The user did not grant the camera permission!';
      } else {
        barcode = 'Unknown error: $e';
      }
      error = true;
    } on FormatException {
      error = true;
      barcode = 'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      error = true;
      barcode = 'Unknown error: $e';
    }
    if (error) {
      Controller().theming.showSnackbar(context, barcode);
      return;
    }
    Controller().firebase.getPlaylistDetails(barcode).then((Playlist pPlaylist) {
      Navigator.of(context).pushNamed('/playlist', arguments: pPlaylist);
    });
  }

  void pushCachedPlaylist(Playlist pPlaylist) {
    this._cachedPlaylists.add(pPlaylist);
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
              title: Text("Playlist suchen"),
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
            decoration: BoxDecoration(
              color: Controller().theming.accent,
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: this.initiateSearch,
              style: TextStyle(
                color: Colors.white,
                decorationColor: Colors.white,
              ),
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: "Playlist eingeben",
                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(Icons.camera_alt),
                  color: Colors.white,
                  onPressed: this.scan,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          (this._searchController.text.isEmpty
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Letzte Suchanfragen',
                            style: TextStyle(fontSize: 20),
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                this._cachedPlaylists.clear();
                                Controller().localStorage.resetSearchPlaylist();
                              });
                            },
                            child: Text(
                              'Suchverlauf löschen',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: this._cachedPlaylists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PlaylistItem(this._cachedPlaylists[index], this.pushCachedPlaylist);
                      },
                    ),
                  ],
                )
              : ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: this.selectedPlaylists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PlaylistItem(this.selectedPlaylists[index], this.pushCachedPlaylist);
                  },
                )),
        ],
      ),
    );
  }
}

class PlaylistItem extends StatelessWidget {
  final Playlist _playlist;
  final Function(Playlist) _pushCachedPlaylistCallback;
  PlaylistItem(this._playlist, this._pushCachedPlaylistCallback);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: () {
          this._pushCachedPlaylistCallback(this._playlist);
          Controller().localStorage.pushPlaylistSearch(this._playlist);
          Navigator.pushNamed(context, '/playlist', arguments: _playlist);
        },
        child: ListTile(
          leading: PlaylistAvatar(this._playlist),
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
