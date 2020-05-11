import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppTranslations {
  Locale locale;
  static Map<dynamic, dynamic> _localisedValues;

  AppTranslations(Locale locale) {
    this.locale = locale;
  }

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  static Future<AppTranslations> load(Locale locale) async {
    AppTranslations appTranslations = AppTranslations(locale);

    String jsonContent = await rootBundle.loadString(
        "assets/languages/localization_${locale.languageCode}.json");
    _localisedValues = json.decode(jsonContent);

    return appTranslations;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) {
    return _localisedValues[key] ?? key;
  }

  List<String> list(String key) {
    var result = List<String>();

    if ((_localisedValues[key] as List<dynamic>).isNotEmpty) {
      for (var element in _localisedValues[key]) {
        result.add(element);
      }
    }

    return result;
  }

  String textWithArgument(String key, String arg) {
    return _localisedValues[key].toString().replaceFirst('{}', arg) ?? key;
  }

  String textWithArguments(String key, List<String> args) {
    return _localisedValues[key] ?? key;
  }
}