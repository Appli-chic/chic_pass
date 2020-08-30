import 'package:chicpass/utils/sqlite.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../model/db/vault.dart';

const GENERAL_SELECT =
    "SELECT v.uid, v.name, v.signature, v.user_uid, v.created_at, v.updated_at "
    "FROM ${Vault.tableName} as v ";

class VaultService {
  static Future<void> save(Vault vault) async {
    if (vault.uid == null || vault.uid.isEmpty) {
      var uuid = Uuid();
      vault.uid = uuid.v4();
    }

    await addRow(Vault.tableName, vault.toMap());
  }

  static Future<List<Vault>> getAll() async {
    var result = await getAllRows(Vault.tableName);

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

  static Future<void> updateUserId(Vault vault) async {
    await sqlQuery("UPDATE ${Vault.tableName} "
        "SET user_uid = '${vault.userUid}' "
        "WHERE ${Vault.tableName}.uid = '${vault.uid}' ");
  }
}
