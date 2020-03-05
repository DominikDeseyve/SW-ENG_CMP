import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/modules/PaginationModule.dart';
import 'package:cmp/widgets/PlaylistAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CategoryScreen extends StatefulWidget {
  final String _category;
  CategoryScreen(this._category);
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  PaginationModule _paginationModule;
  List<Playlist> _playlists = [];
  void initState() {
    super.initState();

    this._paginationModule = new PaginationModule(this._updatePlaylist);
    this._getPlaylists();
    this._paginationModule.fetch();
  }

  void _updatePlaylist(List<Playlist> pPlaylists) {
    setState(() {
      this._playlists = pPlaylists;
    });
  }

  Future<void> _getPlaylists() async {
    switch (this.widget._category) {
      case 'ALL':
        this._paginationModule.snap = Controller().firebase.getAllPlaylists;
        break;
      case 'POPULAR':
        this._paginationModule.snap = Controller().firebase.getPopularPlaylist;
        break;
      default:
    }
  }

  String _getLabel() {
    switch (this.widget._category) {
      case 'ALL':
        return Controller().translater.language.getLanguagePack("all_playlists");
        break;
      case 'POPULAR':
        return Controller().translater.language.getLanguagePack("actual_playlists");
        break;
      default:
        return "Fail";
        break;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(63.0),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Controller().theming.primary,
              centerTitle: true,
              elevation: 0,
              title: Text(
                this._getLabel(),
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
      body: RefreshIndicator(
        onRefresh: this._getPlaylists,
        child: ListView.builder(
          controller: this._paginationModule.scrollController,
          shrinkWrap: true,
          itemCount: this._playlists.length,
          itemBuilder: (BuildContext context, int index) {
            return PlaylistItem(this._playlists.elementAt(index));
          },
        ),
      ),
    );
  }
}

class PlaylistItem extends StatelessWidget {
  final Playlist _playlist;

  PlaylistItem(this._playlist);

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
          Controller().translater.language.getLanguagePack("created_by") + this._playlist.creator.username,
          style: TextStyle(
            color: Controller().theming.fontPrimary,
          ),
        ),
        /* trailing: Icon(
          Icons.more_vert,
          color: Controller().theming.fontPrimary,
        ),*/
      ),
    );
  }
}
