import 'package:cmp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cmp/pages/playlist/CreatePlaylistScreen.dart';

void main(){
  testWidgets('Create playlist test', (WidgetTester PlaylistTester) async {
    //final cps = CreatePlaylistScreen();

    await PlaylistTester.pumpWidget(CreatePlaylistScreen());

    await PlaylistTester.tap(find.text('Playlist erstellen'));
    //await PlaylistTester.pump();

    //expect(find.text('Playlist erstellen'), findsOneWidget);


    // Aus Internet (besprechen)
    /*testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
      await tester.pumpWidget(MyWidget(title: 'T', message: 'M'));

      // Create the Finders.
      final titleFinder = find.text('T');
      final messageFinder = find.text('M');
    });*/
  });
}