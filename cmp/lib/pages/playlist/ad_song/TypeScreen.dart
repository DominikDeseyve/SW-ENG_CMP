import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song.dart';

import 'package:cmp/widgets/SongAvatar.dart';
import 'package:flutter/material.dart';

class TypeScreen extends StatefulWidget {
  final Playlist _playlist;
  TypeScreen(this._playlist);
  _TypeScreenState createState() => _TypeScreenState();
}

class _TypeScreenState extends State<TypeScreen> {
  TextEditingController _searchController;
  List<Song> _cachedSongs = [];
  List<Song> _youtubeSongs = [];
  List<Song> _spotifySongs = [];
  List<Song> _soundCloudSongs = [];

  void initState() {
    super.initState();
    Controller().spotify.initAuthentificationToken();

    this._searchController = new TextEditingController();
    setState(() {
      this._cachedSongs = Controller().localStorage.searchedSongs;
    });
  }

  initiateSearch(String pQuery) async {
    if (pQuery.isEmpty) return;
    List<Song> ytSongs = await Controller().youTube.search(pQuery);
    setState(() {
      this._youtubeSongs = ytSongs;
    });

    List<Song> scSongs = await Controller().soundCloud.search(pQuery);
    setState(() {
      this._soundCloudSongs = scSongs;
    });

    List<Song> spSongs = await Controller().spotify.search(pQuery);
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
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Controller().theming.primary,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Controller().theming.fontSecondary,
              size: 26,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Suche nach Song, Video, URL,...",
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Controller().theming.fontSecondary,
              ),
            ),
            style: TextStyle(
              color: Controller().theming.fontSecondary,
              fontSize: 16.0,
            ),
            onSubmitted: (query) {
              this.initiateSearch(query);
            },
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  this._searchController.clear();
                  this._soundCloudSongs.clear();
                  this._spotifySongs.clear();
                  this._youtubeSongs.clear();
                });
              },
              icon: Icon(
                Icons.clear,
                color: Controller().theming.fontSecondary,
              ),
              iconSize: 20,
            ),
          ],
        ),
      ),
      body: (this._searchController.text.isEmpty
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
          : DefaultTabController(
              length: 3,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Controller().theming.tertiary.withOpacity(0.1),
                    child: TabBar(
                      labelPadding: const EdgeInsets.all(3),
                      indicatorWeight: 2.5,
                      indicatorColor: Controller().theming.fontAccent,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "YouTube",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Controller().theming.fontPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Spotify",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Controller().theming.fontPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "SoundCloud",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Controller().theming.fontPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        (this._youtubeSongs.length == 0
                            ? Center(
                                child: Text(
                                  'YouTube findet nicht keine Treffer',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: this._youtubeSongs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SongtItem(this._youtubeSongs[index], this._saveSong);
                                },
                              )),
                        (this._spotifySongs.length == 0
                            ? Center(
                                child: Text(
                                  'Spotify findet nicht keine Treffer',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: this._spotifySongs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SongtItem(this._spotifySongs[index], this._saveSong);
                                },
                              )),
                        (this._soundCloudSongs.length == 0
                            ? Center(
                                child: Text(
                                  'SoundCloud findet nicht keine Treffer',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: this._soundCloudSongs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SongtItem(this._soundCloudSongs[index], this._saveSong);
                                },
                              )),
                      ],
                    ),
                  ),
                ],
              ),
            )),
    );
  }
}

class SongtItem extends StatelessWidget {
  final Song _song;
  final Function(Song) _saveSongCallback;
  SongtItem(this._song, this._saveSongCallback);

  Widget build(BuildContext context) {
    return InkWell(
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
                    padding: const EdgeInsets.all(3),
                    decoration: new BoxDecoration(
                      color: (this._song.platform == 'SPOTIFY' ? Colors.white : Colors.redAccent),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/' + this._song.platform.toLowerCase() + '.png',
                      width: 22,
                    ),
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
    );
  }
}
