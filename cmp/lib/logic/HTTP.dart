import 'dart:io';
import 'dart:convert' as JSON;
import 'package:cmp/includes.dart/Config.dart';
import 'package:http/http.dart' as http;

class HTTP {
  static Future<dynamic> search(String pQuery) async {
  
    String url = Config.API_URL;

    var queryParameters = {
      'q': pQuery,
    };
    try {
      Uri uri = Uri(path: url, queryParameters: queryParameters);
      url = Uri.decodeFull(uri.toString());
      var response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (response.statusCode == 200) {
        var json = JSON.jsonDecode(response.body);
        return json;
      } else {
        print("-- SPOTIFY -- STATUS CODE ERROR (maybe limit exceeded)");
      }
    } catch (e) {
      print(e);
    }
  }
}
