import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/utils/sqlite.dart';
import 'package:uuid/uuid.dart';

const GENERAL_SELECT =
    "SELECT c.uid, c.title, c.icon_name, c.created_at, c.updated_at "
    "FROM ${Category.tableName} as c ";

class CategoryService {
  static Future<void> save(Category category) async {
    var uuid = Uuid();
    category.uid = uuid.v4();
    await addRow(Category.tableName, category.toMap());
  }

  static Future<void> saveWithUidDefined(Category category) async {
    await addRow(Category.tableName, category.toMap());
  }

  static Future<List<Category>> getAll(String vaultUid) async {
    var data = await sqlQuery(GENERAL_SELECT +
        "where c.vault_uid = '$vaultUid' "
            "order by c.title");

    return List.generate(data.length, (i) {
      return Category.fromMap(data[i]);
    });
  }
}
