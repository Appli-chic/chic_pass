import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/vault_service.dart';
import 'package:chicpass/ui/component/dialog_message.dart';
import 'package:chicpass/ui/component/input.dart';
import 'package:chicpass/ui/component/loading_dialog.dart';
import 'package:chicpass/ui/component/rounded_button.dart';
import 'package:chicpass/utils/security.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/db/vault.dart';

class NewVaultScreen extends StatefulWidget {
  @override
  _NewVaultScreenState createState() => _NewVaultScreenState();
}

class _NewVaultScreenState extends State<NewVaultScreen> {
  ThemeProvider _themeProvider;
  DataProvider _dataProvider;
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
          child: Text(
            error,
            style: TextStyle(
              color: _themeProvider.textColor,
            ),
          ),
        ),
      );
    }

    DialogMessage.display(
      context,
      _themeProvider,
      body: SingleChildScrollView(
        child: ListBody(
          children: errorWidgets,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            AppTranslations.of(context).text("ok"),
          ),
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

      var signature = await Security.encryptSignature(_passwordController.text);

      await VaultService.save(
        Vault(
          name: _nameController.text,
          signature: signature,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        _dataProvider,
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
    _dataProvider = Provider.of<DataProvider>(context, listen: true);

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
                    key: const Key("input_name"),
                    textController: _nameController,
                    margin: EdgeInsets.only(top: 2),
                    hint: AppTranslations.of(context).text("name"),
                    onSubmitted: _onNameSubmitted,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  Input(
                    key: const Key("input_password"),
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
                key: const Key("save_new_vault"),
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
