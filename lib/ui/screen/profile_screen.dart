import 'package:chicpass/api/vault_api.dart';
import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/user.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/vault_service.dart';
import 'package:chicpass/ui/component/dialog_message.dart';
import 'package:chicpass/ui/component/loading_dialog.dart';
import 'package:chicpass/ui/component/setting_item.dart';
import 'package:chicpass/utils/security.dart';
import 'package:chicpass/utils/synchronization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ThemeProvider _themeProvider;
  DataProvider _dataProvider;
  bool _isConnected = false;
  User _currentUser;

  @override
  void initState() {
    _getConnectionState();
    super.initState();
  }

  _getConnectionState() async {
    var isConnected = await Security.isConnected();
    _currentUser = await Security.getCurrentUser();

    setState(() {
      _isConnected = isConnected;
    });
  }

  _logout() async {
    var isConfirmed = await DialogMessage.display(
      context,
      _themeProvider,
      title: AppTranslations.of(context).text("warning"),
      body: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              AppTranslations.of(context).text("sure_to_logout"),
              style: TextStyle(color: _themeProvider.textColor),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppTranslations.of(context).text("no")),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text(
            AppTranslations.of(context).text("yes"),
            style: TextStyle(color: _themeProvider.primaryColor),
          ),
          onPressed: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );

    if (isConfirmed) {
      await Security.logout();
      await _getConnectionState();

      if (_isConnected) {
        Synchronization.synchronize(_dataProvider);
      }
    }
  }

  Widget _displaysBodyWhenNotConnected() {
    return Column(
      children: <Widget>[
        SettingItem(
          title: AppTranslations.of(context).text("login"),
          hasArrowIcon: true,
          onClick: () async {
            await Navigator.pushNamed(context, '/login_screen');
            await _getConnectionState();
          },
        ),
      ],
    );
  }

  Widget _displaysBodyWhenConnected() {
    return Column(
      children: <Widget>[
        SettingItem(
          title: AppTranslations.of(context).text("account"),
          hasArrowIcon: false,
          secondaryText: _currentUser.email,
        ),
        SettingItem(
          title: AppTranslations.of(context).text("synchronize_now"),
          iconData: Icons.sync,
          onClick: () {
            Synchronization.synchronize(_dataProvider);
          },
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Container(
            height: 56,
            color: _themeProvider.secondBackgroundColor,
            child: InkWell(
              onTap: _logout,
              child: Center(
                child: Text(
                  AppTranslations.of(context).text("log_out"),
                  style: TextStyle(
                    color: _themeProvider.primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _displaysBody() {
    if (_isConnected) {
      return _displaysBodyWhenConnected();
    } else {
      return _displaysBodyWhenNotConnected();
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _dataProvider = Provider.of<DataProvider>(context, listen: true);

    return LoadingDialog(
      isDisplayed: _dataProvider.isLoading,
      child: Scaffold(
        backgroundColor: _themeProvider.backgroundColor,
        appBar: AppBar(
          leading: BackButton(
            color: _themeProvider.textColor,
          ),
          brightness: _themeProvider.getBrightness(),
          backgroundColor: _themeProvider.secondBackgroundColor,
          title: Text(
            AppTranslations.of(context).text("profile_title"),
            style: TextStyle(color: _themeProvider.textColor),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: _displaysBody(),
        ),
      ),
    );
  }
}
