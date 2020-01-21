import 'package:cmp/pages/RootScreen.dart';
import 'package:cmp/pages/home/HomeScreen.dart';
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
      case '/home':
        return HomeScreen();
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