import 'package:chicpass/utils/sqlite.dart';

import '../model/db/vault.dart';

class VaultService {
  static Future<void> save(Vault vault) async {
    await addRow(Vault.tableName, vault.toMap());
  }

  static Future<List<Vault>> getAll() async {
    var result = await getAllRows(Vault.tableName);

    return List.generate(result.length, (i) {
      return Vault.fromMap(result[i]);
    });
  }
}
