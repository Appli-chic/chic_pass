import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';

import '../../localization/app_translations.dart';

class DialogMessage {
  static Future<bool> display(
    BuildContext ctx,
    ThemeProvider themeProvider, {
    Widget body,
    List<Widget> actions,
    String title,
  }) async {
    return showDialog<bool>(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          backgroundColor: themeProvider.secondBackgroundColor,
          title: Text(
            title == null ? AppTranslations.of(context).text("error") : title,
            style: TextStyle(
              color: themeProvider.textColor,
            ),
          ),
          content: body,
          actions: actions,
        );
      },
    );
  }
}
