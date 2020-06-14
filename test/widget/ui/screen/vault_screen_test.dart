import 'package:chicpass/localization/app_translations_delegate.dart';
import 'package:chicpass/main.dart';
import 'package:chicpass/model/env.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
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
      },
    ),
  );
}

void main() {
  Widget app;

  setUpAll(() async {
    app = await initApp();
  });

  testWidgets('Check navigation to NewVaultScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pump();

    // Test fab add button
    expect(find.byType(NewVaultScreen), findsNothing);
    await tester.tap(find.byKey(Key("add_fab")));
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));
    expect(find.byType(NewVaultScreen), findsOneWidget);

    // Test back button
    var backButton = find.byTooltip('Back');
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    verify(mockObserver.didPop(any, any));
    expect(find.byType(NewVaultScreen), findsNothing);

    // Test appbar add button
    await tester.tap(find.byKey(Key("add_appbar")));
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));
    expect(find.byType(NewVaultScreen), findsOneWidget);
  });
}
