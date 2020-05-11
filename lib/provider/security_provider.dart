import 'package:chicpass/model/env.dart';
import 'package:chicpass/utils/constant.dart';
import 'package:steel_crypt/steel_crypt.dart';

class SecurityProvider {
  final Env env;

  SecurityProvider({
    this.env,
  });

  String encryptMainPassword(String password) {
    var passHash = PassCrypt('scrypt');
    var hash = passHash.hashPass(env.securityKey, password, 24);
    return hash;
  }

  String encryptSignature(String hash) {
    var streamAES = AesCrypt(hash, 'ctr');
    return streamAES.encrypt(SIGNATURE, env.secondSecurityKey);
  }

  String decryptSignature(String hashedSignature, String hash) {
    var streamAES = AesCrypt(hash, 'ctr');

    try {
      return streamAES.decrypt(hashedSignature, env.secondSecurityKey);
    } catch (e) {
      return "";
    }
  }

  bool isSignatureCorrect(String hashedSignature, String hash) {
    return decryptSignature(hashedSignature, hash) == SIGNATURE;
  }

  String encryptPassword(String password, String hash) {
    var streamAES = AesCrypt(hash, 'ctr');
    return streamAES.encrypt(password, env.secondSecurityKey);
  }

  String decryptPassword(String hashedPassword, String hash) {
    var streamAES = AesCrypt(hash, 'ctr');

    try {
      return streamAES.decrypt(hashedPassword, env.secondSecurityKey);
    } catch (e) {
      return "";
    }
  }
}
