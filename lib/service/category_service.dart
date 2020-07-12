
import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/utils/sqlite.dart';

const GENERAL_SELECT = "SELECT c.id, c.title, c.icon_name, c.created_at, c.updated_at "
    "FROM ${Category.tableName} as c ";

class CategoryService {
  static Future<void> save(Category category) async {
    await addRow(Category.tableName, category.toMap());
  }

  static Future<List<Category>> getAll() async {
    var data = await getAllRows(Category.tableName);

    var result =  List.generate(data.length, (i) {
      return Category.fromMap(data[i]);
    });

    result.sort((a, b) => a.title.compareTo(b.title));
    return result;
  }
}
