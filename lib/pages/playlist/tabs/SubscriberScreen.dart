import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class SubscriberScreen extends StatefulWidget {
  final Playlist _playlist;

  SubscriberScreen(this._playlist);

  _SubscriberScreenState createState() => _SubscriberScreenState();
}

class _SubscriberScreenState extends State<SubscriberScreen> with AutomaticKeepAliveClientMixin {
  List<User> _joinedUser = [];

  void initState() {
    super.initState();

    this._fetchSubscriber();
  }

  Future<void> _fetchSubscriber() async {
    Controller().firebase.getPlaylistUser(this.widget._playlist).then((List<User> pUserList) {
      if (!mounted) return;
      setState(() {
        this._joinedUser = pUserList;
      });
    });
  }

  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Colors.redAccent,
      onRefresh: this._fetchSubscriber,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: this._joinedUser.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < this._joinedUser.length - 1) {
            return Column(
              children: <Widget>[
                UserItem(this._joinedUser[index]),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Divider(
                    thickness: 0.2,
                    color: Colors.grey,
                    height: 4,
                  ),
                ),
              ],
            );
          }
          return UserItem(this._joinedUser[index]);
        },
      ),
    );
  }

  bool get wantKeepAlive => true;
}

class UserItem extends StatefulWidget {
  final User _user;
  UserItem(this._user);
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  void _showOptionDialog() {
    HapticFeedback.vibrate();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              onPressed: () async {
                Navigator.of(dialogContext).pop(null);
              },
              child: Container(
                width: MediaQuery.of(dialogContext).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 5, bottom: 5, right: 0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.trending_up,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Text(
                            'Zum "Admin" machen',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black,
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
            FlatButton(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              onPressed: () async {
                Navigator.of(dialogContext).pop(null);
              },
              child: Container(
                width: MediaQuery.of(dialogContext).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 5, bottom: 5, right: 0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.trending_up,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Text(
                            'Zum "Master" machen',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black,
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
            FlatButton(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              onPressed: () async {
                Navigator.of(dialogContext).pop(null);
              },
              child: Container(
                width: MediaQuery.of(dialogContext).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 5, bottom: 5, right: 0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.trending_up,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Text(
                            'Zum "Member" machen',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black,
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
      onTap: () {},
      onLongPress: this._showOptionDialog,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: ListTile(
          leading: Avatar(this.widget._user),
          title: Text(
            this.widget._user.username,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                this.widget._user.role.icon,
                color: Colors.grey,
                size: 16,
              ),
              SizedBox(width: 5),
              Text(
                this.widget._user.role.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (this.widget._user.role.role != ROLE.ADMIN
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        //Controller().firebase.removeUserFromPlaylist(this.widget._user);
                      },
                    )
                  : SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
