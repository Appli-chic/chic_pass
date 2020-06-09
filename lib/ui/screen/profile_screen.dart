import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/component/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
          AppTranslations.of(context).text("profile_title"),
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          SettingItem(
            title: AppTranslations.of(context).text("account"),
            hasArrowIcon: false,
            secondaryText: "applichic@gmail.com",
          ),
          SettingItem(title: AppTranslations.of(context).text("subscriptions"), secondaryText: "Free"),
          SettingItem(title: AppTranslations.of(context).text("data")),
          SettingItem(title: AppTranslations.of(context).text("synchronize_now"), iconData: Icons.sync),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Container(
              height: 56,
              color: _themeProvider.secondBackgroundColor,
              child: Center(
                child: Text(
                  AppTranslations.of(context).text("log_out"),
                  style: TextStyle(
                    color: _themeProvider.primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
