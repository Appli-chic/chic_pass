import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/utils/sqlite.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const GENERAL_SELECT =
    "SELECT c.uid, c.title, c.icon_name, c.created_at, c.updated_at "
    "FROM ${Category.tableName} as c ";

class CategoryService {
  static Future<void> update(Category category) async {
    var dateFormatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String createdAtString = dateFormatter.format(category.createdAt);
    String updatedAtString = dateFormatter.format(category.updatedAt);

    await sqlQuery("UPDATE ${Category.tableName} "
        "SET title = '${category.title}', icon_name = '${category.iconName}', "
        "created_at = '$createdAtString', updated_at = '$updatedAtString', "
        "vault_uid = '${category.vaultUid}' "
        "WHERE ${Category.tableName}.uid = '${category.uid}' ");
  }

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
