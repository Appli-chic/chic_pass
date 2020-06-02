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

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      backgroundColor: _themeProvider.backgroundColor,
      title: Text(AppTranslations.of(context).text("unlock")),
      content: Container(
        child: TextField(
          controller: _passwordController,
          obscureText: _isPasswordHidden,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: AppTranslations.of(context).text("password"),
            suffixIcon: IconButton(
              icon: Icon(_isPasswordHidden
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
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppTranslations.of(context).text("cancel")),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(AppTranslations.of(context).text("ok")),
          onPressed: () async {
            var mapEncryptMainPassword = HashMap<String, String>();
            mapEncryptMainPassword['security_key'] = env.securityKey;
            mapEncryptMainPassword['password'] = _passwordController.text;
            var hash =
            await compute(Security.encryptMainPassword, mapEncryptMainPassword);

            var mapSignature = HashMap<String, String>();
            mapSignature['second_security_key'] = env.secondSecurityKey;
            mapSignature['hash_signature'] = widget.vault.signature;
            mapSignature['hash'] = hash;
            var isPasswordCorrect = await compute(
                Security.isSignatureCorrect, mapSignature);

            if (isPasswordCorrect) {
              Navigator.of(context).pop();
              await Navigator.pushNamed(context, '/main_screen');
            } else {

            }
          },
        ),
      ],
    );
  }
}