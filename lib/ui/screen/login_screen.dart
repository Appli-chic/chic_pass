import 'package:chicpass/api/auth_api.dart';
import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/api_error.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/component/input.dart';
import 'package:chicpass/ui/component/loading_dialog.dart';
import 'package:chicpass/ui/component/rounded_button.dart';
import 'package:chicpass/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ThemeProvider _themeProvider;
  TextEditingController _emailController = TextEditingController();
  bool _isAskingCode = true;
  bool _isLoading = false;

  bool _checkEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-z"
            r"A-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  _askLoginCode() async {
    bool isValid = true;
    setState(() {
      _isLoading = true;
    });

    if (!_checkEmailValid(_emailController.text)) {
      isValid = false;
    }

    if(isValid) {
      try {
        await AuthApi.askCodeToLogin(_emailController.text);

        setState(() {
          _isAskingCode = false;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (e is ApiError) {
          if (e.code == ERROR_SERVER) {
            // Displays a message
          }
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _login() async {
    setState(() {
      _isLoading = true;
    });

    if (!_checkEmailValid(_emailController.text)) {
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
          leading: BackButton(
            color: _themeProvider.textColor,
          ),
          brightness: _themeProvider.getBrightness(),
          backgroundColor: _themeProvider.secondBackgroundColor,
          title: Text(
            AppTranslations.of(context).text("login"),
            style: TextStyle(color: _themeProvider.textColor),
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Input(
                      margin: EdgeInsets.only(top: 2),
                      textController: _emailController,
                      hint: AppTranslations.of(context).text("email"),
                      inputType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: RoundedButton(
                onClick: () {
                  if (_isAskingCode) {
                    _askLoginCode();
                  } else {
                    _login();
                  }
                },
                text: AppTranslations.of(context).text("login_button"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
