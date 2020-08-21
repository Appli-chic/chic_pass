import 'dart:convert';

import 'package:chicpass/model/api_error.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

const String AUTH_ASK_CODE_LOGIN = "api/auth/ask_code";

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
}
