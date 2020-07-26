import 'package:chicpass/utils/sqlite.dart';
import 'package:uuid/uuid.dart';

import '../model/db/vault.dart';

class VaultService {
  static Future<void> save(Vault vault) async {
    var uuid = Uuid();
    vault.uid = uuid.v4();
    await addRow(Vault.tableName, vault.toMap());
  }

  static Future<List<Vault>> getAll() async {
    var result = await getAllRows(Vault.tableName);

    return List.generate(result.length, (i) {
      return Vault.fromMap(result[i]);
    });
  }
}
