import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/component/input.dart';
import 'package:chicpass/ui/component/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  _onNameSubmitted(String text) {
    FocusScope.of(context).requestFocus(_passwordFocus);
  }

  _save() {
    if(_nameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      Navigator.pop(context);
    } else {
      // Error
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
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
    );
  }
}
