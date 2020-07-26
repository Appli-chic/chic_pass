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
  final String fingerprintKey;
  final String faceRecognitionKey;

  Env({
    this.apiUrl,
    this.accessTokenKey,
    this.refreshTokenKey,
    this.fingerprintKey,
    this.faceRecognitionKey,
  });

  factory Env.fromJson(Map<String, dynamic> jsonMap) {
    return new Env(
      apiUrl: jsonMap["API_URL"],
      accessTokenKey: jsonMap["ACCESS_TOKEN_STORAGE_KEY"],
      refreshTokenKey: jsonMap["REFRESH_TOKEN_STORAGE_KEY"],
      fingerprintKey: jsonMap["FINGERPRINT_STORAGE_KEY"],
      faceRecognitionKey: jsonMap["FACE_RECOGNITION_STORAGE_KEY"],
    );
  }
}