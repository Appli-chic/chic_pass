
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/utils/sqlite.dart';

class CategoryService {
  static Future<void> save(Category category) async {
    await addRow(Category.tableName, category.toMap());
  }

  static Future<List<Category>> getAll() async {
    var result = await getAllRows(Category.tableName);

    return List.generate(result.length, (i) {
      return Category.fromMap(result[i]);
    });
  }
}
