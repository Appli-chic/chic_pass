import 'package:chicpass/localization/app_translations_delegate.dart';
import 'package:chicpass/main.dart';
import 'package:chicpass/model/env.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/screen/category_passwords_screen.dart';
import 'package:chicpass/ui/screen/entry_details_screen.dart';
import 'package:chicpass/ui/screen/main_screen.dart';
import 'package:chicpass/ui/screen/new_category_screen.dart';
import 'package:chicpass/ui/screen/new_password_screen.dart';
import 'package:chicpass/ui/screen/new_vault_screen.dart';
import 'package:chicpass/ui/screen/vault_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:provider/provider.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

final mockObserver = MockNavigatorObserver();

Future<Widget> initApp() async {
  var newLocaleDelegate = AppTranslationsDelegate(newLocale: Locale('en', ''));
  env = await EnvParser().load();

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
        newLocaleDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English
        const Locale('fr', ''), // French
      ],
      initialRoute: '/',
      navigatorObservers: [mockObserver],
      routes: {
        '/': (context) => VaultScreen(),
        '/new_vault': (context) => NewVaultScreen(),
        '/main_screen': (context) => MainScreen(),
        '/new_password_screen': (context) => NewPasswordScreen(),
        '/new_category_screen': (context) => NewCategoryScreen(),
        '/category_passwords_screen': (context) => CategoryPasswordsScreen(),
        '/entry_details_screen': (context) => EntryDetailsScreen(),
      },
    ),
  );
}

void main() {}
