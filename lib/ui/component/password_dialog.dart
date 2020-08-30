import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/vault.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/utils/security.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordDialog extends StatefulWidget {
  final Vault vault;
  final Function(String) onSubmit;

  PasswordDialog({
    @required this.vault,
    this.onSubmit,
  });

  @override
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  ThemeProvider _themeProvider;
  DataProvider _dataProvider;
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

  _onSubmit() async {
    try {
      var hash = _passwordController.text;
      var isPasswordCorrect =
          await Security.isSignatureCorrect(hash, widget.vault.signature);

      if (isPasswordCorrect) {
        _dataProvider.setHash(hash);
        _dataProvider.setVault(widget.vault);

        await Navigator.pushNamed(context, '/main_screen');
        Navigator.of(context).pop();
      } else {
        setState(() {
          _error = AppTranslations.of(context).text("error_incorrect_password");
        });
      }
    } catch (e) {
      setState(() {
        _error = AppTranslations.of(context).text("error_incorrect_password");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _dataProvider = Provider.of<DataProvider>(context, listen: true);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      backgroundColor: _themeProvider.secondBackgroundColor,
      title: Text(
        AppTranslations.of(context).text("unlock"),
        style: TextStyle(color: _themeProvider.textColor),
      ),
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
                autofocus: true,
                style: TextStyle(
                  color: _themeProvider.textColor,
                ),
                decoration: InputDecoration(
                  hintText: AppTranslations.of(context).text("password"),
                  fillColor: _themeProvider.secondBackgroundColor,
                  hintStyle: TextStyle(
                    color: _themeProvider.thirdTextColor,
                  ),
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
            if (widget.onSubmit != null) {
              try {
                var isPasswordCorrect = await Security.isSignatureCorrect(
                    _passwordController.text, widget.vault.signature);

                if (isPasswordCorrect) {
                  widget.onSubmit(_passwordController.text);
                  Navigator.of(context).pop();
                }
              } catch (e) {
                setState(() {
                  _error = AppTranslations.of(context)
                      .text("error_incorrect_password");
                });
              }
            } else {
              _onSubmit();
            }
          },
        ),
      ],
    );
  }
}
