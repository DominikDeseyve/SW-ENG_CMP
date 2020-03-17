import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/RouteController.dart';
import 'package:cmp/pages/navigation.dart';
import 'package:flutter/material.dart';
import 'package:nested_navigators/nested_nav_item.dart';
import 'package:nested_navigators/nested_navigators.dart';
class RootScreen extends StatefulWidget {
  final Navigation _initialNav;
  RootScreen(this._initialNav);
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return NestedNavigators(
      initialNavigatorKey: this.widget._initialNav,
      items: {
        Navigation.home: NestedNavigatorItem(
          initialRoute: '/home',
          icon: Icons.home,
        ),
        Navigation.search: NestedNavigatorItem(
          initialRoute: '/playlist/search',
          icon: Icons.search,
        ),
        Navigation.create: NestedNavigatorItem(
          initialRoute: '/playlist/create',
          icon: Icons.add_circle,
        ),
        Navigation.settings: NestedNavigatorItem(
          initialRoute: '/settings',
          icon: Icons.settings,
        ),
      },
      clearStackAfterTapOnCurrentTab: true,
      buildCustomBottomNavigationItem: (key, item, selected) {
        return Container(
          color: Controller().theming.navigation,
          height: 50,
          child: Icon(
            item.icon,
            size: selected ? 28 : 26,
            color: selected ? Controller().theming.accent : Controller().theming.tertiary,
          ),
        );
      },
      generateRoute: RouteController.generateRoute,
    );
  }
}
