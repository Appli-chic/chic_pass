import 'dart:collection';

import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/category_service.dart';
import 'package:chicpass/service/entry_serice.dart';
import 'package:chicpass/ui/component/loading_dialog.dart';
import 'package:chicpass/ui/component/setting_item.dart';
import 'package:chicpass/utils/security.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeProvider _themeProvider;
  DataProvider _dataProvider;

  _importCSV() async {
    var file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (file != null) {
      try {
        _dataProvider.setLoading(true);

        // If the file exists then we parse it
        var lines = await file.readAsLines();
        var index = 0;
        var nbColumns = 0;
        var categoryList = List<Category>();
        var entryList = List<Entry>();

        for (var line in lines) {
          var lineSplit = line.split(",");

          if (index != 0) {
            var category = Category(
              id: index,
              title: lineSplit[1],
              iconName: "",
              updatedAt: DateTime.now(),
              createdAt: DateTime.now(),
            );

            // Add category to the list
            if (categoryList.where((c) => c.title == category.title).isEmpty) {
              categoryList.add(category);
            }

            // Add entry
            var hash = line.substring(
              line.indexOf(lineSplit[4]),
              line.indexOf("," + lineSplit[lineSplit.length - (nbColumns - 5)]),
            );
            hash = hash.replaceAll("\"\"", "\"");

            if (hash[0] == "\"") {
              hash = hash.substring(1, hash.length - 1);
            }

            var entry = Entry(
              title: lineSplit[2],
              login: lineSplit[3],
              hash: hash,
              categoryId: categoryList
                  .where((c) => c.title == category.title)
                  .toList()[0]
                  .id,
              vaultId: _dataProvider.vault.id,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            entryList.add(entry);
          } else {
            // Count the columns
            nbColumns = lineSplit.length;
          }

          index++;
        }

        // Select the categories for the importation
        var newCategoryList = await Navigator.pushNamed(
            context, '/import_category_screen',
            arguments: categoryList);

        // Change the category ID for each entry
        for (var i = 0; i < (newCategoryList as List<Category>).length; i++) {
          var oldCategoryId = categoryList[i];

          for (var entry in entryList) {
            if (entry.categoryId == oldCategoryId.id) {
              entry.categoryId = (newCategoryList as List<Category>)[i].id;
            }
          }
        }

        // Save in the local database
        await _addCategories(newCategoryList);
        await _addEntries(entryList);

        _dataProvider.reloadHome();
        _dataProvider.reloadCategory();
        _dataProvider.setLoading(false);
      } catch (e) {
        print(e);
        _dataProvider.setLoading(false);
      }
    }
  }

  _addCategories(List<Category> categories) async {
    for (var category in categories) {
      await CategoryService.save(category);
    }
  }

  _addEntries(List<Entry> entries) async {
    for (var entry in entries) {
      entry.hash =
          await Security.encryptPassword(_dataProvider.hash, entry.hash);
      await EntryService.save(entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _dataProvider = Provider.of<DataProvider>(context, listen: true);

    return LoadingDialog(
      isDisplayed: _dataProvider.isLoading,
      child: Scaffold(
        backgroundColor: _themeProvider.backgroundColor,
        appBar: AppBar(
          leading: BackButton(
            color: _themeProvider.textColor,
          ),
          brightness: _themeProvider.getBrightness(),
          backgroundColor: _themeProvider.secondBackgroundColor,
          title: Text(
            AppTranslations.of(context).text("settings_title"),
            style: TextStyle(color: _themeProvider.textColor),
          ),
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            SettingItem(
              title: AppTranslations.of(context).text("display"),
              secondaryText: _themeProvider.isLight
                  ? AppTranslations.of(context).text("light")
                  : AppTranslations.of(context).text("dark"),
              onClick: () async {
                await Navigator.pushNamed(context, '/display_screen');
              },
            ),
            SettingItem(
              title: AppTranslations.of(context).text("import_passwords"),
              onClick: () {
                _importCSV();
              },
            ),
            SettingItem(
              title: AppTranslations.of(context).text("biometry"),
              onClick: () async {
                await Navigator.pushNamed(context, '/biometry_settings_screen');
              },
            ),
            SettingItem(
              title: AppTranslations.of(context).text("lock_now"),
              onClick: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
