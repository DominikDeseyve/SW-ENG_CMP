import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/RouteController.dart';
import 'package:cmp/pages/RootScreen.dart';
import 'package:cmp/pages/navigation.dart';
import 'package:cmp/pages/welcome/WelcomeScreen.dart';
import 'package:cmp/provider/RoleProvider.dart';
import 'package:cmp/widgets/HugeLoader.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
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
  Widget _authentificate() {
    Widget page = FutureBuilder<bool>(
      future: Controller().authentificator.authentificate(),
      builder: (BuildContext context, AsyncSnapshot<bool> isAuth) {
        switch (isAuth.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.done:
            try {
              if (isAuth.data) {
                print("dynmaic theme");
                return DynamicTheme(
                  defaultBrightness: Brightness.light,
                  data: (brightness) => new ThemeData(
                    brightness: brightness,
                  ),
                  themedWidgetBuilder: (context, theme) {
                    return RootScreen(Navigation.home);
                  },
                );
              } else {
                return Welcome();
              }
            } catch (error) {}
            break;
          default:
            break;
        }
        return HugeLoader.show();
      },
    );
    return page;
  }

  Widget build(BuildContext context) {
    return NestedNavigatorsBlocProvider(
      bloc: NestedNavigatorsBloc<Navigation>(),
      child: ChangeNotifierProvider<RoleProvider>(
        builder: (_) => RoleProvider(),
        child: MaterialApp(
          title: 'CMP',
          home: this._authentificate(),
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
