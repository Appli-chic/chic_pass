import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/category_service.dart';
import 'package:chicpass/service/entry_serice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dialog_message.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final Function(Category) onDismiss;

  CategoryItem({
    @required this.category,
    @required this.onDismiss,
  });

  Future<bool> _onConfirmDismiss(
      DismissDirection direction,
      BuildContext context,
      ThemeProvider themeProvider,
      DataProvider dataProvider) async {
    var entries = await EntryService.getAllByVaultIdAndCategoryId(
        dataProvider.vault.uid, category.uid);

    if (entries.isNotEmpty) {
      _onCategoryNotEmpty(context, themeProvider);
      return false;
    } else {
      return await DialogMessage.display(
        context,
        themeProvider,
        title: AppTranslations.of(context).text("warning"),
        body: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                AppTranslations.of(context).text("category_sure_to_delete"),
                style: TextStyle(color: themeProvider.textColor),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(AppTranslations.of(context).text("no")),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text(
              AppTranslations.of(context).text("yes"),
              style: TextStyle(color: themeProvider.primaryColor),
            ),
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    }
  }

  _onCategoryNotEmpty(BuildContext context, ThemeProvider themeProvider) {
    var errors = [AppTranslations.of(context).text("category_not_empty_error")];

    DialogMessage.displaysErrorListDialog(errors, themeProvider, context);
  }

  _onDismiss(BuildContext context, ThemeProvider themeProvider) async {
    await CategoryService.delete(category);
    onDismiss(category);
  }

  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataProvider>(context, listen: true);
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Dismissible(
      key: Key("category_item${category.uid}"),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return _onConfirmDismiss(
            direction, context, themeProvider, dataProvider);
      },
      onDismissed: (direction) {
        _onDismiss(context, themeProvider);
      },
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: GestureDetector(
        onTap: () async {
          await Navigator.pushNamed(context, '/category_passwords_screen',
              arguments: category);
        },
        child: Container(
          height: 56,
          margin: EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: themeProvider.secondBackgroundColor,
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 16),
                child: Image.asset(
                  "assets/category/${category.iconName}",
                  color: themeProvider.textColor,
                  width: 30,
                  height: 30,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    category.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: themeProvider.textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: themeProvider.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
