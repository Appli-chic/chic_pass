import 'dart:convert';
import 'dart:io';

import 'package:chicpass/api/auth_api.dart';
import 'package:chicpass/model/api_error.dart';
import 'package:chicpass/model/db/vault.dart';
import 'package:chicpass/utils/security.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

const String POST_VAULTS = "api/vaults";

class VaultApi {
  static Future<void> sendVaults(List<Vault> vaults) async {
    var client = http.Client();
    var accessToken = await Security.getAccessTokenToken();

    var response = await client.post(
      "${env.apiUrl}$POST_VAULTS",
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
      body: json.encode({
        "vaults": vaults.map((v) => v.toJson()).toList(),
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      await AuthApi.refreshAccessToken();
      return await sendVaults(vaults);
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }
}
