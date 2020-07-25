import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/utils/tuple.dart';

// From the type of file, decide which import system to use
Tuple<List<Category>, List<Entry>> importButtercup(List<String> lines, int vaultId) {
  if(lines[0].split(",")[0] == "!type") {
    return importButtercupV2(lines, vaultId);
  } else {
    return importButtercupV1(lines, vaultId);
  }
}

Tuple<List<Category>, List<Entry>> importButtercupV1(List<String> lines, int vaultId) {
  var index = 0;
  var nbColumns = 0;
  var categoryList = List<Category>();
  var entryList = List<Entry>();

  for (var line in lines) {
    var lineSplit = line.split(",");

    if (index != 0) {
      var category = Category(
        id: index,
        title: lineSplit[1],
        iconName: "",
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

      // Add category to the list
      if (categoryList.where((c) => c.title == category.title).isEmpty) {
        categoryList.add(category);
      }

      // Add entry
      var hash = line.substring(
        line.indexOf(lineSplit[4]),
        line.indexOf("," + lineSplit[lineSplit.length - (nbColumns - 5)]),
      );
      hash = hash.replaceAll("\"\"", "\"");

      if (hash[0] == "\"") {
        hash = hash.substring(1, hash.length - 1);
      }

      var entry = Entry(
        title: lineSplit[2],
        login: lineSplit[3],
        hash: hash,
        categoryId: categoryList
            .where((c) => c.title == category.title)
            .toList()[0]
            .id,
        vaultId: vaultId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      entryList.add(entry);
    } else {
      // Count the columns
      nbColumns = lineSplit.length;
    }

    index++;
  }

  return Tuple(item1: categoryList, item2: entryList);
}

Tuple<List<Category>, List<Entry>> importButtercupV2(List<String> lines, int vaultId) {
  var index = 0;
  var nbColumns = 0;
  var categoryList = List<Category>();
  var entryList = List<Entry>();

  for (var line in lines) {
    var lineSplit = line.split(",");

    if (index != 0) {
      var category = Category(
        id: index,
        title: lineSplit[1],
        iconName: "",
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

      // Add category to the list
      if (categoryList.where((c) => c.title == category.title).isEmpty) {
        categoryList.add(category);
      }

      // Add entry
      var hash = line.substring(
        line.indexOf(lineSplit[4]),
        line.indexOf("," + lineSplit[lineSplit.length - (nbColumns - 5)]),
      );
      hash = hash.replaceAll("\"\"", "\"");

      if (hash[0] == "\"") {
        hash = hash.substring(1, hash.length - 1);
      }

      var entry = Entry(
        title: lineSplit[2],
        login: lineSplit[3],
        hash: hash,
        categoryId: categoryList
            .where((c) => c.title == category.title)
            .toList()[0]
            .id,
        vaultId: vaultId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      entryList.add(entry);
    } else {
      // Count the columns
      nbColumns = lineSplit.length;
    }

    index++;
  }

  return Tuple(item1: categoryList, item2: entryList);
}