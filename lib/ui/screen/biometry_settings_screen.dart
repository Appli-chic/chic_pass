import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BiometrySettingsScreen extends StatefulWidget {
  @override
  _BiometrySettingsScreenState createState() => _BiometrySettingsScreenState();
}

class _BiometrySettingsScreenState extends State<BiometrySettingsScreen> {
  ThemeProvider _themeProvider;
  bool _isFingerPrintActivated = false;

  @override
  void initState() {
    _loadBiometryPreferences();
    super.initState();
  }

  _loadBiometryPreferences() async {

  }

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
          AppTranslations.of(context).text("biometry"),
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
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
                      AppTranslations.of(context).text("fingerprint"),
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

                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
