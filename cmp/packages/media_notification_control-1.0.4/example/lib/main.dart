import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:media_notification_control/media_notification.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status = 'hidden';

  @override
  void initState() {
    super.initState();

    MediaNotification.setListener('pause', () {
      setState(() => status = 'pause');
    });

    MediaNotification.setListener('play', () {
      setState(() => status = 'play');
    });

    MediaNotification.setListener('next', () {
      setState(() => status = 'play');
    });

    MediaNotification.setListener('prev', () {
      setState(() => status = 'play');
    });

    MediaNotification.setListener('select', () {
      setState(() => status = 'play');
    });

    MediaNotification.setListener('retro', () {
      setState(() => status = 'play');
    });

    MediaNotification.setListener('forward', () {
      setState(() => status = 'play');
    });

    MediaNotification.setListener('close', () {
      setState(() => status = 'play');
    });
  }

  Future<void> hide() async {
    try {
      await MediaNotification.hide();
      setState(() => status = 'hidden');
    } on PlatformException {}
  }

  Future<void> show(title, author) async {
    try {
      await MediaNotification.show(title: title, author: author, backgroundColor: "0xFF000000", color: "0xFFFFFFFF");
      setState(() => status = 'play');
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
            child: Container(
          height: 250.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Text('Show notification'),
                onPressed: () => show('Title Title Title TitleTitle TitleTitle TitleTitle TitleTitle TitleTitle TitleTitle Title', 'Song author'),
              ),
              FlatButton(
                child: Text('Update notification'),
                onPressed: () => show('New title', 'New song author'),
              ),
              FlatButton(
                child: Text('Hide notification'),
                onPressed: hide,
              ),
              Text('Status: ' + status)
            ],
          ),
        )),
      ),
    );
  }
}
