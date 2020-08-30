import 'dart:convert';
import 'dart:io';

import 'package:chicpass/api/auth_api.dart';
import 'package:chicpass/model/api_error.dart';
import 'package:chicpass/model/db/vault.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/service/vault_service.dart';
import 'package:chicpass/utils/security.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../main.dart';

const String VAULTS = "api/vaults";

class VaultApi {
  static Future<void> sendVaults(List<Vault> vaults) async {
    var client = http.Client();
    var accessToken = await Security.getAccessTokenToken();

    var response = await client.post(
      "${env.apiUrl}$VAULTS",
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

  static Future<void> synchronizeVaults(
      DateTime lastSync, DataProvider dataProvider) async {
    var client = http.Client();
    var accessToken = await Security.getAccessTokenToken();
    var dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    String lastSyncString;

    if (lastSync != null) {
      lastSyncString = dateFormatter.format(lastSync);
    }

    var response = await client.get(
      "${env.apiUrl}$VAULTS?LastSynchro=$lastSyncString",
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      List<dynamic> dataList = json.decode(response.body)["vaults"];

      for (var data in dataList) {
        var vault = Vault.fromJson(data);
        await VaultService.save(vault, dataProvider);
      }

      return;
    } else if (response.statusCode == 401) {
      await AuthApi.refreshAccessToken();
      return await synchronizeVaults(lastSync, dataProvider);
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }
}
