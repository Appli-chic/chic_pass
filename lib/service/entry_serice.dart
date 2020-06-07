
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/utils/sqlite.dart';

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
}