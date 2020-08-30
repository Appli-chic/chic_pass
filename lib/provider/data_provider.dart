import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/vault.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataProvider with ChangeNotifier {
  String _hash;
  Vault _vault;
  bool _isHomeReloading = false;
  bool _isCategoryReloading = false;
  bool _isLoading = false;
  bool _isSynchronizing = false;
  DateTime _lastSynchronization;

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

  setSynchronizing(bool synchronizing) {
    _isSynchronizing = synchronizing;
    notifyListeners();
  }

  setLastSynchronization(DateTime lastSynchronization) {
    _lastSynchronization = lastSynchronization;
  }

  String getLastSynchronization(BuildContext context) {
    if (_lastSynchronization == null) {
      return "";
    } else {
      var locale = AppTranslations.of(context).locale.languageCode;
      var time = DateFormat.jm(locale).format(_lastSynchronization);
      var date = DateFormat.yMd(locale).format(_lastSynchronization);
      return "$date $time";
    }
  }

  String get hash => _hash;

  Vault get vault => _vault;

  bool get isHomeReloading => _isHomeReloading;

  bool get isCategoryReloading => _isCategoryReloading;

  bool get isLoading => _isLoading;

  bool get isSynchronizing => _isSynchronizing;

  DateTime get lastSynchronization => _lastSynchronization;
}
