import 'package:cmp/logic/Queue.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/models/visibleness.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Queue', () {
    Queue queue;
    Playlist playlist = Playlist();
    playlist.playlistID = 'TestQueuePlaylist';
    playlist.name = 'PlaylistName';
    playlist.maxAttendees = 2;
    playlist.description = 'Description';
    playlist.visibleness = Visibleness("v");
    playlist.imageURL = '/assets/playlist.jpg';
    playlist.creator = User();

    queue = Queue(playlist);
    test('Test if correct step size', () {
      int steps = queue.stepSize;
      expect(steps, 6);
    });
  });
}
