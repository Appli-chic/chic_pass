import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/component/setting_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          AppTranslations.of(context).text("settings_title"),
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          SettingItem(
            title: AppTranslations.of(context).text("display"),
            secondaryText: _themeProvider.isLight
                ? AppTranslations.of(context).text("light")
                : AppTranslations.of(context).text("dark"),
            onClick: () async {
              await Navigator.pushNamed(context, '/display_screen');
            },
          ),
          SettingItem(
            title: AppTranslations.of(context).text("import_passwords"),
            onClick: () async {
              var file = await FilePicker.getFile(
                type: FileType.custom,
                allowedExtensions: ['csv'],
              );

              String contents = await file.readAsString();
            },
          ),
          SettingItem(
            title: AppTranslations.of(context).text("lock_now"),
            onClick: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
