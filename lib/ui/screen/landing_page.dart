import 'package:chicpass/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    _isFirstConnection();
    super.initState();
  }

  _isFirstConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(FIRST_CONNECTION_KEY) != null &&
        prefs.getBool(FIRST_CONNECTION_KEY)) {
      await Navigator.pushReplacementNamed(context, '/vaults');
    } else {
      prefs.setBool(FIRST_CONNECTION_KEY, true);
      await Navigator.pushReplacementNamed(context, '/login_screen',
          arguments: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
