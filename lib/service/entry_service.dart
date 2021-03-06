import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/utils/sqlite.dart';
import 'package:chicpass/utils/synchronization.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const GENERAL_SELECT = "SELECT e.uid, e.title, e.login, e.hash, e.created_at, "
    "e.updated_at, e.deleted_at, e.vault_uid, e.category_uid, c.title as c_title, c.icon_name "
    "FROM ${Entry.tableName} as e "
    "left join ${Category.tableName} as c ON c.uid = e.category_uid ";

class EntryService {
  static Future<void> delete(Entry entry, DataProvider dataProvider) async {
    var dateFormatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String deletedAt = dateFormatter.format(DateTime.now());

    await sqlQuery("UPDATE ${Entry.tableName} SET deleted_at = '$deletedAt', "
        "updated_at = '$deletedAt' "
        "WHERE ${Entry.tableName}.uid = '${entry.uid}'");

    Synchronization.synchronize(dataProvider);
  }

  static Future<void> update(Entry entry, DataProvider dataProvider) async {
    var dateFormatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String createdAtString = dateFormatter.format(entry.createdAt);
    String updatedAtString = dateFormatter.format(entry.updatedAt);
    String deletedAtString;

    if (entry.deletedAt != null) {
      deletedAtString = dateFormatter.format(entry.deletedAt);
    }

    await sqlQuery("UPDATE ${Entry.tableName} "
        "SET title = '${entry.title}', login = '${entry.login}', "
        "hash = '${entry.hash}', created_at = '$createdAtString', "
        "updated_at = '$updatedAtString', deleted_at = '$deletedAtString', "
        "category_uid = '${entry.categoryUid}' "
        "WHERE ${Entry.tableName}.uid = '${entry.uid}' ");

    Synchronization.synchronize(dataProvider);
  }

  static Future<void> save(Entry entry, DataProvider dataProvider,
      {bool isSynchronizing = true}) async {
    if (entry.uid == null || entry.uid.isEmpty) {
      var uuid = Uuid();
      entry.uid = uuid.v4();
    }

    await addRow(Entry.tableName, entry.toMap());

    if (isSynchronizing) {
      Synchronization.synchronize(dataProvider);
    }
  }

  static Future<List<Entry>> getAll() async {
    var result = await getAllRows(Entry.tableName);

    return List.generate(result.length, (i) {
      return Entry.fromMap(result[i]);
    });
  }

  static Future<List<Entry>> getEntriesToSynchronize(DateTime lastSync) async {
    String query = GENERAL_SELECT;

    if (lastSync != null) {
      var dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String lastSyncString = dateFormatter.format(lastSync);
      query += "where e.updated_at > '$lastSyncString' ";
    }

    var data = await sqlQuery(query);

    return List.generate(data.length, (i) {
      return Entry.fromMap(data[i]);
    });
  }

  static Future<List<Entry>> getAllByVaultId(String vaultUid) async {
    var entries = List<Entry>();
    var result = await sqlQuery(GENERAL_SELECT +
        "where e.vault_uid = '$vaultUid' "
            "and e.deleted_at is null "
            "order by e.title");

    for (var data in result) {
      var entry = Entry.fromMap(data);
      var category = Category();
      category.uid = data['category_uid'];
      category.title = data['c_title'];
      category.iconName = data['icon_name'];
      entry.category = category;
      entries.add(entry);
    }

    return entries;
  }

  static Future<List<Entry>> getAllByVaultIdAndCategoryId(
      String vaultUid, String categoryUid) async {
    var entries = List<Entry>();
    var result = await sqlQuery(GENERAL_SELECT +
        "where e.vault_uid = '$vaultUid' "
            "and e.category_uid = '$categoryUid' "
            "and e.deleted_at is null "
            "order by e.title");

    for (var data in result) {
      var entry = Entry.fromMap(data);
      var category = Category();
      category.uid = data['category_uid'];
      category.title = data['c_title'];
      category.iconName = data['icon_name'];
      entry.category = category;
      entries.add(entry);
    }

    return entries;
  }
}
