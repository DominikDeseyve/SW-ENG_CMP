import 'package:cmp/logic/RouteController.dart';
import 'package:cmp/pages/navigation.dart';
import 'package:cmp/provider/RoleProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nested_navigators/nested_nav_bloc.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(CMP());
}

class CMP extends StatelessWidget {
  Widget build(BuildContext context) {
    return NestedNavigatorsBlocProvider(
      bloc: NestedNavigatorsBloc<Navigation>(),
      child: ChangeNotifierProvider<RoleProvider>(
        builder: (_) => RoleProvider(),
        child: MaterialApp(
          title: 'CMP',
          initialRoute: '/',
          theme: new ThemeData(fontFamily: 'Ubuntu'),
          onGenerateRoute: RouteController.generateRoute,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('de', 'DE'),
          ],
        ),
      ),
    );
  }
}
