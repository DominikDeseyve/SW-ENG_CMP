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
      error = false;
      //error = true;
      //barcode = 'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      error = true;
      barcode = 'Unknown error: $e';
    }
    if (error) {
      Controller().theming.showSnackbar(context, barcode);
      return;
    }

    Navigator.of(context).pushNamed('/playlist', arguments: barcode);
  }

  void pushCachedPlaylist(Playlist pPlaylist) {
    int index = this._cachedPlaylists.indexWhere((item) => item.playlistID == pPlaylist.playlistID);
    if (index == -1) {
      this._cachedPlaylists.add(pPlaylist);
    }
  }

  void _clearTextfield() {
    setState(() {
      this._searchController.text = '';
    });
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
              title: Text(
                "Playlist suchen",
                style: TextStyle(
                  color: Controller().theming.fontSecondary,
                ),
              ),
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
        physics: NeverScrollableScrollPhysics(),
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
                decorationColor: Controller().theming.fontSecondary,
              ),
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Controller().theming.fontSecondary,
                ),
                hintText: "Playlist eingeben",
                hintStyle: TextStyle(
                  color: Controller().theming.fontSecondary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.camera_alt),
                  color: Controller().theming.fontSecondary,
                  onPressed: this.scan,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
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
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Controller().theming.fontPrimary,
                                ),
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
                                    color: Controller().theming.fontPrimary,
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
                            return PlaylistItem(this._cachedPlaylists[index], this.pushCachedPlaylist, this._clearTextfield);
                          },
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: this.selectedPlaylists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PlaylistItem(this.selectedPlaylists[index], this.pushCachedPlaylist, this._clearTextfield);
                      },
                    )),
            ],
          ),
        ],
      ),
    );
  }
}

class PlaylistItem extends StatelessWidget {
  final Playlist _playlist;
  final Function(Playlist) _pushCachedPlaylistCallback;
  final Function() _clearTextfieldCallback;
  PlaylistItem(this._playlist, this._pushCachedPlaylistCallback, this._clearTextfieldCallback);

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this._pushCachedPlaylistCallback(this._playlist);
        this._clearTextfieldCallback();
        Controller().localStorage.pushPlaylistSearch(this._playlist);
        Navigator.pushNamed(context, '/playlist', arguments: this._playlist.playlistID);
      },
      child: ListTile(
        leading: PlaylistAvatar(this._playlist),
        title: Container(
          child: Text(
            _playlist.name,
            style: TextStyle(
              color: Controller().theming.fontPrimary,
              fontSize: 20.0,
            ),
          ),
        ),
        subtitle: Text(
          "erstellt von " + this._playlist.creator.username,
          style: TextStyle(
            color: Controller().theming.fontPrimary,
          ),
        ),
        trailing: Icon(
          Icons.more_vert,
          color: Controller().theming.fontPrimary,
        ),
      ),
    );
  }
}
