import 'package:chicpass/utils/constant.dart';
import 'package:flutter/services.dart';

const MethodChannel _platform = MethodChannel('applichic.com/chicpass');

class Security {

  static Future<String> encryptSignature(String hash) async {
    var map = Map();
    map["password"] = hash;
    map["data"] = SIGNATURE;

    return await _platform.invokeMethod('encrypt', map);
  }

  static Future<String> decryptData(String hash, String encrypted) async {
    var map = Map();
    map["data"] = encrypted;
    map["password"] = hash;

    return await _platform.invokeMethod('decrypt', map);
  }

  static Future<bool> isSignatureCorrect(String hash, String encrypted) async {
    return await decryptData(hash, encrypted) == SIGNATURE;
  }

  static Future<String> encryptPassword(String hash, String password) async {
    var map = Map();
    map["data"] = password;
    map["password"] = hash;

    return await _platform.invokeMethod('encrypt', map);
  }
}
