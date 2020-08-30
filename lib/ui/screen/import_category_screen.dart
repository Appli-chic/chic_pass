import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/category_service.dart';
import 'package:chicpass/ui/component/dialog_message.dart';
import 'package:chicpass/ui/component/input.dart';
import 'package:chicpass/ui/component/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImportCategoryScreen extends StatefulWidget {
  @override
  _ImportCategoryScreenState createState() => _ImportCategoryScreenState();
}

class _ImportCategoryScreenState extends State<ImportCategoryScreen> {
  DataProvider _dataProvider;
  ThemeProvider _themeProvider;
  List<String> _categoryTextList = [];
  List<Category> _categories = [];
  List<Category> _categoriesToImport = [];
  List<Category> _newCategories = [];
  int _index = 0;
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _categoryTitleController = TextEditingController();

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
      _categoryController.text = categoryStringList[0];
    }

    setState(() {
      _categoryTextList = categoryStringList;
    });
  }

  _onSave() {
    if (_categoryController.text.isNotEmpty) {
      _newCategories.add(_categories
          .where((c) => c.title == _categoryController.text)
          .toList()[0]);

      _index++;

      if (_index >= _categoriesToImport.length) {
        // Return values
        Navigator.pop(context, _newCategories);
      }

      setState(() {});
    } else {
      _displaysErrorDialog();
    }
  }

  _displaysErrorDialog() {
    DialogMessage.display(
      context,
      _themeProvider,
      body: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(AppTranslations.of(context).text("empty_category_error")),
          ],
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
    _categoriesToImport = ModalRoute.of(context).settings.arguments;

    if (_index < _categoriesToImport.length) {
      _categoryTitleController.text = _categoriesToImport[_index].title;
    }

    return Scaffold(
      backgroundColor: _themeProvider.backgroundColor,
      appBar: AppBar(
        brightness: _themeProvider.getBrightness(),
        centerTitle: true,
        backgroundColor: _themeProvider.secondBackgroundColor,
        elevation: 0,
        title: Text(
          AppTranslations.of(context).text("import_categories"),
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
                Container(
                  margin: EdgeInsets.only(left: 8, bottom: 8, top: 32),
                  child: Text(
                    AppTranslations.of(context).text("category_to_import"),
                    style: TextStyle(
                      color: _themeProvider.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Input(
                  textController: _categoryTitleController,
                  hint: AppTranslations.of(context).text("category"),
                  margin: EdgeInsets.only(top: 2),
                  readOnly: true,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8, bottom: 8, top: 32),
                  child: Text(
                    AppTranslations.of(context).text("category_used"),
                    style: TextStyle(
                      color: _themeProvider.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
                        context, '/new_category_screen',
                        arguments: _categoryTitleController.text);

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
    );
  }
}
