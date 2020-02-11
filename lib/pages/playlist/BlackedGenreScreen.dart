import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/genre.dart';
import 'package:flutter/material.dart';

class BlackedGenreScreen extends StatefulWidget {
  List<Genre> _blackedGenre;
  BlackedGenreScreen(this._blackedGenre);

  _BlackedGenreScreenState createState() => _BlackedGenreScreenState();
}

class _BlackedGenreScreenState extends State<BlackedGenreScreen> {
  List<Genre> _selectedGenre = [];

  void initState() {
    super.initState();

    Controller().firebase.getGenres().then((List<Genre> pGenreList) {
      setState(() {
        this.widget._blackedGenre = pGenreList;
      });
    });
  }

  void _selectGenre(Genre pGenre) {
    if (this._selectedGenre.contains(pGenre)) {
      setState(() {
        this._selectedGenre.remove(pGenre);
      });
    } else {
      setState(() {
        this._selectedGenre.add(pGenre);
      });
    }
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
              icon: Icon(Icons.check, size: 26),
              onPressed: () {
                Navigator.of(context).pop(this._selectedGenre);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: this.widget._blackedGenre.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < this.widget._blackedGenre.length - 1) {
            return Column(
              children: <Widget>[
                GenreItem(this.widget._blackedGenre[index], this._selectedGenre.contains(this.widget._blackedGenre[index]), this._selectGenre),
                Divider(
                  height: 10,
                )
              ],
            );
          } else {
            return GenreItem(this.widget._blackedGenre[index], this._selectedGenre.contains(this.widget._blackedGenre[index]), this._selectGenre);
          }
        },
      ),
    );
  }
}

class GenreItem extends StatelessWidget {
  final Genre _genre;
  final bool _selected;
  final Function(Genre) _toggleGenreCallback;
  GenreItem(this._genre, this._selected, this._toggleGenreCallback);

  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: this._selected,
      onChanged: (bool value) {
        this._toggleGenreCallback(this._genre);
      },
      activeColor: Colors.redAccent,
      secondary: Container(
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
      title: Text(
        this._genre.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(this._genre.subname),
    );
  }
}
