import 'dart:convert';

import 'package:chicpass/model/db/vault.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/component/password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class VaultItem extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();
  final storage = FlutterSecureStorage();

  final Vault vault;
  final Function() onTap;

  VaultItem({
    @required this.vault,
    @required this.onTap,
  });

  _askPassword(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        return PasswordDialog(vault: vault);
      },
    );

    onTap();
  }

  _askFingerPrint(BuildContext context, DataProvider dataProvider) async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (canCheckBiometrics) {
      var authenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );

      if (authenticated) {
        String fingerPrintDataString =
            await storage.read(key: env.fingerprintKey);
        dynamic fingerPrintData = json.decode(fingerPrintDataString);

        dataProvider.setHash(fingerPrintData[vault.uid]);
        dataProvider.setVault(vault);

        await Navigator.pushNamed(context, '/main_screen');
      }
    }
  }

  _askFaceRecognition(BuildContext context, DataProvider dataProvider) async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (canCheckBiometrics) {
      var authenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'Scan your face to authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );

      if (authenticated) {
        String faceRecognitionDataString =
            await storage.read(key: env.faceRecognitionKey);
        dynamic faceRecognitionPrintData =
            json.decode(faceRecognitionDataString);

        dataProvider.setHash(faceRecognitionPrintData[vault.uid]);
        dataProvider.setVault(vault);

        await Navigator.pushNamed(context, '/main_screen');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    var dataProvider = Provider.of<DataProvider>(context, listen: true);

    return GestureDetector(
      onTap: () async {
        String fingerPrintDataString =
            await storage.read(key: env.fingerprintKey);

        String faceRecognitionDataString =
            await storage.read(key: env.faceRecognitionKey);

        if (fingerPrintDataString != null &&
            fingerPrintDataString.isNotEmpty &&
            fingerPrintDataString != "{}") {
          dynamic fingerPrintData = json.decode(fingerPrintDataString);

          if (fingerPrintData[vault.uid] != null) {
            _askFingerPrint(context, dataProvider);
          } else {
            _askPassword(context);
          }
        } else if (faceRecognitionDataString != null &&
            faceRecognitionDataString.isNotEmpty &&
            faceRecognitionDataString != "{}") {
          dynamic faceRecognitionData = json.decode(faceRecognitionDataString);

          if (faceRecognitionData[vault.uid] != null) {
            _askFaceRecognition(context, dataProvider);
          } else {
            _askPassword(context);
          }
        } else {
          _askPassword(context);
        }
      },
      child: Container(
        height: 75,
        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
        decoration: BoxDecoration(
          color: themeProvider.secondBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Image.asset(
                "assets/vault.png",
                width: 30,
                height: 30,
                color: themeProvider.textColor,
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  vault.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
