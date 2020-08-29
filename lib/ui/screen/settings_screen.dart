import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/category_service.dart';
import 'package:chicpass/service/entry_service.dart';
import 'package:chicpass/ui/component/loading_dialog.dart';
import 'package:chicpass/ui/component/setting_item.dart';
import 'package:chicpass/utils/imports.dart';
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
        var tupleData = importButtercup(lines, _dataProvider.vault.uid);
        var categoryList = tupleData.item1;
        var entryList = tupleData.item2;

        // Select the categories for the importation
        var newCategoryList = await Navigator.pushNamed(
            context, '/import_category_screen',
            arguments: categoryList);

        if ((newCategoryList as List<Category>).length == categoryList.length) {
          // Change the entries with the right UID
          for (var i = 0; i < (newCategoryList as List<Category>).length; i++) {
            var oldCategoryId = categoryList[i];

            for(var entry in entryList)  {
              if(entry.categoryUid == oldCategoryId.uid) {
                entry.categoryUid = (newCategoryList as List<Category>)[i].uid;
              }
            }
          }

          // Save in the local database using a different thread
          await _addCategories(newCategoryList);
          await _addEntries(entryList);

          _dataProvider.reloadHome();
          _dataProvider.reloadCategory();
          _dataProvider.setLoading(false);
        }
      } catch (e) {
        print(e);
        _dataProvider.setLoading(false);
      }
    }
  }

  _addCategories(List<Category> categories) async {
    for (var category in categories) {
      try {
        category.vaultUid = _dataProvider.vault.uid;
        await CategoryService.saveWithUidDefined(category);
      } catch (e) {
        print(e);
      }
    }
  }

  _addEntries(List<Entry> entries) async {
    for (var entry in entries) {
      try {
        entry.hash =
            await Security.encryptPassword(_dataProvider.hash, entry.hash);
        await EntryService.save(entry);
      } catch (e) {
        print(e);
      }
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
