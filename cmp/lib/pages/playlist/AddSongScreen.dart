import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song.dart';
import 'package:cmp/widgets/SongAvatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddSongScreen extends StatefulWidget {
  final Playlist _playlist;
  AddSongScreen(this._playlist);

  _AddSongScreenState createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  List<Song> selectedSong = [];
  List<Song> _cachedSongs = [];
  TextEditingController _searchController;

  void initState() {
    super.initState();
    this._searchController = new TextEditingController();

    setState(() {
      this._cachedSongs = Controller().localStorage.searchedSongs;
    });
  }

  initiateSearch(String pValue) async {
    if (pValue.isEmpty) return;
    List<Song> songs = await Controller().youTube.search(pValue);
    setState(() {
      this.selectedSong = songs;
    });
    List<Song> songs2 = await Controller().soundCloud.search(pValue);
    songs..addAll(songs2);
    setState(() {
      this.selectedSong = songs;
    });
  }

  void _saveSong(Song pSong) async {
    await Controller().firebase.createSong(this.widget._playlist, pSong);
    Controller().theming.showSnackbar(context, Controller().translater.language.getLanguagePack("added_song") + this.widget._playlist.name);
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
              iconTheme: IconThemeData(
                color: Controller().theming.fontSecondary,
              ),
              backgroundColor: Color(0xFF253A4B),
              centerTitle: true,
              elevation: 0,
              title: Text(
                Controller().translater.language.getLanguagePack("search_song"),
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
              autofocus: true,
              controller: this._searchController,
              onSubmitted: this.initiateSearch,
              style: TextStyle(
                color: Controller().theming.fontSecondary,
                decorationColor: Controller().theming.fontSecondary,
              ),
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Controller().theming.fontSecondary,
                ),
                suffixIcon: GestureDetector(
                  child: Icon(
                    Icons.clear,
                    color: Controller().theming.fontSecondary.withOpacity(0.75),
                    size: 20,
                  ),
                  onTap: () {
                    setState(() {
                      this._searchController.clear();
                      this.selectedSong.clear();
                    });
                  },
                ),
                hintText: Controller().translater.language.getLanguagePack("enter_song"),
                hintStyle: TextStyle(
                  color: Controller().theming.fontSecondary,
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
                            Controller().translater.language.getLanguagePack("last_search"),
                            style: TextStyle(
                              fontSize: 20,
                              color: Controller().theming.fontPrimary,
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                this._cachedSongs.clear();
                                Controller().localStorage.resetSearchSongs();
                              });
                            },
                            child: Text(
                              Controller().translater.language.getLanguagePack("delete_search"),
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
                      itemCount: this._cachedSongs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SongtItem(this._cachedSongs[index], this._saveSong);
                      },
                    ),
                  ],
                )
              : ListView.builder(
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
                              color: Controller().theming.tertiary,
                              height: 4,
                            ),
                          ),
                        ],
                      );
                    }
                    return SongtItem(this.selectedSong[index], this._saveSong);
                  },
                )),
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
        onTap: () async {
          await Controller().localStorage.pushSong(this._song);
          this._saveSongCallback(this._song);
        },
        child: ListTile(
          leading: Stack(
            overflow: Overflow.visible,
            children: [
              SongAvatar(
                this._song,
              ),
              Positioned(
                bottom: -3,
                right: -3,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: new BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: (this._song.platform == 'YOUTUBE'
                      ? Image.asset(
                          'assets/icons/youtube.png',
                          width: 20,
                        )
                      : Image.asset(
                          'assets/icons/soundcloud.png',
                          width: 20,
                        )),
                ),
              ),
            ],
          ),
          title: Container(
            child: Text(
              _song.titel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Controller().theming.fontPrimary, fontSize: 20.0),
            ),
          ),
          subtitle: Text(
            this._song.artist,
            style: TextStyle(
              color: Controller().theming.fontPrimary,
            ),
          ),
          /*trailing: Icon(
            Icons.more_vert,
            color: Controller().theming.fontPrimary,
          ),*/
        ),
      ),
    );
  }
}
