import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SubscriberScreen extends StatefulWidget {
  final Playlist _playlist;

  SubscriberScreen(this._playlist);

  _SubscriberScreenState createState() => _SubscriberScreenState();
}

class _SubscriberScreenState extends State<SubscriberScreen> {
  List<User> _joinedUser = [];

  void initState() {
    super.initState();

    Controller().firebase.getPlaylistUser(this.widget._playlist).then((List<User> pUserList) {
      setState(() {
        this._joinedUser = pUserList;
      });
    });
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: this._joinedUser.length,
      itemBuilder: (BuildContext context, int index) {
        return UserItem(this._joinedUser[index]);
      },
    );
  }
}

class UserItem extends StatelessWidget {
  final User _user;

  UserItem(this._user);

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          //margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: (AssetImage('assets/images/playlist.jpg')),
            ),
          ),
        ),
        title: Text(
          this._user.username,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          this._user.role.name.toUpperCase(),
          style: TextStyle(fontSize: 14, color: Colors.redAccent),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(this._user.role.icon),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
