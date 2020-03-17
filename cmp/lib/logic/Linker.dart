import 'package:cmp/includes.dart/Config.dart';
import 'package:cmp/models/playlist.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class Linker {
  FirebaseDynamicLinks _firebaseDynamicLinks;
  BuildContext _context;
  int _bugfix = 0;

  Linker() {
    this._firebaseDynamicLinks = FirebaseDynamicLinks.instance;
    this.listen();
  }

  Future<Uri> generateShortLink(Playlist pPlaylist) async {
    String pTitle = "CMP - Connected Music Player";
    String pDesc = "Playlist: " + pPlaylist.name;
    List<Map<String, String>> pQuery = [
      {'playlistID': pPlaylist.playlistID}
    ];

    String query = '?';
    pQuery.forEach((Map pMap) {
      query += pMap.keys.first + '=' + pMap.values.first + '&';
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // This should match firebase but without the username query param
      uriPrefix: Config.linkURL,
      // This can be whatever you want for the uri, https://yourapp.com/groupinvite?username=$userName
      link: Uri.parse(Config.linkURL + 'playlist' + query),
      androidParameters: AndroidParameters(
        packageName: Config.packageName,
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: Config.packageName,
        minimumVersion: '1',
        appStoreId: '',
      ),

      socialMetaTagParameters: SocialMetaTagParameters(
        title: pTitle,
        description: pDesc,
        imageUrl: Uri.parse('https://deseyve.com/assets/logo/full_logo.png'),
      ),
    );
    final link = await parameters.buildUrl();

    final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.values[0]),
    );
    return shortenedLink.shortUrl;
  }

  void listen() async {
    print("LISTEN");
    final PendingDynamicLinkData dynamicLink = await this._firebaseDynamicLinks.getInitialLink();
    final Uri deepLink = dynamicLink?.link;
    if (deepLink != null) {
      //on startup
      print("startup");
      switch (deepLink.path) {
        case '/playlist':
          String playlistID = deepLink.queryParameters['playlistID'];
          Navigator.of(this._context).pushNamed('/playlist', arguments: playlistID);
          break;
      }
    }

    this._firebaseDynamicLinks.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        this._bugfix++;
        if (this._bugfix % 2 != 0) return;

        //on runtime
        print("on link");
        final Uri deepLink = dynamicLink.link;
        if (deepLink != null) {
          switch (deepLink.path) {
            case '/playlist':
              String playlistID = deepLink.queryParameters['playlistID'];
              Navigator.of(this._context).pushNamed('/playlist', arguments: playlistID);
              break;
          }
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      },
    );
  }

  Future<Map<String, String>> decodeURL(String pURL) async {
    PendingDynamicLinkData data = await this._firebaseDynamicLinks.getDynamicLink(Uri.parse(pURL));
    final Uri deepLink = data?.link;
    return deepLink.queryParameters;
  }

  void setContext(BuildContext pContext) {
    this._context = pContext;
  }
}
