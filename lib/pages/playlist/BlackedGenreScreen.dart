import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/genre.dart';
import 'package:flutter/material.dart';

class BlackedGenreScreen extends StatefulWidget {
  _BlackedGenreScreenState createState() => _BlackedGenreScreenState();
}

class _BlackedGenreScreenState extends State<BlackedGenreScreen> {
  List<Genre> _blackedGenre = [];

  void initState() {
    super.initState();

    Controller().firebase.getGenres().then((List<Genre> pGenreList) {
      setState(() {
        this._blackedGenre = pGenreList;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.black.withOpacity(0.85),
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Text(
                    'Blacked Genre auswählen',
                    style: TextStyle(fontFamily: 'Lato light', color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.more_vert, size: 26),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: this._blackedGenre.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < this._blackedGenre.length - 1) {
            return Column(
              children: <Widget>[
                GenreItem(this._blackedGenre[index]),
                Divider(
                  height: 10,
                )
              ],
            );
          } else {
            return GenreItem(this._blackedGenre[index]);
          }
        },
      ),
    );
  }
}

class GenreItem extends StatelessWidget {
  final Genre _genre;
  GenreItem(this._genre);

  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {},
      //selected: paints[index].selected,
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Container(
          width: 48,
          height: 48,
          padding: EdgeInsets.symmetric(vertical: 4.0),
          alignment: Alignment.center,
          child: Material(
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.white,
            child: Image(
              width: 150,
              height: 150,
              image: NetworkImage(this._genre.imageURL),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        this._genre.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(this._genre.subname),
      trailing: Icon(Icons.check_box),
    );
  }
}
