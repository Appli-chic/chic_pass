import 'package:chicpass/model/db/vault.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  String _hash;
  Vault _vault;
  bool _isHomeReloading = false;
  bool _isCategoryReloading = false;
  bool _isLoading = false;

  setVault(Vault vault) {
    _vault = vault;
    notifyListeners();
  }

  setHash(String hash) {
    _hash = hash;
    notifyListeners();
  }

  reloadHome() {
    _isHomeReloading = true;
    notifyListeners();
  }

  setHomeReloaded() {
    _isHomeReloading = false;
  }

  reloadCategory() {
    _isCategoryReloading = true;
    notifyListeners();
  }

  setCategoryReloaded() {
    _isCategoryReloading = false;
  }

  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String get hash => _hash;

  Vault get vault => _vault;

  bool get isHomeReloading => _isHomeReloading;

  bool get isCategoryReloading => _isCategoryReloading;

  bool get isLoading => _isLoading;
}