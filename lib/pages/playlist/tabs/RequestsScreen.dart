import 'package:cmp/models/playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RequestScreen extends StatefulWidget {
  Playlist _playlist;

  RequestScreen(this._playlist);

  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
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
              "DeseyveSoftware",
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              "Irgendeine Info",
              style: TextStyle(fontSize: 14, color: Colors.redAccent),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Container(
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
              "RobinSoftware",
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              "Irgendeine Info",
              style: TextStyle(fontSize: 14, color: Colors.redAccent),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Container(
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
              "FlobeSoftware",
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              "Irgendeine Info",
              style: TextStyle(fontSize: 14, color: Colors.redAccent),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Container(
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
              "DanielSoftware",
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              "Irgendeine Info",
              style: TextStyle(fontSize: 14, color: Colors.redAccent),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Container(
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
              "BastiSoftware",
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              "Irgendeine Info",
              style: TextStyle(fontSize: 14, color: Colors.redAccent),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
