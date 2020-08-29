import 'package:chicpass/main.dart';
import 'package:chicpass/utils/constant.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const MethodChannel _platform = MethodChannel('applichic.com/chicpass');

class Security {
  static Future<bool> isConnected() async {
    final storage = FlutterSecureStorage();
    String refreshToken = await storage.read(key: env.refreshTokenKey);

    return refreshToken != null && refreshToken.isNotEmpty;
  }

  static Future<String> getRefreshToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: env.refreshTokenKey);
  }

  static Future<void> setRefreshToken(String refreshToken) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: env.refreshTokenKey, value: refreshToken);
  }

  static Future<String> getAccessTokenToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: env.accessTokenKey);
  }

  static Future<void> setAccessTokenToken(String refreshToken) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: env.accessTokenKey, value: refreshToken);
  }

  static Future<void> logout() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: env.refreshTokenKey);
    await storage.delete(key: env.accessTokenKey);
  }

  // Encryption

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
