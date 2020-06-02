import 'dart:collection';

import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/vault_service.dart';
import 'package:chicpass/ui/component/dialog_error.dart';
import 'package:chicpass/ui/component/input.dart';
import 'package:chicpass/ui/component/loading_dialog.dart';
import 'package:chicpass/ui/component/rounded_button.dart';
import 'package:chicpass/utils/security.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/db/vault.dart';

class NewVaultScreen extends StatefulWidget {
  @override
  _NewVaultScreenState createState() => _NewVaultScreenState();
}

class _NewVaultScreenState extends State<NewVaultScreen> {
  ThemeProvider _themeProvider;
  bool _isPasswordHidden = true;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _isLoading = false;

  _onNameSubmitted(String text) {
    FocusScope.of(context).requestFocus(_passwordFocus);
  }

  _displaysErrorDialog(List<String> errors) {
    var errorWidgets = List<Widget>();

    for (var error in errors) {
      errorWidgets.add(
        Container(
          margin: EdgeInsets.only(top: 8),
          child: Text(error),
        ),
      );
    }

    DialogError.display(
      context,
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

  _save() async {
    var errors = List<String>();

    if (_nameController.text.isEmpty) {
      errors.add(AppTranslations.of(context).text("name_empty_error"));
    }

    if (_passwordController.text.length < 6) {
      errors.add(AppTranslations.of(context).text("password_size_error"));
    }

    if (errors.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      var mapEncryptMainPassword = HashMap<String, String>();
      mapEncryptMainPassword['security_key'] = env.securityKey;
      mapEncryptMainPassword['password'] = _passwordController.text;
      var hash =
          await compute(Security.encryptMainPassword, mapEncryptMainPassword);

      var mapSignature = HashMap<String, String>();
      mapSignature['second_security_key'] = env.secondSecurityKey;
      mapSignature['hash'] = hash;
      var signature = await compute(
          Security.encryptSignature, mapSignature);

      await VaultService.save(
        Vault(
          name: _nameController.text,
          signature: signature,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      Navigator.pop(context, true);
    } else {
      setState(() {
        _isLoading = false;
      });

      _displaysErrorDialog(errors);
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return LoadingDialog(
      isDisplayed: _isLoading,
      child: Scaffold(
        backgroundColor: _themeProvider.backgroundColor,
        appBar: AppBar(
          brightness: _themeProvider.getBrightness(),
          centerTitle: true,
          backgroundColor: _themeProvider.secondBackgroundColor,
          elevation: 0,
          title: Text(
            AppTranslations.of(context).text("new_vaults_title"),
            style: TextStyle(
              color: _themeProvider.textColor,
            ),
          ),
          leading: BackButton(
            color: _themeProvider.textColor,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Input(
                    textController: _nameController,
                    margin: EdgeInsets.only(top: 2),
                    hint: AppTranslations.of(context).text("name"),
                    onSubmitted: _onNameSubmitted,
                  ),
                  Input(
                    textController: _passwordController,
                    focus: _passwordFocus,
                    textInputAction: TextInputAction.done,
                    margin: EdgeInsets.only(top: 2),
                    hint: AppTranslations.of(context).text("password"),
                    obscureText: _isPasswordHidden,
                    suffixIconData: _isPasswordHidden
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onSuffixIconClicked: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: 16, left: 16),
                      child: Text(
                        AppTranslations.of(context)
                            .text("new_vaults_password_description"),
                        maxLines: null,
                        style: TextStyle(
                          color: _themeProvider.textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: RoundedButton(
                text: AppTranslations.of(context).text("save"),
                onClick: () {
                  _save();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
