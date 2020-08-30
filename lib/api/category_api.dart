import 'dart:convert';
import 'dart:io';

import 'package:chicpass/model/api_error.dart';
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/service/category_service.dart';
import 'package:chicpass/utils/security.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../main.dart';
import 'auth_api.dart';

const String CATEGORIES = "api/categories";

class CategoryApi {
  static Future<void> sendCategories(List<Category> categories) async {
    var client = http.Client();
    var accessToken = await Security.getAccessTokenToken();

    var response = await client.post(
      "${env.apiUrl}$CATEGORIES",
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
      body: json.encode({
        "categories": categories.map((v) => v.toJson()).toList(),
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      await AuthApi.refreshAccessToken();
      return await sendCategories(categories);
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  static Future<void> synchronizeCategories(DateTime lastSync, DataProvider dataProvider) async {
    var client = http.Client();
    var accessToken = await Security.getAccessTokenToken();
    var dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    String lastSyncString;

    if (lastSync != null) {
      lastSyncString = dateFormatter.format(lastSync);
    }

    var response = await client.get(
      "${env.apiUrl}$CATEGORIES?LastSynchro=$lastSyncString",
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      List<dynamic> dataList = json.decode(response.body)["categories"];

      for (var data in dataList) {
        var category = Category.fromJson(data);
        await CategoryService.save(category, dataProvider);
      }

      return;
    } else if (response.statusCode == 401) {
      await AuthApi.refreshAccessToken();
      return await synchronizeCategories(lastSync, dataProvider);
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }
}
