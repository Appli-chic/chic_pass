import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/category_service.dart';
import 'package:chicpass/service/entry_serice.dart';
import 'package:chicpass/ui/component/dialog_error.dart';
import 'package:chicpass/ui/component/generate_password_dialog.dart';
import 'package:chicpass/ui/component/input.dart';
import 'package:chicpass/ui/component/loading_dialog.dart';
import 'package:chicpass/ui/component/rounded_button.dart';
import 'package:chicpass/utils/security.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewPasswordScreen extends StatefulWidget {
  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  DataProvider _dataProvider;
  ThemeProvider _themeProvider;
  bool _isPasswordHidden = true;
  bool _isLoading = false;
  List<String> _categoryTextList = [];
  List<Category> _categories = [];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  final _loginFocus = FocusNode();
  final _passwordFocus = FocusNode();

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_dataProvider == null) {
      _dataProvider = Provider.of<DataProvider>(context, listen: true);
      _loadCategories();
    }
  }

  _loadCategories() async {
    _categories = await CategoryService.getAll(_dataProvider.vault.uid);

    List<String> categoryStringList = [];
    _categories.forEach((c) {
      categoryStringList.add(c.title);
    });

    if (categoryStringList.isNotEmpty && _categoryController.text.isEmpty) {
      _categoryController.text = categoryStringList[0];
    }

    setState(() {
      _categoryTextList = categoryStringList;
    });
  }

  _onTitleSubmitted(String text) {
    FocusScope.of(context).requestFocus(_loginFocus);
  }

  _onLoginSubmitted(String text) {
    FocusScope.of(context).requestFocus(_passwordFocus);
  }

  _onSave() async {
    var errors = List<String>();

    if (_titleController.text.isEmpty) {
      errors.add(AppTranslations.of(context).text("title_empty_error"));
    }

    if (_loginController.text.isEmpty) {
      errors.add(AppTranslations.of(context).text("login_empty_error"));
    }

    if (_passwordController.text.length < 6) {
      errors.add(AppTranslations.of(context).text("password_size_error"));
    }

    if (_categoryController.text.isEmpty) {
      errors.add(AppTranslations.of(context).text("category_empty_error"));
    }

    if (errors.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      var hashedPassword = await Security.encryptPassword(
          _dataProvider.hash, _passwordController.text);

      var entry = Entry(
        title: _titleController.text,
        login: _loginController.text,
        hash: hashedPassword,
        vaultUid: _dataProvider.vault.uid,
        categoryUid: _categories
            .where((c) => c.title == _categoryController.text)
            .toList()[0]
            .uid,
        category: _categories
            .where((c) => c.title == _categoryController.text)
            .toList()[0],
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await EntryService.save(entry);
      Navigator.pop(context, entry);
    } else {
      setState(() {
        _isLoading = false;
      });

      _displaysErrorDialog(errors);
    }
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
            AppTranslations.of(context).text("new_password_title"),
            style: TextStyle(
              color: _themeProvider.textColor,
            ),
          ),
          leading: BackButton(
            color: _themeProvider.textColor,
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Input(
                    textCapitalization: TextCapitalization.sentences,
                    textController: _titleController,
                    hint: AppTranslations.of(context).text("title"),
                    margin: EdgeInsets.only(top: 2),
                    onSubmitted: _onTitleSubmitted,
                  ),
                  Input(
                    textController: _loginController,
                    hint: AppTranslations.of(context).text("login_email"),
                    margin: EdgeInsets.only(top: 2),
                    focus: _loginFocus,
                    onSubmitted: _onLoginSubmitted,
                  ),
                  Input(
                    textController: _passwordController,
                    hint: AppTranslations.of(context).text("password"),
                    obscureText: _isPasswordHidden,
                    focus: _passwordFocus,
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
                              icon: Image.asset('assets/lullaby.png',
                                  color: _themeProvider.thirdTextColor),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return GeneratePasswordDialog(
                                      onPasswordValidated: (String password) {
                                        _passwordController.text = password;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
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
                  Input(
                    textController: _categoryController,
                    hint: AppTranslations.of(context).text("category"),
                    margin: EdgeInsets.only(top: 2),
                    fieldType: TextFieldType.select,
                    listFields: _categoryTextList,
                    singleSelectDefaultIndex:
                        _categoryTextList.indexOf(_categoryController.text),
                    singleSelectChoose: () {
                      setState(() {});
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      var category = await Navigator.pushNamed(
                          context, '/new_category_screen');

                      if (category != null) {
                        await _loadCategories();
                        _categoryController.text = (category as Category).title;
                        setState(() {});
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 16, left: 16),
                      child: Text(
                        AppTranslations.of(context).text("add_category"),
                        style: TextStyle(
                          color: _themeProvider.thirdTextColor,
                          fontSize: 17,
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
                  _onSave();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
