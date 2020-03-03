import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class HTTP {
  static Future<String> getSoundURL(String pVideoID) async {
    String url = 'https://cmp02.herokuapp.com/api/info?url=https://www.youtube.com/watch?v=' + pVideoID + '&flatten=true';
    //url = 'http://youtube.com/get_video_info?video_id=RLWcYADoV84';
    try {
      var response = await http.get(
        Uri.encodeFull(url),
        headers: {
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        var json = JSON.jsonDecode(response.body);
        //return json['videos'][0]['url'].toString();
        return json['videos'][0]['formats'][0]['url'];
      }
    } catch (e) {
      print("NETWORK ERROR");
    }
    return '';
  }
}
