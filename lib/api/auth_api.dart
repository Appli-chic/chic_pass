import 'dart:convert';

import 'package:chicpass/model/api_error.dart';
import 'package:chicpass/utils/security.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

const String AUTH_ASK_CODE_LOGIN = "api/auth/ask_code";
const String AUTH_LOGIN = "api/auth/login";
const String AUTH_REFRESH = "api/auth/refresh";

class AuthApi {
  static Future<void> askCodeToLogin(String email) async {
    var client = http.Client();

    var response = await client.post(
      "${env.apiUrl}$AUTH_ASK_CODE_LOGIN",
      body: json.encode({
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  static Future<void> login(String email, String code) async {
    var client = http.Client();

    var response = await client.post(
      "${env.apiUrl}$AUTH_LOGIN",
      body: json.encode({
        "email": email,
        "token": int.parse(code),
      }),
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      await Security.setRefreshToken(responseData["refreshToken"]);
      await Security.setAccessTokenToken(responseData["accessToken"]);

      return;
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  static Future<void> refreshAccessToken() async {
    var client = http.Client();
    var refreshToken = await Security.getRefreshToken();

    var response = await client.post(
      "${env.apiUrl}$AUTH_REFRESH",
      body: json.encode({
        "refreshToken": refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      await Security.setAccessTokenToken(responseData["accessToken"]);

      return;
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }
}
