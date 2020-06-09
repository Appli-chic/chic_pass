
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/utils/sqlite.dart';

const GENERAL_SELECT = "SELECT e.id, e.title, e.login, e.hash, e.created_at, "
    "e.updated_at, e.vault_id, e.category_id, c.title as c_title, c.icon_name "
    "FROM ${Entry.tableName} as e "
    "left join ${Category.tableName} as c ON c.id = e.category_id ";

class EntryService {

  static Future<void> save(Entry category) async {
    await addRow(Entry.tableName, category.toMap());
  }

  static Future<List<Entry>> getAll() async {
    var result = await getAllRows(Entry.tableName);

    return List.generate(result.length, (i) {
      return Entry.fromMap(result[i]);
    });
  }

  static Future<List<Entry>> getAllByVaultId(int vaultId) async {
    var entries = List<Entry>();
    var result = await sqlQuery(GENERAL_SELECT +
        "where e.vault_id = $vaultId ");

    for(var data in result) {
      var entry = Entry.fromMap(data);
      var category = Category();
      category.id = data['category_id'];
      category.title = data['c_title'];
      category.iconName = data['icon_name'];
      entry.category = category;
      entries.add(entry);
    }

    return entries;
  }
}