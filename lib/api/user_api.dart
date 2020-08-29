import 'dart:convert';
import 'dart:io';

import 'package:chicpass/model/api_error.dart';
import 'package:chicpass/model/db/user.dart';
import 'package:chicpass/utils/security.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

const String GET_USER = "api/user";

class UserApi {
  static Future<User> getCurrentUser() async {
    var client = http.Client();
    var accessToken = await Security.getAccessTokenToken();

    var response = await client.get(
      "${env.apiUrl}$GET_USER",
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body)["user"]);
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }
}
