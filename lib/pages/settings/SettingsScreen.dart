import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SettingsScreen extends StatefulWidget{
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{
  bool darkMode = false;

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: darkMode ? Colors.grey : Colors.white,
      appBar: AppBar(
        title: Text("Einstellungen")
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 30.0),
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                  color: Colors.blue,
                  child: new Text(darkMode ? 'Dark mode' : 'Light mode'),
                  onPressed: (){
                    setState((){
                      darkMode = !darkMode;
                    });
                  },
                ),
                Text(
                  "Vorname Nachname",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black87,
                  ),
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}