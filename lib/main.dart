import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/RouteController.dart';
import 'package:cmp/pages/RootScreen.dart';
import 'package:cmp/pages/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nested_navigators/nested_nav_bloc.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';

void main() {
  runApp(CMP());
}

class CMP extends StatelessWidget {
  Widget build(BuildContext context) {
    return NestedNavigatorsBlocProvider(
      bloc: NestedNavigatorsBloc<Navigation>(),
      child: MaterialApp(
        title: 'Eventiger',
        home: RootScreen(),
        theme: ThemeData(primaryColor: Colors.blueAccent),
        onGenerateRoute: RouteController.generateRoute,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('de', 'DE'),
        ],
      ),
    );
  }
}
