import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/model/db/vault.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  List<Entry> _entries = [];
  List<Category> _categories = [];
  String _hash;
  Vault _vault;

  setVault(Vault vault) {
    _vault = vault;
    notifyListeners();
  }

  setHash(String hash) {
    _hash = hash;
    notifyListeners();
  }

  setEntries(List<Entry> entries) {
    _entries = entries;
    notifyListeners();
  }

  setCategories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  List<Entry> get entries => _entries;

  List<Category> get categories => _categories;

  String get hash => _hash;

  Vault get vault => _vault;
}