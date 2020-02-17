import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeSoundPlayer {
  YouTubeSoundPlayer() {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      onReady: () {
        print('Player is ready.');
        _controller.play();
      },
    );
  }
}
