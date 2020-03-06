import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/song.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/provider/RoleProvider.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:cmp/logic/Queue.dart';
import 'package:cmp/widgets/HugeLoader.dart';
import 'package:cmp/widgets/PlaylistAvatar.dart';
import 'package:cmp/widgets/SongAvatar.dart';
import 'package:cmp/widgets/TinyLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class PlaylistInnerScreen extends StatefulWidget {
  final String _playlistID;
  PlaylistInnerScreen(this._playlistID);
  _PlaylistInnerScreenState createState() => _PlaylistInnerScreenState();
}

class _PlaylistInnerScreenState extends State<PlaylistInnerScreen> {
  Playlist _playlist;
  Queue _queue;
  bool _isPlaying;
  ScrollController _scrollController;

  void initState() {
    super.initState();
    //initialize default values
    this._isPlaying = false;
    this._fetchRole();
    Controller().firebase.getPlaylistDetails(this.widget._playlistID).then((Playlist pPlaylist) {
      setState(() {
        this._playlist = pPlaylist;
      });
      this._queue = new Queue(this._playlist);
      this._queue.setCallback(this._loadMoreSongs);
    });

    Controller().soundManager.addListener(this._buildQueue);

    this._scrollController = new ScrollController();
    this._scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print("END OF SCREEN --> LOAD MORE");
        this._queue.loadMore();
      }
    });
  }

  void _fetchRole() {
    Controller().firebase.getPlaylistUserRole(this.widget._playlistID, Controller().authentificator.user).then((Role pRole) {
      if (!mounted) return;
      Provider.of<RoleProvider>(context).setRole(pRole);
    });
  }

  void _togglePlay() async {
    if (this._isPlaying) {
      Controller().theming.showSnackbar(context, 'Die Playlist "' + this._playlist.name + '" wurde angehalten!');
      Controller().soundManager.deleteQueue().then((_) {
        setState(() {
          this._isPlaying = false;
        });
      });
    } else {
      TinyLoader.show(context, "Playlist wird geladen...");
      Controller().notification.setContext(context);
      await Controller().soundManager.setQueue(this._queue, this._playlist);
      TinyLoader.hide();
      setState(() {
        this._isPlaying = true;
      });
    }
  }

  void _loadMoreSongs(QuerySnapshot pQuery) {
    if (!mounted) return;
    setState(() {
      this._isPlaying = (this._queue.currentSong != null && Controller().soundManager.currentSong != null);
    });
  }

  void _buildQueue() {
    if (!mounted) return;
    setState(() {});
  }

  void _sort() {
    setState(() {
      this._queue.sort();
    });
  }

  void _showOptionAlert(String pTitle, String pSubtitle) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(pTitle),
        content: Text(pSubtitle),
        actions: <Widget>[
          FlatButton(
            child: Text(Controller().translater.language.getLanguagePack("yes")),
            onPressed: () async {
              User user = Controller().authentificator.user;
              String userID = Controller().authentificator.user.userID;

              if (this._playlist.creator.userID == userID) {
                await Controller().firebase.deletePlaylist(this._playlist);
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(dialogContext).pop(null);
              } else {
                Controller().firebase.leavePlaylist(this._playlist, user).then((_) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(dialogContext).pop(null);
                });
              }
            },
          ),
          FlatButton(
            child: Text(Controller().translater.language.getLanguagePack("no")),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    if (this._playlist == null) {
      return HugeLoader.show();
    }

    return Scaffold(
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          iconTheme: IconThemeData(
            color: Controller().theming.fontSecondary,
          ),
          title: Text(
            this._playlist.name,
            style: TextStyle(
              color: Controller().theming.fontSecondary,
            ),
          ),
          backgroundColor: Controller().theming.primary,
          actions: <Widget>[
            (Provider.of<RoleProvider>(context).role.role == ROLE.ADMIN
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/playlist/edit', arguments: this._playlist).then((value) {
                        setState(() {});
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                    ),
                  )
                : SizedBox.shrink()),
            PopupMenuButton(
              color: Controller().theming.background,
              icon: Icon(
                Icons.more_vert,
                color: Controller().theming.fontSecondary,
              ),
              onSelected: (int pValue) {
                switch (pValue) {
                  case 1:
                    _showOptionAlert(Controller().translater.language.getLanguagePack("delete_playlist"), Controller().translater.language.getLanguagePack("delete_playlist_text"));
                    break;
                  case 2:
                    _showOptionAlert(Controller().translater.language.getLanguagePack("leave_playlist"), Controller().translater.language.getLanguagePack("leave_playlist_text"));
                    break;
                  case 3:
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) => CodeDialog(this._playlist),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                (this._playlist.creator.userID == Controller().authentificator.user.userID
                    ? PopupMenuItem(
                        value: 1,
                        child: Text(
                          Controller().translater.language.getLanguagePack("delete_playlist"),
                          style: TextStyle(
                            color: Controller().theming.fontPrimary,
                          ),
                        ),
                      )
                    : PopupMenuItem(
                        value: 2,
                        child: Text(
                          Controller().translater.language.getLanguagePack("leave_playlist"),
                          style: TextStyle(
                            color: Controller().theming.fontPrimary,
                          ),
                        ),
                      )),
                PopupMenuItem(
                  value: 3,
                  child: Text(
                    Controller().translater.language.getLanguagePack("show_code"),
                    style: TextStyle(
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: ListView(
        controller: this._scrollController,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.22,
                child: CustomPaint(
                  painter: CurvePainter(Controller().theming.accent, (0.155 / 0.22), 1, (0.155 / 0.22)),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.21,
                child: CustomPaint(
                  painter: CurvePainter(Controller().theming.primary, (0.145 / 0.21), 1, (0.145 / 0.21)),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/playlist/detailview', arguments: this._playlist).then((_) {
                    setState(() {});
                  });
                },
                child: Container(
                  height: (MediaQuery.of(context).size.height * 0.25) - 30,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                    top: 8,
                  ),
                  child: PlaylistAvatar(
                    this._playlist,
                    width: 100,
                  ),
                ),
              ),
              (Provider.of<RoleProvider>(context).role.isMaster && this._queue.length > 0
                  ? Positioned(
                      bottom: 10,
                      left: 50,
                      child: Container(
                        child: RawMaterialButton(
                          onPressed: this._togglePlay,
                          child: Icon(
                            (this._isPlaying ? Icons.stop : Icons.play_arrow),
                            size: 30,
                            color: Controller().theming.fontSecondary,
                          ),
                          shape: new CircleBorder(),
                          fillColor: Controller().theming.accent,
                          padding: const EdgeInsets.all(15.0),
                        ),
                      ),
                    )
                  : SizedBox.shrink()),
              Positioned(
                bottom: 10,
                right: 50,
                child: Container(
                  child: RawMaterialButton(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/playlist/add', arguments: this._playlist);
                      this._queue.loadMore();
                    },
                    child: Icon(
                      Icons.playlist_add,
                      size: 30,
                      color: Controller().theming.fontSecondary,
                    ),
                    shape: new CircleBorder(),
                    fillColor: Controller().theming.accent,
                    padding: const EdgeInsets.all(15.0),
                  ),
                ),
              )
            ],
          ),
          (this._queue.currentSong != null
              ? Container(
                  color: Colors.grey.withOpacity(0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 20),
                            Text(
                              Controller().translater.language.getLanguagePack("actual_play"),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Controller().theming.fontPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CurrentSongItem(this._queue.currentSong),
                    ],
                  ),
                )
              : SizedBox.shrink()),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 35, 0, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Controller().theming.accent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    width: 20,
                    height: 15,
                  ),
                  SizedBox(width: 15),
                  Text(
                    Controller().translater.language.getLanguagePack("queue") + " (" + this._queue.songs.length.toString() + ")",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          (this._queue.songs.length > 0
              ? ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: this._queue.songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SongItem(this._queue.songs[index], this._playlist, this._sort);
                  },
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 35, top: 15),
                  child: Text(
                    Controller().translater.language.getLanguagePack("no_songs"),
                    style: TextStyle(
                      fontSize: 16,
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  void dispose() {
    if (Controller().soundManager.queue != this._queue) {
      this._queue.cancel();
    }

    Controller().soundManager.removeListener(this._buildQueue);
    super.dispose();
  }
}

class SongItem extends StatefulWidget {
  final Song _song;
  final Playlist _playlist;
  final Function() _sortCallback;
  SongItem(this._song, this._playlist, this._sortCallback);
  _SongItemState createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  void initState() {
    super.initState();
  }

  void _voteUpSong() {
    String direction;
    if (this.widget._song.isDownvoting) {
      direction = 'DOWN_UP';
    } else {
      direction = 'UP';
    }
    Controller().firebase.thumbSong(this.widget._playlist, this.widget._song, direction);
    setState(() {
      Controller().authentificator.user.thumbUpSong(this.widget._song);
      this.widget._sortCallback();
    });
  }

  void _voteDownSong() {
    String direction;
    if (this.widget._song.isUpvoting) {
      direction = 'UP_DOWN';
    } else {
      direction = 'DOWN';
    }
    Controller().firebase.thumbSong(this.widget._playlist, this.widget._song, direction);
    setState(() {
      Controller().authentificator.user.thumbDownSong(this.widget._song);
      this.widget._sortCallback();
    });
  }

  void _showOptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Controller().theming.background,
        contentPadding: const EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Divider(
              height: 1,
            ),
            FlatButton(
              color: Colors.transparent,
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              onPressed: () async {
                Controller().firebase.deleteSong(this.widget._playlist, this.widget._song);
                Navigator.of(dialogContext).pop(null);
              },
              child: Container(
                width: MediaQuery.of(dialogContext).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 5, bottom: 5, right: 0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Icon(
                          Icons.close,
                          color: Controller().theming.tertiary,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Text(
                            Controller().translater.language.getLanguagePack("delete_song"),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Controller().theming.fontPrimary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: true,
      onTap: () {},
      onLongPress: () {
        if (Provider.of<RoleProvider>(context).role.role == ROLE.ADMIN ||
            Provider.of<RoleProvider>(context).role.isMaster ||
            this.widget._song.creator.userID == Controller().authentificator.user.userID) {
          this._showOptionDialog();
        }
      },
      child: Container(
        color: Controller().theming.tertiary.withOpacity(0.05),
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
                  this.widget._song,
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
                    child: (this.widget._song.platform == 'YOUTUBE'
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
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.widget._song.artist + Controller().translater.language.getLanguagePack("by") + this.widget._song.creator.username,
                    style: TextStyle(
                      fontSize: 14,
                      color: Controller().theming.fontTertiary,
                    ),
                  ),
                  Text(
                    this.widget._song.titel,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      splashFactory: null,
                      child: Icon(
                        Icons.thumb_up,
                        color: (this.widget._song.isUpvoting ? Controller().theming.accent : Controller().theming.tertiary),
                      ),
                      onTap: (this.widget._song.isUpvoting ? null : this._voteUpSong),
                    ),
                    Text(
                      this.widget._song.upvoteCount.toString(),
                      style: TextStyle(
                        color: Controller().theming.fontPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      splashFactory: null,
                      child: Icon(
                        Icons.thumb_down,
                        color: (this.widget._song.isDownvoting ? Controller().theming.accent : Controller().theming.tertiary),
                      ),
                      onTap: (this.widget._song.isDownvoting ? null : this._voteDownSong),
                    ),
                    Text(
                      this.widget._song.downvoteCount.toString(),
                      style: TextStyle(
                        color: Controller().theming.fontPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 25),
          ],
        ),
      ),
    );
  }
}

class CurrentSongItem extends StatelessWidget {
  final Song _song;
  CurrentSongItem(this._song);

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
                        : Image.asset(
                            'assets/icons/soundcloud.png',
                            width: 20,
                          )),
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
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: Controller().theming.fontPrimary),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25),
          ],
        ),
      ),
    );
  }
}

