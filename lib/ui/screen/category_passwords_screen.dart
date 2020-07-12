import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/component/input.dart';
import 'package:chicpass/ui/component/password_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPasswordsScreen extends StatefulWidget {

  @override
  _CategoryPasswordsScreenState createState() =>
      _CategoryPasswordsScreenState();
}

class _CategoryPasswordsScreenState extends State<CategoryPasswordsScreen> {
  Category _category;
  ThemeProvider _themeProvider;
  TextEditingController _searchTextController = TextEditingController();
  List<Entry> _entries = [];

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _category = ModalRoute.of(context).settings.arguments;
//    var entries = _dataProvider.entries.where((e) => e.category.id == _category.id).toList();

    return Scaffold(
      backgroundColor: _themeProvider.backgroundColor,
      appBar: AppBar(
        leading: BackButton(
          color: _themeProvider.textColor,
        ),
        brightness: _themeProvider.getBrightness(),
        backgroundColor: _themeProvider.secondBackgroundColor,
        title: Text(
          _category.title,
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Input(
              textController: _searchTextController,
              hint: AppTranslations.of(context).text("search_hint"),
              prefixIconData: Icons.search,
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.only(top: 0, bottom: 20),
            physics: NeverScrollableScrollPhysics(),
            itemCount: _entries.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return PasswordItem(
                entry: _entries[index],
              );
            },
          )
        ],
      ),
    );
  }
}
