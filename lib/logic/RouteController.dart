import 'package:cmp/pages/RootScreen.dart';
import 'package:cmp/pages/home/HomeScreen.dart';
import 'package:cmp/pages/playlist/BlackedGenreScreen.dart';
import 'package:cmp/pages/playlist/CreatePlaylistScreen.dart';
import 'package:cmp/pages/playlist/PlaylistDetailScreen.dart';
import 'package:cmp/pages/playlist/PlaylistInnerScreen.dart';
import 'package:cmp/pages/playlist/PlaylistViewScreen.dart';
import 'package:cmp/pages/playlist/SearchScreen.dart';
import 'package:cmp/pages/welcome/LoginScreen.dart';
import 'package:cmp/pages/welcome/RegisterScreen.dart';
import 'package:cmp/pages/welcome/WelcomeScreen.dart';
import 'package:cmp/pages/settings/SettingsScreen.dart';
import 'package:flutter/material.dart';

class RouteController {
  static MaterialPageRoute generateRoute(RouteSettings pRouteSettings) {
    return MaterialPageRoute(
      settings: pRouteSettings,
      builder: (context) => _searchRoute(pRouteSettings),
    );
  }

  static Widget _searchRoute(RouteSettings pRouteSettings) {
    final args = pRouteSettings.arguments;
    switch (pRouteSettings.name) {
      case '/root':
        return RootScreen();
        break;
      case '/welcome':
        return Welcome();
        break;
      case '/playlist/search':
        return SearchScreen();
        break;
      case '/playlist/create':
        return CreatePlaylistScreen();
        break;
      case '/playlist/view':
        return PlaylistViewScreen(args);
        break;
      case '/playlist/innerview':
        return PlaylistInnerScreen(args);
        break;
      case '/playlist/detailview':
        return PlaylistDetailScreen(args);
        break;
      case '/playlist/blacked-genre':
        return BlackedGenreScreen(args);
        break;
      case '/login':
        return LoginPage();
        break;
      case '/register':
        return RegisterPage();
        break;
      case '/home':
        return HomeScreen();
        break;
      case '/settings':
        return SettingsScreen();
        break;
      default:
        print(pRouteSettings.name);
        return _errorRoute();
    }
  }

  static Widget _errorRoute() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text('ERROR'),
      ),
    );
  }
}
