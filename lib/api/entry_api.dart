import 'dart:convert';
import 'dart:io';

import 'package:chicpass/model/api_error.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/service/entry_service.dart';
import 'package:chicpass/utils/security.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../main.dart';
import 'auth_api.dart';

const String ENTRIES = "api/entries";

class EntryApi {
  static Future<void> sendEntries(List<Entry> entries) async {
    var client = http.Client();
    var accessToken = await Security.getAccessTokenToken();

    var response = await client.post(
      "${env.apiUrl}$ENTRIES",
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
      body: json.encode({
        "entries": entries.map((v) => v.toJson()).toList(),
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      await AuthApi.refreshAccessToken();
      return await sendEntries(entries);
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  static Future<void> synchronizeEntries(DateTime lastSync) async {
    var client = http.Client();
    var accessToken = await Security.getAccessTokenToken();
    var dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    String lastSyncString;

    if(lastSync != null) {
      lastSyncString = dateFormatter.format(lastSync);
    }

    var response = await client.get(
      "${env.apiUrl}$ENTRIES?LastSynchro=$lastSyncString",
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      List<dynamic> dataList = json.decode(response.body)["entries"];

      for (var data in dataList) {
        var entry = Entry.fromJson(data);
        await EntryService.save(entry);
      }

      return;
    } else if (response.statusCode == 401) {
      await AuthApi.refreshAccessToken();
      return await synchronizeEntries(lastSync);
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }
}
