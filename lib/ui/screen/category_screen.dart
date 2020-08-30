import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/category_service.dart';
import 'package:chicpass/ui/component/category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  DataProvider _dataProvider;
  ThemeProvider _themeProvider;
  List<Category> _categories = [];

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_dataProvider == null) {
      _dataProvider = Provider.of<DataProvider>(context, listen: true);
      _loadEntries();
    }
  }

  reload() {
    _loadEntries();
  }

  _loadEntries() async {
    var categories = await CategoryService.getAllByVault(_dataProvider.vault.uid);
    _categories = categories;
    setState(() {});
  }

  _onDismiss(Category category) {
    try {
      _categories
          .remove(_categories.where((e) => e.uid == category.uid).toList()[0]);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    if (_dataProvider.isCategoryReloading) {
      reload();
      _dataProvider.setCategoryReloaded();
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
          AppTranslations.of(context).text("category_title"),
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 4, bottom: 4),
        child: Scrollbar(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 0, bottom: 20),
            itemCount: _categories.length,
            itemBuilder: (BuildContext context, int index) {
              return CategoryItem(
                category: _categories[index],
                onDismiss: _onDismiss,
              );
            },
          ),
        ),
      ),
    );
  }
}
