import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/Queue.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/models/visibleness.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cmp/logic/Firebase.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Firebase', () {
    Controller controller = Controller();
    Firebase firebase = Firebase(controller);
    Playlist playlist1 = Playlist();
    Playlist playlist2 = Playlist();

    playlist1.playlistID = 'Test12';
    playlist1.name = 'PlaylistName';
    playlist1.maxAttendees = 5;
    playlist1.description = 'Description';
    playlist1.visibleness = Visibleness("visible");
    playlist1.imageURL = '/assets/playlist.jpg';
    playlist1.creator = User();

    playlist2.playlistID = 'Test1s2';
    playlist2.name = 'PlaylistName';
    playlist2.maxAttendees = 5;
    playlist2.description = 'Description';
    playlist2.visibleness = Visibleness("visible");
    playlist2.imageURL = '/assets/playlist.jpg';
    playlist2.creator = User();

    Queue queue = Queue(playlist1);

    test('Test if the playlist details are correctly safed', () {
      Stream<QuerySnapshot> s1 = firebase.getPlaylistQueue(playlist1, queue);
      Stream<QuerySnapshot> s2 = firebase.getPlaylistQueue(playlist2, queue);
      expect(s1, s2);
    });
  });
}
