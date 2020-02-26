import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/widgets/UserAvatar.dart';
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
                UserItem(this.widget._playlist, this._joinedUser[index]),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Divider(
                    thickness: 0.2,
                    color: Controller().theming.fontTertiary,
                    height: 4,
                  ),
                ),
              ],
            );
          }
          return UserItem(this.widget._playlist, this._joinedUser[index]);
        },
      ),
    );
  }

  bool get wantKeepAlive => true;
}

class UserItem extends StatefulWidget {
  final User _user;
  final Playlist _playlist;
  UserItem(this._playlist, this._user);
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  void _updateItem() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onLongPress: () {
        HapticFeedback.vibrate();
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) => RoleDialog(this.widget._playlist, this.widget._user, this._updateItem),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: ListTile(
          leading: UserAvatar(this.widget._user),
          title: Text(
            this.widget._user.username,
            style: TextStyle(
              fontSize: 20,
              color: Controller().theming.fontPrimary,
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                this.widget._user.role.icon,
                color: Controller().theming.fontTertiary,
                size: 16,
              ),
              SizedBox(width: 5),
              Text(
                this.widget._user.role.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: Controller().theming.fontTertiary,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (this.widget._user.role.role != ROLE.ADMIN
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Controller().theming.fontPrimary,
                      ),
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

class RoleDialog extends StatefulWidget {
  final User _user;
  final Playlist _playlist;
  final Function _updateItemCallback;
  RoleDialog(this._playlist, this._user, this._updateItemCallback);
  _RoleDialogState createState() => _RoleDialogState();
}

class _RoleDialogState extends State<RoleDialog> {
  double _roleLevel;
  Role _role;

  void initState() {
    super.initState();
    this._roleLevel = this.widget._user.role.priority.toDouble();
  }

  Widget build(BuildContext dialogContext) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(15),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  activeColor: Colors.redAccent,
                  inactiveColor: Colors.grey,
                  value: this._roleLevel,
                  min: 0,
                  max: 2,
                  divisions: 2,
                  onChanged: (double d) {
                    setState(() {
                      this._roleLevel = d;
                    });
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Role(ROLE.ADMIN).icon),
                      SizedBox(width: 5),
                      Text(
                        Role(ROLE.ADMIN).name,
                      ),
                    ],
                  ),
                  SizedBox(height: 55),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Role(ROLE.MASTER).icon),
                      SizedBox(width: 5),
                      Text(
                        Role(ROLE.MASTER).name,
                      ),
                    ],
                  ),
                  SizedBox(height: 55),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Role(ROLE.MEMBER).icon),
                      SizedBox(width: 5),
                      Text(
                        Role(ROLE.MEMBER).name,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    print(this._roleLevel.toInt());
                    switch (this._roleLevel.toInt()) {
                      case 0:
                        this._role = new Role(ROLE.MEMBER);
                        break;
                      case 1:
                        this._role = new Role(ROLE.MASTER);
                        break;
                      case 2:
                        this._role = new Role(ROLE.ADMIN);
                        break;
                    }
                    this.widget._user.role = this._role;

                    Controller().firebase.updateRole(this.widget._playlist, this.widget._user).then((_) {
                      this.widget._updateItemCallback();
                      Navigator.of(dialogContext).pop();
                    });
                  },
                  color: Colors.redAccent,
                  child: Text(
                    'Speichern',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
