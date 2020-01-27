import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SettingsState extends State<SettingsWidget>{
  final String variable;
  bool darkMode = false;

  SettingsState(this.variable);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: darkMode ? Colors.grey : Colors.white,
      appBar: AppBar(
        title: Text(variable)
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

class SettingsWidget extends StatefulWidget{
  final String variable = "Einstellungen";

  @override
  createState() => SettingsState(variable);
}