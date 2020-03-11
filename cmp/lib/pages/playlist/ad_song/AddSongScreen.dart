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
  List<Song> _youtubeSongs = [];
  List<Song> _soundCloudSongs = [];
  List<Song> _spotifySongs = [];
  List<Song> _cachedSongs = [];
  TextEditingController _searchController;

  void initState() {
    super.initState();
    Controller().spotify.initAuthentificationToken();

    this._searchController = new TextEditingController();
    setState(() {
      this._cachedSongs = Controller().localStorage.searchedSongs;
    });
  }

  initiateSearch(String pValue) async {
    if (pValue.isEmpty) return;
    List<Song> ytSongs = await Controller().youTube.search(pValue);
    setState(() {
      this._youtubeSongs = ytSongs;
    });

    List<Song> scSongs = await Controller().soundCloud.search(pValue);
    setState(() {
      this._soundCloudSongs = scSongs;
    });

    List<Song> spSongs = await Controller().spotify.search(pValue);
    setState(() {
      this._spotifySongs = spSongs;
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
          InkWell(
            onTap: () {
              print("test");
              Navigator.of(context).pushNamed('/playlist/type', arguments: this.widget._playlist);
            },
            child: Container(
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
                        this._youtubeSongs.clear();
                        this._soundCloudSongs.clear();
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (this._youtubeSongs.length > 0
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                            child: Text(
                              "Spotify",
                              style: TextStyle(
                                fontSize: 20,
                                color: Controller().theming.fontPrimary,
                              ),
                            ))
                        : SizedBox.shrink()),
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: this._spotifySongs.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < this._spotifySongs.length - 1) {
                          return Column(
                            children: <Widget>[
                              SongtItem(this._spotifySongs[index], this._saveSong),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 2),
                                child: Divider(
                                  thickness: 0.4,
                                  color: Controller().theming.tertiary,
                                  height: 4,
                                ),
                              ),
                            ],
                          );
                        }
                        return SongtItem(this._spotifySongs[index], this._saveSong);
                      },
                    ),
                    (this._youtubeSongs.length > 0
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(15, 25, 10, 10),
                            child: Text(
                              "YouTube",
                              style: TextStyle(
                                fontSize: 20,
                                color: Controller().theming.fontPrimary,
                              ),
                            ))
                        : SizedBox.shrink()),
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: this._youtubeSongs.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < this._youtubeSongs.length - 1) {
                          return Column(
                            children: <Widget>[
                              SongtItem(this._youtubeSongs[index], this._saveSong),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 2),
                                child: Divider(
                                  thickness: 0.4,
                                  color: Controller().theming.tertiary,
                                  height: 4,
                                ),
                              ),
                            ],
                          );
                        }
                        return SongtItem(this._youtubeSongs[index], this._saveSong);
                      },
                    ),
                    (this._youtubeSongs.length > 0
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(15, 25, 10, 10),
                            child: Text(
                              "SoundCloud",
                              style: TextStyle(
                                fontSize: 20,
                                color: Controller().theming.fontPrimary,
                              ),
                            ))
                        : SizedBox.shrink()),
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: this._soundCloudSongs.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < this._soundCloudSongs.length - 1) {
                          return Column(
                            children: <Widget>[
                              SongtItem(this._soundCloudSongs[index], this._saveSong),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 2),
                                child: Divider(
                                  thickness: 0.4,
                                  color: Controller().theming.tertiary,
                                  height: 4,
                                ),
                              ),
                            ],
                          );
                        }
                        return SongtItem(this._soundCloudSongs[index], this._saveSong);
                      },
                    ),
                  ],
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
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              Stack(
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
                          : (this._song.platform == 'SPOTIFY'
                              ? Image.asset(
                                  'assets/icons/spotify.png',
                                  width: 20,
                                )
                              : Image.asset(
                                  'assets/icons/soundcloud.png',
                                  width: 20,
                                ))),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this._song.artist,
                      style: TextStyle(
                        fontSize: 14,
                        color: Controller().theming.fontTertiary,
                      ),
                    ),
                    Text(
                      this._song.titel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: Controller().theming.fontPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
