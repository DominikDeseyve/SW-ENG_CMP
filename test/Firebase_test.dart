import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/genre.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/models/visibleness.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cmp/logic/Firebase.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Firebase', (){
    Controller controller = Controller();
    Firebase firebase = Firebase(controller);
    Playlist playlist = Playlist();

    playlist.playlistID = 'Test12';
    playlist.name = 'PlaylistName';
    playlist.maxAttendees = 5;
    playlist.description = 'Description';
    playlist.visibleness = Visibleness("visible");
    playlist.imageURL = '/assets/playlist.jpg';
    playlist.creator = User();
    
    test('Test if the playlist details are correctly safed', (){
      Playlist playlistCheck = Playlist();
      playlistCheck.playlistID = 'Test';
      playlistCheck.name = 'PlaylstName';
      playlistCheck.maxAttendees = 5;
      playlistCheck.description = 'Description';
      playlistCheck.visibleness = Visibleness("visible");
      playlistCheck.imageURL = '/assets/playlist.jpg';
      playlistCheck.creator = User();

      expect(playlistCheck.playlistID, playlist.playlistID);
      //firebase.createplaylist(playlist);
      //Future<Playlist> playlistCreated = firebase.getPlaylistDetails("Test");//(playlist);
      //expect(firebase.createplaylist(playlist), 'Test12');
    });
    /*test('Test if playlist is created', (){
      Future<String> playlistCreate = firebase.createPlaylist(playlist);
      Future<List<Playlist>> playlistSearch = firebase.searchPlaylist("PlaylistName");

      expect(playlistCreate, playlistSearch.toString());
    });

    test('Test if user is in database', (){
      User userCheck = User();
      userCheck.userID = "UserID";
      userCheck.username = "TestUser";
      //firebase.updateUser();
      Future<User> user = firebase.getUser("UserID");

      expect(userCheck, user);
    });*/
  });
}