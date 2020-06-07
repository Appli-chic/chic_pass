import 'dart:collection';

import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/vault.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/utils/security.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class PasswordDialog extends StatefulWidget {
  PasswordDialog({
    @required this.vault,
  });

  final Vault vault;

  @override
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  ThemeProvider _themeProvider;
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  String _error = "";

  Widget _displaysError() {
    if (_error.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 16),
        child: Text(_error),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      backgroundColor: _themeProvider.secondBackgroundColor,
      title: Text(AppTranslations.of(context).text("unlock")),
      content: Theme(
          data: ThemeData(
            primaryColor: _themeProvider.primaryColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _passwordController,
                obscureText: _isPasswordHidden,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: AppTranslations.of(context).text("password"),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: _themeProvider.secondTextColor),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
                ),
              ),
              _displaysError(),
            ],
          )),
      actions: <Widget>[
        FlatButton(
          child: Text(
            AppTranslations.of(context).text("cancel"),
            style: TextStyle(
              color: _themeProvider.primaryColor,
            ),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            AppTranslations.of(context).text("ok"),
            style: TextStyle(
              color: _themeProvider.primaryColor,
            ),
          ),
          onPressed: () async {
            var hash =
                await Security.encryptMainPassword(_passwordController.text);
            var isPasswordCorrect =
                await Security.isSignatureCorrect(hash, widget.vault.signature);

            if (isPasswordCorrect) {
              Navigator.of(context).pop();
              await Navigator.pushNamed(context, '/main_screen');
            } else {
              setState(() {
                _error = AppTranslations.of(context)
                    .text("error_incorrect_password");
              });
            }
          },
        ),
      ],
    );
  }
}
