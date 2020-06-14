import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundedButton extends StatelessWidget {
  final Key key;
  final Function onClick;
  final String text;
  final double fontSize;
  final double borderRadius;
  final double minHeight;
  final double minWidth;

  RoundedButton({
    this.key,
    @required this.onClick,
    @required this.text,
    this.fontSize = 20,
    this.borderRadius = 80,
    this.minHeight = 50,
    this.minWidth = 88,
  });

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: true);

    return RaisedButton(
      onPressed: onClick,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      padding: const EdgeInsets.all(0.0),
      child: Container(
        child: Ink(
          decoration: BoxDecoration(
            color: themeProvider.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: Container(
            constraints:
                BoxConstraints(minWidth: minWidth, minHeight: minHeight),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
