import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/entry_serice.dart';
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
  DataProvider _dataProvider;
  TextEditingController _searchTextController = TextEditingController();
  List<Entry> _oldEntries = [];
  List<Entry> _entries = [];

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_dataProvider == null) {
      _dataProvider = Provider.of<DataProvider>(context, listen: true);
      _loadEntries();
    }
  }

  _loadEntries() async {
    Category category = ModalRoute.of(context).settings.arguments;
    var entries = await EntryService.getAllByVaultIdAndCategoryId(
        _dataProvider.vault.uid, category.uid);
    _entries = entries;
    _oldEntries = entries;

    if (_searchTextController.text.isNotEmpty) {
      _onSearch(_searchTextController.text);
    } else {
      setState(() {});
    }
  }

  _onSearch(String text) {
    _entries = _oldEntries
        .where((entry) =>
            entry.title.toLowerCase().contains(text.toLowerCase()) ||
            entry.login.toLowerCase().contains(text.toLowerCase()))
        .toList();
    setState(() {});
  }

  _onDismiss(Entry entry) {
    try {
      _entries.remove(_entries.where((e) => e.uid == entry.uid).toList()[0]);
      _oldEntries
          .remove(_oldEntries.where((e) => e.uid == entry.uid).toList()[0]);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _dataProvider = Provider.of<DataProvider>(context, listen: true);

    if (_category == null) {
      _category = ModalRoute.of(context).settings.arguments;
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
          _category.title,
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: _themeProvider.textColor,
            ),
            onPressed: () async {
              var category = await Navigator.pushNamed(
                  context, '/new_category_screen',
                  arguments: _category);

              _category = category;
              _loadEntries();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Input(
              textController: _searchTextController,
              hint: AppTranslations.of(context).text("search_hint"),
              prefixIconData: Icons.search,
              suffixIconData:
                  _searchTextController.text.isNotEmpty ? Icons.close : null,
              onSuffixIconClicked: () {
                _searchTextController.clear();
                _onSearch(_searchTextController.text);
              },
              onTextChanged: _onSearch,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 4, bottom: 4),
              child: Scrollbar(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 0, bottom: 20),
                  itemCount: _entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PasswordItem(
                      entry: _entries[index],
                      onDismiss: _onDismiss,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
