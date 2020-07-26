import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/entry_serice.dart';
import 'package:chicpass/ui/component/input.dart';
import 'package:chicpass/ui/component/password_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DataProvider _dataProvider;
  ThemeProvider _themeProvider;
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

  reload() {
    _loadEntries();
  }

  _loadEntries() async {
    var entries = await EntryService.getAllByVaultId(_dataProvider.vault.uid);
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
            entry.login.toLowerCase().contains(text.toLowerCase()) ||
            entry.category.title.toLowerCase().contains(text.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    if(_dataProvider.isHomeReloading) {
      reload();
      _dataProvider.setHomeReloaded();
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
          AppTranslations.of(context).text("passwords_title"),
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
