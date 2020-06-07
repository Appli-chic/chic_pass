import 'package:chicpass/utils/constant.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

import '../main.dart';

final cryptor = new PlatformStringCryptor();

class Security {

  static Future<String> encryptMainPassword(String password) async {
    return await cryptor.generateKeyFromPassword(password, env.securityKey);
  }

  static Future<String> encryptSignature(String key) async {
    return await cryptor.encrypt(SIGNATURE, key);
  }

  static Future<String> decryptData(String key, String encrypted) async {
    try {
      return await cryptor.decrypt(encrypted, key);
    } on MacMismatchException {
      return null;
    }
  }

  static Future<bool> isSignatureCorrect(String key, String encrypted) async {
    return await decryptData(key, encrypted) == SIGNATURE;
  }

  static Future<String> encryptPassword(String key, String password) async {
    return await cryptor.encrypt(password, key);
  }
}
