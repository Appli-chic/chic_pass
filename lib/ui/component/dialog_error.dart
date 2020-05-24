import 'package:flutter/material.dart';

import '../../localization/app_translations.dart';

class DialogError {
  static Future<void> display(
      BuildContext ctx, {
        Color backgroundColor,
        Widget body,
        List<Widget> actions,
      }) async {
    return showDialog<void>(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          backgroundColor: backgroundColor,
          title: Text(AppTranslations.of(context).text("error")),
          content: body,
          actions: actions,
        );
      },
    );
  }
}