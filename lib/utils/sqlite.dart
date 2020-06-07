
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/db/vault.dart';
import 'constant.dart';

Database db;

openChicDatabase() async {
  db = await openDatabase(
    join(await getDatabasesPath(), DATABASE_NAME),
    version: 10,
    onCreate: (db, version) async {
      // Create the structure of the database
      await db.execute(
          "CREATE TABLE ${Vault.tableName}(id INTEGER PRIMARY KEY, name TEXT, signature TEXT, created_at DATETIME, updated_at DATETIME) ");

      await db.execute(
          "CREATE TABLE ${Category.tableName}(id INTEGER PRIMARY KEY, title TEXT, icon_name TEXT, created_at DATETIME, updated_at DATETIME) ");

      await db.execute(
          "CREATE TABLE ${Entry.tableName}(id INTEGER PRIMARY KEY, title TEXT, login TEXT, hash TEXT, created_at DATETIME, updated_at DATETIME, vault_id INTEGER, category_id INTEGER, FOREIGN KEY(vault_id) REFERENCES ${Vault.tableName}(id), FOREIGN KEY(category_id) REFERENCES ${Category.tableName}(id)) ");
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      await db.execute(
          "INSERT INTO ${Category.tableName}(title, icon_name, created_at, updated_at) VALUES('Test', 'test', '2016-01-01 10:20:05.123', '2016-01-01 10:20:05.123') ");
    }
  );
}

/// Add a [row] in the specified [tableName] in the database.
/// A row should be an entity transformed into a map using the
/// function called 'toMap()'.
Future<int> addRow(String tableName, Map<String, dynamic> row) async {
  try {
    int insertedId = await db.insert(
      tableName,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return insertedId;
  } catch (e) {
    print(e);
    return -1;
  }
}

Future<void> updateRow(String tableName, Map<String, dynamic> row) async {
  try {
    await db.update(
      tableName,
      row,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  } catch (e) {
    print(e);
  }
}

Future<List<dynamic>> sqlQuery(String query) async {
  try {
    return await db.rawQuery(query);
  } catch (e) {
    print(e);

    return List();
  }
}

Future<List<dynamic>> getAllRows(String tableName) async {
  try {
    return await db.query(tableName);
  } catch (e) {
    print(e);

    return List();
  }
}