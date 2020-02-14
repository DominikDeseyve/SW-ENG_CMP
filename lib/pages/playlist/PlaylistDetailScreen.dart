import 'package:cmp/models/playlist.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaylistDetailScreen extends StatefulWidget {
  Playlist _playlist;

  PlaylistDetailScreen(this._playlist);

  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF253A4B),
          bottom: TabBar(
            indicator: BoxDecoration(),
            tabs: [
              Tab(
                text: "Details",
                icon: Icon(Icons.info),
              ),
              Tab(
                text: "Teilnehmer",
                icon: Icon(Icons.people),
              ),
              Tab(
                text: "Anfragen",
                icon: Icon(Icons.person_add),
              ),
            ],
          ),
          title: Text("Informationen zu " + this.widget._playlist.name),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              // Add box decoration
              decoration: BoxDecoration(
                // Box decoration takes a gradient
                gradient: LinearGradient(
                  // Where the linear gradient begins and ends
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.0, 1.0],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    Colors.grey[400],
                    Colors.white,
                  ],
                ),
              ),
            ),
            //kompletter Bildschirm
            Container(
              padding: EdgeInsets.only(top: 15),
              child: TabBarView(
                children: <Widget>[
                  // Details View
                  Center(
                    child: Container(
                      child: Text("Details"),
                    ),
                  ),

                  // Teilnehmer View
                  ListView(
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
                            "Admin",
                            style: TextStyle(fontSize: 14, color: Colors.redAccent),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.speaker),
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
                            "Masterdevice",
                            style: TextStyle(fontSize: 14, color: Colors.redAccent),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.star),
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
                            "Member",
                            style: TextStyle(fontSize: 14, color: Colors.redAccent),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.speaker),
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
                            "Member",
                            style: TextStyle(fontSize: 14, color: Colors.redAccent),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.speaker),
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
                            "Member",
                            style: TextStyle(fontSize: 14, color: Colors.redAccent),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.speaker),
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
                  ),

                  // Anfragen View
                  ListView(
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
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.01,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
