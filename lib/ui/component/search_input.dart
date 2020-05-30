import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchInput extends StatefulWidget {
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
          maxLines: 1,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
