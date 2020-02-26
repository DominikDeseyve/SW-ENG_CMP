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
  final Role _userRole;

  SubscriberScreen(this._playlist, this._userRole);

  _SubscriberScreenState createState() => _SubscriberScreenState();
}

class _SubscriberScreenState extends State<SubscriberScreen> with AutomaticKeepAliveClientMixin {
  List<User> _joinedUser = [];

  void initState() {
    super.initState();

    this._fetchSubscriber();
  }

  void _updateUser(User pUser) {
    setState(() {
      if (pUser.role.isMaster) {
        Iterable<User> user = this._joinedUser.where((item) => item.role.isMaster == true);
        user.forEach((User user) {
          if (user.userID != pUser.userID) {
            user.role.isMaster = false;
          }
        });
      }
      int index = this._joinedUser.indexWhere((item) => item.userID == pUser.userID);
      this._joinedUser[index] = pUser;
      this._sort();
    });
  }

  Future<void> _fetchSubscriber() async {
    Controller().firebase.getPlaylistUser(this.widget._playlist).then((List<User> pUserList) {
      if (!mounted) return;
      setState(() {
        this._joinedUser = pUserList;
      });
    });
  }

  void _sort() {
    this._joinedUser.sort((a, b) {
      return b.role.priority.compareTo(a.role.priority);
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
                UserItem(
                  this.widget._playlist,
                  this._joinedUser[index],
                  this.widget._userRole,
                  this._updateUser,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Divider(
                    thickness: 0.2,
                    color: Controller().theming.fontTertiary,
                    height: 1,
                  ),
                ),
              ],
            );
          }
          return UserItem(
            this.widget._playlist,
            this._joinedUser[index],
            this.widget._userRole,
            this._updateUser,
          );
        },
      ),
    );
  }

  bool get wantKeepAlive => true;
}

class UserItem extends StatefulWidget {
  final User _user;
  final Playlist _playlist;
  final Function(User) _updateUserCallback;
  final Role _userRole;

  UserItem(this._playlist, this._user, this._userRole, this._updateUserCallback);
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onLongPress: () {
        //if member want to give other roles
        if (this.widget._userRole.role != ROLE.MEMBER) {
          HapticFeedback.vibrate();
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) => RoleDialog(this.widget._playlist, this.widget._user, this.widget._updateUserCallback),
          );
        }
      },
      child: Container(
        color: (Controller().authentificator.user.userID == this.widget._user.userID ? Colors.grey.withOpacity(0.2) : Colors.transparent),
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
              (this.widget._user.role.isMaster
                  ? Icon(
                      Icons.music_note,
                      size: 25,
                      color: Colors.redAccent,
                    )
                  : SizedBox.shrink()),
              (this.widget._user.userID != Controller().authentificator.user.userID
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
  final Function(User) _updateUserCallback;
  RoleDialog(this._playlist, this._user, this._updateUserCallback);
  _RoleDialogState createState() => _RoleDialogState();
}

class _RoleDialogState extends State<RoleDialog> {
  double _roleLevel;
  bool _isMaster;
  Role _role;

  void initState() {
    super.initState();
    this._isMaster = this.widget._user.role.isMaster;
    this._roleLevel = (this.widget._user.role.role == ROLE.ADMIN ? 1 : 0);
  }

  void _save() {
    switch (this._roleLevel.toInt()) {
      case 0:
        this._role = new Role(ROLE.MEMBER, this._isMaster);
        break;
      case 1:
        this._role = new Role(ROLE.ADMIN, this._isMaster);
        break;
    }
    this.widget._user.role = this._role;

    Controller().firebase.updateRole(this.widget._playlist, this.widget._user).then((_) {
      this.widget._updateUserCallback(this.widget._user);
      Navigator.of(context).pop();
    });
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Role(ROLE.ADMIN, false).icon),
                      SizedBox(width: 8),
                      Text(
                        Role(ROLE.ADMIN, false).name,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Role(ROLE.MEMBER, false).icon),
                      SizedBox(width: 8),
                      Text(
                        Role(ROLE.MEMBER, false).name,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 50,
                height: 120,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    activeColor: Controller().theming.accent,
                    inactiveColor: Controller().theming.tertiary,
                    value: this._roleLevel,
                    min: 0,
                    max: 1,
                    divisions: 1,
                    onChanged: (double d) {
                      setState(() {
                        this._roleLevel = d;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0.5,
            color: Colors.black87,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.music_note),
                  SizedBox(width: 8),
                  Text('Masterdevice'),
                ],
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Switch(
                    activeColor: Controller().theming.accent,
                    inactiveTrackColor: Controller().theming.tertiary,
                    value: this._isMaster,
                    onChanged: (value) {
                      setState(() {
                        this._isMaster = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Es kann nur einen Masterdevice pro Playlist geben.',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FlatButton(
                  onPressed: this._save,
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