class CodeDialog extends StatefulWidget {
  final Playlist _playlist;
  CodeDialog(this._playlist);

  _CodeDialogState createState() => _CodeDialogState();
}

class _CodeDialogState extends State<CodeDialog> {
  GlobalKey globalKey = new GlobalKey();
  Future<void> _captureAndShare() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      File file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      await WcFlutterShare.share(
        sharePopupTitle: 'Playlist teilen',
        subject: this.widget._playlist.name,
        text: 'Hey du, hast Du Lust meiner Playlist auf CMP beizutreten? \n Playlist: ' +
            this.widget._playlist.name +
            '\n' +
            'Teilnehmeranzahl: ' +
            this.widget._playlist.maxAttendees.toString() +
            '\n Ich freue mich auf Dich!',
        fileName: 'image.png',
        mimeType: 'image/png',
        bytesOfFile: byteData.buffer.asUint8List(),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _captureAndOpen() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      File file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      OpenFile.open(file.path);
    } catch (e) {
      print(e.toString());
    }
  }

  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              this.widget._playlist.name,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: RepaintBoundary(
                      key: globalKey,
                      child: QrImage(
                        data: this.widget._playlist.playlistID,
                        backgroundColor: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.70,
                        gapless: true,
                        foregroundColor: Colors.black87,
                        onError: (ex) {
                          print("[QR] ERROR - $ex");
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  color: Colors.grey,
                  iconSize: 26,
                  onPressed: () {
                    _captureAndShare();
                  },
                  icon: Icon(Icons.share),
                ),
                IconButton(
                  color: Colors.grey,
                  iconSize: 26,
                  onPressed: () {
                    _captureAndOpen();
                  },
                  icon: Icon(Icons.open_in_new),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
