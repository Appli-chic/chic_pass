import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
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
          AppTranslations.of(context).text("display"),
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
      ),
      body: Container(
        height: 56,
        margin: EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: _themeProvider.secondBackgroundColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  AppTranslations.of(context).text("light"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _themeProvider.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Switch(
                value: _themeProvider.isLight,
                onChanged: (bool value) {
                  if(value) {
                    // Light
                    _themeProvider.setTheme(0);
                  } else {
                    // Dark
                    _themeProvider.setTheme(1);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
