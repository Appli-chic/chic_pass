import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/category_service.dart';
import 'package:chicpass/ui/component/dialog_error.dart';
import 'package:chicpass/ui/component/icon_dialog.dart';
import 'package:chicpass/ui/component/icon_selector.dart';
import 'package:chicpass/ui/component/input.dart';
import 'package:chicpass/ui/component/loading_dialog.dart';
import 'package:chicpass/ui/component/rounded_button.dart';
import 'package:chicpass/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewCategoryScreen extends StatefulWidget {
  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  TextEditingController _titleController = TextEditingController();
  String _icon = categoryList[0];
  ThemeProvider _themeProvider;
  bool _isLoading = false;

  _onSave() async {
    var errors = List<String>();

    if (_titleController.text.isEmpty) {
      errors.add(AppTranslations.of(context).text("title_empty_error"));
    }

    if (errors.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      var category = Category(
        title: _titleController.text,
        iconName: _icon,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await CategoryService.save(category);
      Navigator.pop(context, category);
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
            AppTranslations.of(context).text("new_category_title"),
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
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        child: IconSelector(iconName: _icon),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 16, right: 16, bottom: 16, top: 16),
                        child: RoundedButton(
                          text: AppTranslations.of(context).text("update"),
                          fontSize: 16,
                          borderRadius: 8,
                          minHeight: 35,
                          onClick: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return IconDialog(
                                  onIconTapped: (icon) {
                                    setState(() {
                                      _icon = icon;
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
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