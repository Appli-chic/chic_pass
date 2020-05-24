import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/db/vault.dart';
import 'constant.dart';

Database db;

openChicDatabase() async {
  db = await openDatabase(
    join(await getDatabasesPath(), DATABASE_NAME),
    version: 4,
    onCreate: (db, version) async {
      // Create the structure of the database
      await db.execute(
          "CREATE TABLE ${Vault.tableName}(id INTEGER PRIMARY KEY, name TEXT, signature TEXT, created_at DATETIME, updated_at DATETIME) ");

//      await db.execute(
//          "CREATE TABLE ${TypeTransaction.tableName}(id INTEGER PRIMARY KEY, title TEXT, color TEXT, icon_name TEXT) ");
//
//      await db.execute(
//          "CREATE TABLE ${t.Transaction.tableName}(id INTEGER PRIMARY KEY, title TEXT, description TEXT, price REAL, date DATETIME, nb_day_repeat INTEGER, index_type_repeat INTEGER, start_subscription_date DATETIME, end_subscription_date DATETIME, is_deactivated INTEGER, bank_id INTEGER, type_transaction_id INTEGER, transaction_id INTEGER, FOREIGN KEY(bank_id) REFERENCES ${Bank.tableName}(id), FOREIGN KEY(type_transaction_id) REFERENCES ${TypeTransaction.tableName}(id), FOREIGN KEY(transaction_id) REFERENCES ${t.Transaction.tableName}(id)) ");
    },
//    onUpgrade: (db, oldVersion, newVersion) async {
//      await db.execute(
//          "CREATE TABLE ${Vault.tableName}(id INTEGER PRIMARY KEY, name TEXT, signature TEXT, created_at DATETIME, updated_at DATETIME) ");
//    }
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