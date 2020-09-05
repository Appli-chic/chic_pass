import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

var characters = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];

var numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

var specialCharacters = [
  '!',
  '@',
  '#',
  '\$',
  '%',
  '^',
  '&',
  '*',
  '(',
  ')',
  '-',
  '_',
  '+',
  '=',
  '{',
  '[',
  '}',
  ']',
  '|',
  '\\',
  ':',
  ';',
  '"',
  '\'',
  ',',
  '<',
  '.',
  '>',
  '/',
  '?',
  '`',
  '~'
];

class GeneratePasswordDialog extends StatefulWidget {
  GeneratePasswordDialog({
    this.onPasswordValidated,
  });

  final Function(String) onPasswordValidated;

  @override
  _GeneratePasswordDialogState createState() => _GeneratePasswordDialogState();
}

class _GeneratePasswordDialogState extends State<GeneratePasswordDialog> {
  ThemeProvider _themeProvider;
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = false;
  double _nbCharacters = 20;
  bool _hasNumbers = true;
  bool _hasSpecialCharacters = true;
  bool _hasInit = false;

  _generatePassword() {
    String value = "";

    for (var i = 0; i < _nbCharacters; i++) {
      value += _generateCharacter();
    }

    _passwordController.text = value;
  }

  String _generateCharacter() {
    List<String> dictionary = [];
    dictionary.addAll(characters);

    if (_hasNumbers) {
      dictionary.addAll(numbers);
    }

    if (_hasSpecialCharacters) {
      dictionary.addAll(specialCharacters);
    }

    var rng = new Random();
    var index = rng.nextInt(dictionary.length);
    return dictionary[index];
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    if (!_hasInit) {
      _generatePassword();
      _hasInit = true;
    }

    var width = MediaQuery.of(context).size.width;
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final isMobileLayout = smallestDimension < 600;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      backgroundColor: _themeProvider.secondBackgroundColor,
      title: Text(
        AppTranslations.of(context).text("generate_password"),
        style: TextStyle(
          color: _themeProvider.textColor,
        ),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: isMobileLayout ? width : 400,
          child: Theme(
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
                    hintStyle: TextStyle(
                      color: _themeProvider.secondTextColor,
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
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context).text("length"),
                        style: TextStyle(
                          color: _themeProvider.textColor,
                        ),
                      ),
                      Flexible(
                        child: Slider(
                          value: _nbCharacters,
                          min: 6,
                          max: 50,
                          activeColor: _themeProvider.primaryColor,
                          onChanged: (double value) {
                            _nbCharacters = value;
                            _generatePassword();
                            setState(() {});
                          },
                        ),
                      ),
                      Text(
                        "${_nbCharacters.toInt()}",
                        style: TextStyle(
                          color: _themeProvider.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context).text("with_numbers"),
                        style: TextStyle(
                          color: _themeProvider.textColor,
                        ),
                      ),
                      Checkbox(
                        value: _hasNumbers,
                        activeColor: _themeProvider.primaryColor,
                        onChanged: (bool value) {
                          _hasNumbers = value;
                          _generatePassword();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context)
                            .text("with_special_characters"),
                        style: TextStyle(
                          color: _themeProvider.textColor,
                        ),
                      ),
                      Checkbox(
                        value: _hasSpecialCharacters,
                        activeColor: _themeProvider.primaryColor,
                        onChanged: (bool value) {
                          _hasSpecialCharacters = value;
                          _generatePassword();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
            widget.onPasswordValidated(_passwordController.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
