import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/screen/main_screen.dart';
import 'package:chicpass/ui/screen/new_password_screen.dart';
import 'package:chicpass/ui/screen/new_vault_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'localization/app_translations_delegate.dart';
import 'localization/application.dart';
import 'model/env.dart';
import 'ui/screen/new_category_screen.dart';
import 'ui/screen/vault_screen.dart';
import 'utils/sqlite.dart';

Env env = Env();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await openChicDatabase();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();

    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;

    _onLoadEnvFile();
  }

  /// Triggers when the [locale] changes
  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  /// Load the env file which contains critic data
  void _onLoadEnvFile() async {
    env = await EnvParser().load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DataProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chic Pass',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        localizationsDelegates: [
          _newLocaleDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English
          const Locale('fr', ''), // French
        ],
        initialRoute: '/',
        routes: {
          '/': (context) => VaultScreen(),
          '/new_vault': (context) => NewVaultScreen(),
          '/main_screen': (context) => MainScreen(),
          '/new_password_screen': (context) => NewPasswordScreen(),
          '/new_category_screen': (context) => NewCategoryScreen(),
        },
      ),
    );
  }
}
