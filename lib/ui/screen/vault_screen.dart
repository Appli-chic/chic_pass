import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/vault.dart';
import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/service/vault_service.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/component/vault_item.dart';
import 'package:chicpass/utils/synchronization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VaultScreen extends StatefulWidget {
  @override
  _VaultScreenState createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  ThemeProvider _themeProvider;
  DataProvider _dataProvider;
  List<Vault> _vaults = [];

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_dataProvider == null) {
      _dataProvider = Provider.of<DataProvider>(context, listen: true);
      _defineLastSynchronizationDate();
    }
  }

  _defineLastSynchronizationDate() async {
    var date = await Synchronization.getLastSyncDate();
    _dataProvider.setLastSynchronization(date);
  }

  @override
  void initState() {
    _loadVaults();
    super.initState();
  }

  _loadVaults() async {
    _vaults = await VaultService.getAll();
    setState(() {});
  }

  _onDismiss(Vault vault) {
    try {
      _vaults.remove(_vaults.where((e) => e.uid == vault.uid).toList()[0]);
    } catch (e) {
      print(e);
    }
  }

  Widget _displaysEmptyVaults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Image.asset(
            "assets/vault.png",
            width: 60,
            height: 60,
            color: _themeProvider.secondTextColor,
          ),
          Container(
            child: Text(
              AppTranslations.of(context).text("empty_vaults"),
              style: TextStyle(
                color: _themeProvider.secondTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _displaysVaults() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: _vaults.length,
        itemBuilder: (BuildContext context, int index) {
          return VaultItem(
            vault: _vaults[index],
            onTap: _loadVaults,
            onDismiss: _onDismiss,
          );
        },
      ),
    );
  }

  _addNewVault() async {
    await Navigator.pushNamed(context, '/new_vault');
    _loadVaults();
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: _themeProvider.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person, color: _themeProvider.textColor),
          onPressed: () async {
            await Navigator.pushReplacementNamed(context, '/login_screen',
                arguments: true);
          },
        ),
        brightness: _themeProvider.getBrightness(),
        backgroundColor: _themeProvider.secondBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppTranslations.of(context).text("vaults_title"),
          style: TextStyle(
            color: _themeProvider.textColor,
          ),
        ),
        actions: <Widget>[
          IconButton(
            key: const Key("add_appbar"),
            icon: Icon(Icons.add, color: _themeProvider.textColor),
            onPressed: _addNewVault,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _themeProvider.primaryColor,
        child: Icon(
          Icons.add,
          key: const Key("add_fab"),
          color: Colors.white,
        ),
        onPressed: _addNewVault,
      ),
      body: _vaults.isEmpty ? _displaysEmptyVaults() : _displaysVaults(),
    );
  }
}
