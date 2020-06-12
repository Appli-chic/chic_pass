import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

const String URL_ENV = ".env.json";

class EnvParser {
  Future<Env> load() async {
    String jsonContent = await rootBundle.loadString(URL_ENV);
    return Env.fromJson(json.decode(jsonContent));
  }
}

class Env {
  final String apiUrl;
  final String accessTokenKey;
  final String refreshTokenKey;

  Env({
    this.apiUrl,
    this.accessTokenKey,
    this.refreshTokenKey,
  });

  factory Env.fromJson(Map<String, dynamic> jsonMap) {
    return new Env(
      apiUrl: jsonMap["API_URL"],
      accessTokenKey: jsonMap["ACCESS_TOKEN_STORAGE_KEY"],
      refreshTokenKey: jsonMap["REFRESH_TOKEN_STORAGE_KEY"],
    );
  }
}