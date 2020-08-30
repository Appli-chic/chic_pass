import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/category_service.dart';
import 'package:chicpass/service/entry_service.dart';
import 'package:chicpass/ui/component/dialog_message.dart';
import 'package:chicpass/ui/component/generate_password_dialog.dart';
import 'package:chicpass/ui/component/input.dart';
import 'package:chicpass/ui/component/loading_dialog.dart';
import 'package:chicpass/ui/component/rounded_button.dart';
import 'package:chicpass/utils/security.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EntryDetailsScreen extends StatefulWidget {
  @override
  _EntryDetailsScreenState createState() => _EntryDetailsScreenState();
}

class _EntryDetailsScreenState extends State<EntryDetailsScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  final _loginFocus = FocusNode();
  final _passwordFocus = FocusNode();

  ThemeProvider _themeProvider;
  DataProvider _dataProvider;

  List<String> _categoryTextList = [];
  List<Category> _categories = [];
  bool _isPasswordHidden = true;
  bool _isInit = false;
  bool _isEditing = false;
  bool _isLoading = false;
  Entry _entry;
  String _passwordDecrypted = "";

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_dataProvider == null) {
      _dataProvider = Provider.of<DataProvider>(context, listen: true);
      _loadCategories();
    }
  }

  _loadCategories() async {
    _categories = await CategoryService.getAllByVault(_dataProvider.vault.uid);

    List<String> categoryStringList = [];
    _categories.forEach((c) {
      categoryStringList.add(c.title);
    });

    if (categoryStringList.isNotEmpty && _categoryController.text.isEmpty) {
      if (_entry == null) {
        _categoryController.text = categoryStringList[0];
      } else {
        _categoryController.text = _entry.category.title;
      }
    }

    setState(() {
      _categoryTextList = categoryStringList;
    });
  }

  _init() async {
    _passwordDecrypted =
        await Security.decryptData(_dataProvider.hash, _entry.hash);

    _titleController.text = _entry.title;
    _loginController.text = _entry.login;
    _passwordController.text = _passwordDecrypted;

    if (_categoryTextList.isNotEmpty) {
      _categoryController.text = _entry.category.title;
    }

    setState(() {
      _isInit = true;
    });
  }

  _onTitleSubmitted(String text) {
    FocusScope.of(context).requestFocus(_loginFocus);
  }

  _onLoginSubmitted(String text) {
    FocusScope.of(context).requestFocus(_passwordFocus);
  }

  _copyInputText(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    final snackBar = SnackBar(
      content: Text(AppTranslations.of(context).text("text_copied")),
    );
    Scaffold.of(context)
        .removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _onDelete() {
    DialogMessage.display(
      context,
      _themeProvider,
      title: AppTranslations.of(context).text("warning"),
      body: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              AppTranslations.of(context).text("entry_sure_to_delete"),
              style: TextStyle(color: _themeProvider.textColor),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppTranslations.of(context).text("no")),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            AppTranslations.of(context).text("yes"),
            style: TextStyle(color: _themeProvider.primaryColor),
          ),
          onPressed: () async {
            Navigator.of(context).pop();

            try {
              await EntryService.delete(_entry, _dataProvider);
            } catch (e) {
              print(e);
            }

            _dataProvider.reloadHome();
            _dataProvider.reloadCategory();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  _onUpdate() async {
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
        uid: _entry.uid,
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

      await EntryService.update(entry, _dataProvider);
      _dataProvider.reloadHome();
      _dataProvider.reloadCategory();

      setState(() {
        _isEditing = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });

      DialogMessage.displaysErrorListDialog(errors, _themeProvider, context);
    }
  }

  List<Widget> _displaysAppbarIcons() {
    if (_isEditing) {
      return <Widget>[
        IconButton(
          icon: Icon(
            Icons.delete,
            color: _themeProvider.textColor,
          ),
          onPressed: () {
            _onDelete();
          },
        ),
      ];
    } else {
      return <Widget>[
        IconButton(
          icon: Icon(
            Icons.delete,
            color: _themeProvider.textColor,
          ),
          onPressed: () {
            _onDelete();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: _themeProvider.textColor,
          ),
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
        ),
      ];
    }
  }

  Widget _displaysEntryDetails() {
    return Builder(
      builder: (scaffoldContext) => Column(
        children: <Widget>[
          Input(
            textController: _loginController,
            hint: AppTranslations.of(context).text("login_email"),
            margin: EdgeInsets.only(top: 2),
            readOnly: true,
            onClick: (String text) {
              _copyInputText(scaffoldContext, text);
            },
          ),
          Input(
            textController: _passwordController,
            hint: AppTranslations.of(context).text("password"),
            obscureText: _isPasswordHidden,
            readOnly: true,
            margin: EdgeInsets.only(top: 2),
            textInputAction: TextInputAction.done,
            onClick: (String text) {
              _copyInputText(scaffoldContext, text);
            },
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

  Widget _displaysEditBody() {
    return LoadingDialog(
      isDisplayed: _isLoading,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Input(
                    textController: _titleController,
                    hint: AppTranslations.of(context).text("title"),
                    margin: EdgeInsets.only(top: 2),
                    onSubmitted: _onTitleSubmitted,
                  ),
                  Input(
                    textController: _loginController,
                    focus: _loginFocus,
                    hint: AppTranslations.of(context).text("login_email"),
                    margin: EdgeInsets.only(top: 2),
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
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: RoundedButton(
              onClick: () {
                _onUpdate();
              },
              text: AppTranslations.of(context).text("update"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _displaysBody() {
    if (_isEditing) {
      return _displaysEditBody();
    } else {
      return _displaysEntryDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context, listen: true);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _entry = ModalRoute.of(context).settings.arguments;

    if (!_isInit) {
      _init();
    }

    return Scaffold(
      backgroundColor: _themeProvider.backgroundColor,
      appBar: AppBar(
        leading: _isEditing
            ? IconButton(
                icon: Icon(Icons.close, color: _themeProvider.textColor),
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                  });
                },
              )
            : BackButton(
                color: _themeProvider.textColor,
              ),
        brightness: _themeProvider.getBrightness(),
        backgroundColor: _themeProvider.secondBackgroundColor,
        title: Text(
          _isEditing
              ? AppTranslations.of(context).text("update_entry")
              : _entry.title,
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
        actions: _displaysAppbarIcons(),
      ),
      body: _displaysBody(),
    );
  }
}
