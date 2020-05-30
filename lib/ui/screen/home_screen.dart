import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/component/search_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          AppTranslations.of(context).text("passwords_title"),
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SearchInput(),
          ),
        ],
      ),
    );
  }
}
