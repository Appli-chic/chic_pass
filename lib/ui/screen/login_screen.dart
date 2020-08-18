import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: _themeProvider.backgroundColor,
      appBar: AppBar(
        leading: BackButton(
          color: _themeProvider.textColor,
        ),
        brightness: _themeProvider.getBrightness(),
        backgroundColor: _themeProvider.secondBackgroundColor,
        title: Text(
          AppTranslations.of(context).text("login"),
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GoogleSignInButton(
              onPressed: () {},
              darkMode: !_themeProvider.isLight,
            ),
            AppleSignInButton(
              onPressed: () {},
              style: _themeProvider.isLight
                  ? AppleButtonStyle.black
                  : AppleButtonStyle.white,
            ),
          ],
        ),
      ),
    );
  }
}
