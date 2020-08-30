import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/utils/sqlite.dart';
import 'package:chicpass/utils/synchronization.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const GENERAL_SELECT =
    "SELECT c.uid, c.title, c.icon_name, c.vault_uid, c.created_at, c.updated_at, c.deleted_at "
    "FROM ${Category.tableName} as c ";

class CategoryService {
  static Future<void> delete(
      Category category, DataProvider dataProvider) async {
    var dateFormatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String deletedAt = dateFormatter.format(DateTime.now());

    await sqlQuery(
        "UPDATE ${Category.tableName} SET deleted_at = '$deletedAt', "
        "updated_at = '$deletedAt' "
        "WHERE ${Category.tableName}.uid = '${category.uid}'");

    Synchronization.synchronize(dataProvider);
  }

  static Future<void> update(
      Category category, DataProvider dataProvider) async {
    var dateFormatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String createdAtString = dateFormatter.format(category.createdAt);
    String updatedAtString = dateFormatter.format(category.updatedAt);
    String deletedAtString;

    if (category.deletedAt != null) {
      deletedAtString = dateFormatter.format(category.deletedAt);
    }

    await sqlQuery("UPDATE ${Category.tableName} "
        "SET title = '${category.title}', icon_name = '${category.iconName}', "
        "created_at = '$createdAtString', updated_at = '$updatedAtString', "
        "deleted_at = '$deletedAtString', vault_uid = '${category.vaultUid}' "
        "WHERE ${Category.tableName}.uid = '${category.uid}' ");

    Synchronization.synchronize(dataProvider);
  }

  static Future<void> save(Category category, DataProvider dataProvider) async {
    if (category.uid == null || category.uid.isEmpty) {
      var uuid = Uuid();
      category.uid = uuid.v4();
    }

    await addRow(Category.tableName, category.toMap());
    Synchronization.synchronize(dataProvider);
  }

  static Future<void> saveWithUidDefined(
      Category category, DataProvider dataProvider) async {
    await addRow(Category.tableName, category.toMap());
    Synchronization.synchronize(dataProvider);
  }

  static Future<List<Category>> getAllByVault(String vaultUid) async {
    var data = await sqlQuery(GENERAL_SELECT +
        "where c.vault_uid = '$vaultUid' "
            "and c.deleted_at is null "
            "order by c.title");

    return List.generate(data.length, (i) {
      return Category.fromMap(data[i]);
    });
  }

  static Future<List<Category>> getCategoriesToSynchronize(
      DateTime lastSync) async {
    String query = GENERAL_SELECT;

    if (lastSync != null) {
      var dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String lastSyncString = dateFormatter.format(lastSync);
      query += "where c.updated_at > '$lastSyncString' ";
    }

    var data = await sqlQuery(query);

    return List.generate(data.length, (i) {
      return Category.fromMap(data[i]);
    });
  }
}
