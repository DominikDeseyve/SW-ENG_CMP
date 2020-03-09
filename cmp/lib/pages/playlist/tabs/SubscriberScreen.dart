import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/provider/RoleProvider.dart';
import 'package:cmp/widgets/UserAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class SubscriberScreen extends StatefulWidget {
  final Playlist _playlist;

  SubscriberScreen(this._playlist);

  _SubscriberScreenState createState() => _SubscriberScreenState();
}

class _SubscriberScreenState extends State<SubscriberScreen> with AutomaticKeepAliveClientMixin {
  List<User> _joinedUser = [];

  void initState() {
    super.initState();

    this._fetchRole();
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

  void _removeUser(pUser) {
    setState(() {
      this._joinedUser.removeWhere((item) => item.userID == pUser.userID);
    });
  }

  void _fetchRole() {
    Controller().firebase.getPlaylistUserRole(this.widget._playlist.playlistID, Controller().authentificator.user).then((Role pRole) {
      if (!mounted) return;
      setState(() {
        Provider.of<RoleProvider>(context).setRole(pRole);
      });
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
      onRefresh: () async {
        this._fetchSubscriber();
        this._fetchRole();
      },
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
                  this._updateUser,
                  this._removeUser,
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
            this._updateUser,
            this._removeUser,
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
  final Function(User) _removeUserCallback;

  UserItem(this._playlist, this._user, this._updateUserCallback, this._removeUserCallback);
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  void _showRemoveUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(
          Controller().translater.language.getLanguagePack("delete_user"),
        ),
        content: Text(
          Controller().translater.language.getLanguagePack("remove_user1") + this.widget._user.username + Controller().translater.language.getLanguagePack("remove_user2"),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              Controller().translater.language.getLanguagePack("yes"),
            ),
            onPressed: () async {
              Controller().firebase.leavePlaylist(this.widget._playlist, this.widget._user).then((_) {
                this.widget._removeUserCallback(this.widget._user);
                Navigator.of(dialogContext).pop();
                Controller().theming.showSnackbar(
                      context,
                      Controller().translater.language.getLanguagePack("user_deleted"),
                    );
              });
            },
          ),
          FlatButton(
            child: Text(
              Controller().translater.language.getLanguagePack("no"),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: true,
      onTap: () {},
      onLongPress: () {
        //if member want to give other roles
        if (Provider.of<RoleProvider>(context).role.role != ROLE.MEMBER) {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) => RoleDialog(this.widget._playlist, this.widget._user, this.widget._updateUserCallback),
          );
        }
      },
      child: Container(
        color: (Controller().authentificator.user.userID == this.widget._user.userID ? Colors.grey.withOpacity(0.2) : Colors.transparent),
        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
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
              (this.widget._playlist.creator.userID == this.widget._user.userID
                  ? Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.verified_user,
                        size: 25,
                        color: Colors.grey,
                      ),
                    )
                  : SizedBox.shrink()),
              (this.widget._user.role.isMaster
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.music_note,
                        size: 25,
                        color: Colors.redAccent,
                      ),
                    )
                  : SizedBox.shrink()),
              (this.widget._user.userID != Controller().authentificator.user.userID && Provider.of<RoleProvider>(context).role.role == ROLE.ADMIN
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Controller().theming.fontPrimary,
                      ),
                      onPressed: () {
                        //cant remove creator
                        if (this.widget._playlist.creator.userID != this.widget._user.userID) {
                          this._showRemoveUserDialog();
                        } else {
                          Controller().theming.showSnackbar(
                                context,
                                Controller().translater.language.getLanguagePack("user_deleted_error"),
                              );
                        }
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

    Provider.of<RoleProvider>(context).setRole(this._role);

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
            Controller().translater.language.getLanguagePack("masterdevice_text"),
            textAlign: TextAlign.center,
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
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: this._save,
                  color: Colors.redAccent,
                  child: Text(
                    Controller().translater.language.getLanguagePack("save"),
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
