import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchInput extends StatefulWidget {
  SearchInput({
    @required this.controller,
  });

  final TextEditingController controller;

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      height: 56,
      color: _themeProvider.secondBackgroundColor,
      child: Center(
        child: TextField(
          controller: widget.controller,
          maxLines: 1,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, size: 24, color: Colors.black54),
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: AppTranslations.of(context).text("search_hint"),
          ),
        ),
      ),
    );
  }
}
