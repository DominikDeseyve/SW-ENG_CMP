import 'package:cmp/logic/RouteController.dart';
import 'package:cmp/pages/navigation.dart';
import 'package:flutter/material.dart';
import 'package:nested_navigators/nested_nav_item.dart';
import 'package:nested_navigators/nested_navigators.dart';

class RootScreen extends StatefulWidget {
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return NestedNavigators(
      items: {
        Navigation.home: NestedNavigatorItem(
          initialRoute: '/home',
          icon: Icons.home,
        ),
        Navigation.explore: NestedNavigatorItem(
          initialRoute: '/welcome',
          icon: Icons.search,
        ),
        Navigation.profile: NestedNavigatorItem(
          initialRoute: '/playlist/create',
          icon: Icons.add_circle,
        ),
        Navigation.settings: NestedNavigatorItem(
          initialRoute: '/login',
          icon: Icons.settings,
        ),
      },
      clearStackAfterTapOnCurrentTab: true,
      buildCustomBottomNavigationItem: (key, item, selected) {
        return Container(
          height: 50,
          child: Icon(
            item.icon,
            size: selected ? 28 : 26,
            color: selected ? Colors.redAccent : Colors.grey,
          ),
        );
      },
      generateRoute: RouteController.generateRoute,
    );
  }
}
