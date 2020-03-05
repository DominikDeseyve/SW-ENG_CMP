import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/widgets/UserAvatar.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final Playlist _playlist;
  DetailScreen(this._playlist);

  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                          Controller().translater.language.getLanguagePack("description"),
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
                Padding(
                  padding: EdgeInsets.only(left: 35, top: 10),
                  child: Text(
                    this.widget._playlist.description,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                          Controller().translater.language.getLanguagePack("max_members"),
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
                Padding(
                  padding: EdgeInsets.only(left: 35, top: 10),
                  child: Text(
                    this.widget._playlist.maxAttendees.toString() + ' ' + Controller().translater.language.getLanguagePack("members"),
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                          Controller().translater.language.getLanguagePack("visibility"),
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
                Padding(
                  padding: EdgeInsets.only(left: 35, top: 10),
                  child: Text(
                    this.widget._playlist.visibleness.longValue,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          color: Controller().theming.tertiary.withOpacity(0.1),
          child: ListTile(
            leading: UserAvatar(this.widget._playlist.creator),
            title: Text(
              Controller().translater.language.getLanguagePack("created_by") + this.widget._playlist.creator.username,
              style: TextStyle(
                fontSize: 18,
                color: Controller().theming.fontPrimary,
              ),
            ),
            subtitle: Text(
              this.widget._playlist.createdAtString,
              style: TextStyle(
                color: Controller().theming.fontTertiary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
