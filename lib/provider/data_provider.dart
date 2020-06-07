import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/model/db/vault.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  List<Entry> _entries = [];
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

  List<Entry> get entries => _entries;

  String get hash => _hash;

  Vault get vault => _vault;
}