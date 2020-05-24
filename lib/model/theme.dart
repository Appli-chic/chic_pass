import 'package:flutter/material.dart';

class ChicTheme {
  final int id;
  final Color backgroundColor;
  final Color secondBackgroundColor;
  final Color primaryColor;
  final Color textColor;
  final Color secondTextColor;
  final Color thirdTextColor;
  final bool isLight;

  ChicTheme({
    @required this.id,
    @required this.backgroundColor,
    @required this.secondBackgroundColor,
    @required this.primaryColor,
    @required this.textColor,
    @required this.secondTextColor,
    @required this.thirdTextColor,
    @required this.isLight,
  });
}