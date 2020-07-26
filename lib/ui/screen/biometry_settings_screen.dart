import 'dart:collection';
import 'dart:convert';

import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/main.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/component/password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class BiometrySettingsScreen extends StatefulWidget {
  @override
  _BiometrySettingsScreenState createState() => _BiometrySettingsScreenState();
}

class _BiometrySettingsScreenState extends State<BiometrySettingsScreen> {
  ThemeProvider _themeProvider;
  DataProvider _dataProvider;
  final LocalAuthentication auth = LocalAuthentication();
  final storage = FlutterSecureStorage();
  bool _isFingerPrintActivated = false;
  bool _isFaceRecognitionActivated = false;
  bool _isFingerPrintLocked = false;
  bool _isFaceRecognitionLocked = false;

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_dataProvider == null) {
      _dataProvider = Provider.of<DataProvider>(context, listen: true);
      _loadBiometryPreferences();
    }
  }

  @override
  void initState() {
    _checkBiometry();
    super.initState();
  }

  _checkBiometry() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (!availableBiometrics.contains(BiometricType.fingerprint)) {
      setState(() {
        _isFingerPrintLocked = true;
      });
    }

    if (!availableBiometrics.contains(BiometricType.face)) {
      setState(() {
        _isFaceRecognitionLocked = true;
      });
    }
  }

  _loadBiometryPreferences() async {
    String fingerPrintDataString = await storage.read(key: env.fingerprintKey);

    if (fingerPrintDataString != null &&
        fingerPrintDataString.isNotEmpty &&
        fingerPrintDataString != "{}") {
      dynamic fingerPrintData = json.decode(fingerPrintDataString);

      // If it is not null then the finger print is activated and the password is stored in it
      if (fingerPrintData[_dataProvider.vault.uid] != null) {
        setState(() {
          _isFingerPrintActivated = true;
        });
      }
    }

    // Face recognition
    String faceRecognitionDataString =
        await storage.read(key: env.faceRecognitionKey);

    if (faceRecognitionDataString != null &&
        faceRecognitionDataString.isNotEmpty &&
        faceRecognitionDataString != "{}") {
      dynamic faceRecognitionData = json.decode(faceRecognitionDataString);

      // If it is not null then the finger print is activated and the password is stored in it
      if (faceRecognitionData[_dataProvider.vault.uid] != null) {
        setState(() {
          _isFaceRecognitionActivated = true;
        });
      }
    }
  }

  _askPassword(bool isFingerPrint) {
    showDialog(
      context: context,
      builder: (_) {
        return PasswordDialog(
          vault: _dataProvider.vault,
          onSubmit: isFingerPrint
              ? _onSubmitPasswordFingerPrint
              : _onSubmitPasswordFaceRecognition,
        );
      },
    );
  }

  _onSubmitPasswordFaceRecognition(String password) async {
    String faceRecognitionDataString =
        await storage.read(key: env.faceRecognitionKey);
    dynamic faceRecognitionPrintData = HashMap();

    if (faceRecognitionDataString != null &&
        faceRecognitionDataString.isNotEmpty &&
        faceRecognitionDataString != "{}") {
      faceRecognitionPrintData = json.decode(faceRecognitionDataString);
    }

    faceRecognitionPrintData[_dataProvider.vault.uid] = password;

    await storage.write(
        key: env.faceRecognitionKey,
        value: json.encode(faceRecognitionPrintData));

    setState(() {
      _isFaceRecognitionActivated = true;
    });
  }

  _onSubmitPasswordFingerPrint(String password) async {
    String fingerPrintDataString = await storage.read(key: env.fingerprintKey);
    dynamic fingerPrintData = HashMap();

    if (fingerPrintDataString != null &&
        fingerPrintDataString.isNotEmpty &&
        fingerPrintDataString != "{}") {
      fingerPrintData = json.decode(fingerPrintDataString);
    }

    fingerPrintData[_dataProvider.vault.uid] = password;

    await storage.write(
        key: env.fingerprintKey, value: json.encode(fingerPrintData));

    setState(() {
      _isFingerPrintActivated = true;
    });
  }

  _onFingerPrintChange(bool value) async {
    if (value) {
      _askPassword(true);
    } else {
      String fingerPrintDataString =
          await storage.read(key: env.fingerprintKey);

      if (fingerPrintDataString != null && fingerPrintDataString.isNotEmpty) {
        dynamic fingerPrintData = json.decode(fingerPrintDataString);
        fingerPrintData.remove(_dataProvider.vault.uid);

        await storage.write(
            key: env.fingerprintKey, value: json.encode(fingerPrintData));
      }

      setState(() {
        _isFingerPrintActivated = value;
      });
    }
  }

  _onFaceRecognitionChange(bool value) async {
    if (value) {
      _askPassword(false);
    } else {
      String faceRecognitionDataString =
          await storage.read(key: env.faceRecognitionKey);

      if (faceRecognitionDataString != null &&
          faceRecognitionDataString.isNotEmpty) {
        dynamic faceRecognitionData = json.decode(faceRecognitionDataString);
        faceRecognitionData.remove(_dataProvider.vault.uid);

        await storage.write(
            key: env.faceRecognitionKey,
            value: json.encode(faceRecognitionData));
      }

      setState(() {
        _isFaceRecognitionActivated = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: _themeProvider.backgroundColor,
      appBar: AppBar(
        leading: BackButton(
          color: _themeProvider.textColor,
        ),
        brightness: _themeProvider.getBrightness(),
        backgroundColor: _themeProvider.secondBackgroundColor,
        title: Text(
          AppTranslations.of(context).text("biometry"),
          style: TextStyle(color: _themeProvider.textColor),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          _isFingerPrintLocked
              ? Container()
              : Container(
                  height: 56,
                  margin: EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: _themeProvider.secondBackgroundColor,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            AppTranslations.of(context).text("fingerprint"),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _themeProvider.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 16),
                        child: Switch(
                          value: _isFingerPrintActivated,
                          onChanged: _onFingerPrintChange,
                        ),
                      ),
                    ],
                  ),
                ),
          _isFaceRecognitionLocked
              ? Container()
              : Container(
                  height: 56,
                  margin: EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: _themeProvider.secondBackgroundColor,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            AppTranslations.of(context).text("face_unlock"),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _themeProvider.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 16),
                        child: Switch(
                          value: _isFaceRecognitionActivated,
                          onChanged: _onFaceRecognitionChange,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
