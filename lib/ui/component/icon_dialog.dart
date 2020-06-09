import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IconDialog extends StatefulWidget {
  final Function(String) onIconTapped;

  IconDialog({
    this.onIconTapped,
  });

  @override
  _IconDialogState createState() => _IconDialogState();
}

class _IconDialogState extends State<IconDialog> {
  ThemeProvider _themeProvider;

  List<Widget> _generateList() {
    var icons = List<Widget>();

    for (var category in categoryList) {
      icons.add(
        GestureDetector(
          onTap: () {
            widget.onIconTapped(category);
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Image.asset(
              "assets/category/$category",
              color: _themeProvider.textColor,
            ),
          ),
        ),
      );
    }

    return icons;
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      backgroundColor: _themeProvider.secondBackgroundColor,
      title: Text(AppTranslations.of(context).text("choose_icon_title")),
      content: Container(
        height:  MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width * .7,
        color: _themeProvider.secondBackgroundColor,
        child: Theme(
          data: ThemeData(
            primaryColor: _themeProvider.primaryColor,
          ),
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 1,
            padding: EdgeInsets.all(0),
            children: _generateList(),
          ),
        ),
      ),
    );
  }
}
