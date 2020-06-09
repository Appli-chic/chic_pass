import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/component/input.dart';
import 'package:chicpass/utils/security.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntryDetailsScreen extends StatefulWidget {
  @override
  _EntryDetailsScreenState createState() => _EntryDetailsScreenState();
}

class _EntryDetailsScreenState extends State<EntryDetailsScreen> {
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  ThemeProvider _themeProvider;
  DataProvider _dataProvider;
  bool _isPasswordHidden = true;
  bool _isInit = false;
  Entry _entry;
  String _passwordDecrypted = "";

  _init() async {
    _passwordDecrypted = await Security.decryptData(
        _dataProvider.hash, _entry.hash);

    _loginController.text = _entry.login;
    _passwordController.text = _passwordDecrypted;

    setState(() {
      _isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context, listen: true);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _entry = ModalRoute.of(context).settings.arguments;

    if(!_isInit) {
      _init();
    }

    return Scaffold(
      backgroundColor: _themeProvider.backgroundColor,
      appBar: AppBar(
        leading: BackButton(
          color: _themeProvider.textColor,
        ),
        brightness: _themeProvider.getBrightness(),
        backgroundColor: _themeProvider.secondBackgroundColor,
        title: Text(
          _entry.title,
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Input(
            textController: _loginController,
            hint: AppTranslations.of(context).text("login_email"),
            margin: EdgeInsets.only(top: 2),
          ),
          Input(
            textController: _passwordController,
            hint: AppTranslations.of(context).text("password"),
            obscureText: _isPasswordHidden,
            margin: EdgeInsets.only(top: 2),
            textInputAction: TextInputAction.done,
            suffix: Container(
              margin: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Material(
                    color: _themeProvider.secondBackgroundColor,
                    child: IconButton(
                      icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _themeProvider.thirdTextColor),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
