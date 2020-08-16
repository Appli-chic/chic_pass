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

  static displaysErrorListDialog(
      List<String> errors, ThemeProvider themeProvider, BuildContext context) {
    var errorWidgets = List<Widget>();

    for (var error in errors) {
      errorWidgets.add(
        Container(
          margin: EdgeInsets.only(top: 8),
          child: Text(
            error,
            style: TextStyle(color: themeProvider.textColor),
          ),
        ),
      );
    }

    DialogMessage.display(
      context,
      themeProvider,
      body: SingleChildScrollView(
        child: ListBody(
          children: errorWidgets,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppTranslations.of(context).text("ok")),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
