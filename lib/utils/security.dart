import 'dart:collection';

import 'package:chicpass/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:steel_crypt/steel_crypt.dart';

class Security {
  static String encryptMainPassword(HashMap<String, String> data) {
    var passHash = PassCrypt('scrypt');
    return passHash.hashPass(data['security_key'], data['password'], 24);
  }

  static String encryptSignature(HashMap<String, String> data) {
    var streamAES = AesCrypt(data['hash'], 'ctr');
    return streamAES.encrypt(SIGNATURE, data['second_security_key']);
  }

  static String decryptSignature(HashMap<String, String> data) {
    var streamAES = AesCrypt(data['hash'], 'ctr');

    try {
      return streamAES.decrypt(data['hash_signature'], data['second_security_key']);
    } catch (e) {
      return "";
    }
  }

  static Future<bool> isSignatureCorrect(HashMap<String, String> data) async {
    return await compute(decryptSignature, data) == SIGNATURE;
  }

  static String encryptPassword(HashMap<String, String> data) {
    var streamAES = AesCrypt(data['hash'], 'ctr');
    return streamAES.encrypt(data['password'], data['second_security_key']);
  }

  static String decryptPassword(HashMap<String, String> data) {
    var streamAES = AesCrypt(data['hash'], 'ctr');

    try {
      return streamAES.decrypt(data['hash_password'], data['second_security_key']);
    } catch (e) {
      return "";
    }
  }
}
