import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/utils/sqlite.dart';
import 'package:chicpass/utils/synchronization.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../model/db/vault.dart';

const GENERAL_SELECT =
    "SELECT v.uid, v.name, v.signature, v.user_uid, v.created_at, v.updated_at, v.deleted_at "
    "FROM ${Vault.tableName} as v ";

class VaultService {
  static Future<void> delete(Vault vault, DataProvider dataProvider) async {
    var dateFormatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String deletedAt = dateFormatter.format(DateTime.now());

    await sqlQuery("UPDATE ${Vault.tableName} SET deleted_at = '$deletedAt', "
        "updated_at = '$deletedAt' "
        "WHERE ${Vault.tableName}.uid = '${vault.uid}'");

    Synchronization.synchronize(dataProvider);
  }

  static Future<void> save(Vault vault, DataProvider dataProvider) async {
    if (vault.uid == null || vault.uid.isEmpty) {
      var uuid = Uuid();
      vault.uid = uuid.v4();
    }

    await addRow(Vault.tableName, vault.toMap());
    Synchronization.synchronize(dataProvider);
  }

  static Future<List<Vault>> getAll() async {
    String query = GENERAL_SELECT + " where v.deleted_at is null";
    var result = await sqlQuery(query);

    return List.generate(result.length, (i) {
      return Vault.fromMap(result[i]);
    });
  }

  static Future<List<Vault>> getVaultsToSynchronize(DateTime lastSync) async {
    String query = GENERAL_SELECT;

    if (lastSync != null) {
      var dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String lastSyncString = dateFormatter.format(lastSync);
      query += "where v.updated_at > '$lastSyncString' ";
    }

    var data = await sqlQuery(query);

    return List.generate(data.length, (i) {
      return Vault.fromMap(data[i]);
    });
  }

  static Future<void> updateUserId(
      Vault vault, DataProvider dataProvider) async {
    await sqlQuery("UPDATE ${Vault.tableName} "
        "SET user_uid = '${vault.userUid}' "
        "WHERE ${Vault.tableName}.uid = '${vault.uid}' ");

    Synchronization.synchronize(dataProvider);
  }
}
