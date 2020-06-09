import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IconSelector extends StatelessWidget {
  final String iconName;

  IconSelector({
    this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(80)),
        color: themeProvider.secondBackgroundColor,
      ),
      child: Center(
        child: Image.asset(
          "assets/category/$iconName",
          color: themeProvider.textColor,
          height: 28,
          width: 28,
        ),
      ),
    );
  }
}
