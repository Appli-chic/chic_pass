import 'package:chicpass/api/category_api.dart';
import 'package:chicpass/api/entry_api.dart';
import 'package:chicpass/api/vault_api.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/service/category_service.dart';
import 'package:chicpass/service/entry_service.dart';
import 'package:chicpass/service/vault_service.dart';
import 'package:chicpass/utils/constant.dart';
import 'package:chicpass/utils/security.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class Synchronization {
  static Future<void> synchronize(DataProvider dataProvider) async {
    try {
      var lastSyncDate = await getLastSyncDate();
      await push(lastSyncDate);
      await pull(lastSyncDate);
      await setLastSyncDate();

      dataProvider.reloadHome();
      dataProvider.reloadCategory();
    } catch (e) {
      print(e);
    }
  }

  static Future<DateTime> getLastSyncDate() async {
    final storage = FlutterSecureStorage();
    var dateString = await storage.read(key: LAST_SYNC_STORAGE_KEY);

    if (dateString != null && dateString.isNotEmpty) {
      return DateTime.parse(dateString);
    } else {
      return null;
    }
  }

  static Future<void> setLastSyncDate() async {
    final storage = FlutterSecureStorage();
    var today = DateTime.now();
    var dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    String todayString = dateFormatter.format(today);

    await storage.write(key: LAST_SYNC_STORAGE_KEY, value: todayString);
  }

  static Future<void> push(DateTime lastSync) async {
    var user = await Security.getCurrentUser();

    // Retrieve data to synchronize from the sqlite
    var vaults = await VaultService.getVaultsToSynchronize(lastSync);
    var categories = await CategoryService.getCategoriesToSynchronize(lastSync);
    var entries = await EntryService.getEntriesToSynchronize(lastSync);

    // Check if vaults have a user ID before to synchronize
    for (var vault in vaults) {
      if (vault.userUid == null || vault.userUid.isEmpty) {
        vault.userUid = user.uid;
        await VaultService.updateUserId(vault);
      }
    }

    // Send the data to the server
    if (vaults.isNotEmpty) {
      await VaultApi.sendVaults(vaults);
    }

    if (categories.isNotEmpty) {
      await CategoryApi.sendCategories(categories);
    }

    if (entries.isNotEmpty) {
      await EntryApi.sendEntries(entries);
    }
  }

  static Future<void> pull(DateTime lastSync) async {
    await VaultApi.synchronizeVaults(lastSync);
    await CategoryApi.synchronizeCategories(lastSync);
    await EntryApi.synchronizeEntries(lastSync);
  }
}
