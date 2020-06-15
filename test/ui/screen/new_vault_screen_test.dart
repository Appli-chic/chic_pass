import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/localization/app_translations_delegate.dart';
import 'package:chicpass/main.dart';
import 'package:chicpass/model/env.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/screen/new_vault_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

final mockObserver = MockNavigatorObserver();
BuildContext appContext;

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
      initialRoute: '/new_vault',
      navigatorObservers: [mockObserver],
      routes: {
        '/new_vault': (context) {
          appContext = context;
          return NewVaultScreen();
        },
      },
    ),
  );
}

void main() {
  Widget app;

  setUp(() async {
    app = await initApp();
  });

  testWidgets('Validate form - Empty', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Save new vault
      expect(find.byType(AlertDialog), findsNothing);
      await tester.tap(find.byKey(Key("save_new_vault")));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(AlertDialog), findsOneWidget);

      var nameError = AppTranslations.of(appContext).text("name_empty_error");
      var passwordSizeError =
          AppTranslations.of(appContext).text("password_size_error");

      expect(find.text(nameError), findsOneWidget);
      expect(find.text(passwordSizeError), findsOneWidget);
    });
  });

  testWidgets('Validate form - Name not empty, Password Empty',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(Key("input_name")), 'test');

      // Save new vault
      expect(find.byType(AlertDialog), findsNothing);
      await tester.tap(find.byKey(Key("save_new_vault")));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(AlertDialog), findsOneWidget);

      var nameError = AppTranslations.of(appContext).text("name_empty_error");
      var passwordSizeError =
          AppTranslations.of(appContext).text("password_size_error");

      expect(find.text(nameError), findsNothing);
      expect(find.text(passwordSizeError), findsOneWidget);
    });
  });

  testWidgets('Validate form - Name not empty, Password too small',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(Key("input_name")), 'test');
      await tester.enterText(find.byKey(Key("input_password")), 'test');

      // Save new vault
      expect(find.byType(AlertDialog), findsNothing);
      await tester.tap(find.byKey(Key("save_new_vault")));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(AlertDialog), findsOneWidget);

      var nameError = AppTranslations.of(appContext).text("name_empty_error");
      var passwordSizeError =
          AppTranslations.of(appContext).text("password_size_error");

      expect(find.text(nameError), findsNothing);
      expect(find.text(passwordSizeError), findsOneWidget);
    });
  });
}
