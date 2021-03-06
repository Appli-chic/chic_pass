import 'package:chicpass/provider/data_provider.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/ui/component/clipper/half_circle_clipper.dart';
import 'package:chicpass/ui/screen/profile_screen.dart';
import 'package:chicpass/ui/screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'category_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ThemeProvider _themeProvider;
  DataProvider _dataProvider;
  PageController _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Changes the displayed tab to the specified [index]
  _onTabClicked(int index) {
    if (!_dataProvider.isLoading) {
      if (_index != index) {
        setState(() {
          _index = index;
        });

        _pageController.jumpToPage(_index);
      }
    }
  }

  BottomNavigationBar _displayBottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: _themeProvider.secondBackgroundColor,
      elevation: 0,
      currentIndex: _index,
      onTap: _onTabClicked,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/list.png',
            color: _themeProvider.navigationIconColor,
            width: 30,
            height: 30,
          ),
          activeIcon: Image.asset(
            'assets/list.png',
            color: _themeProvider.primaryColor,
            width: 30,
            height: 30,
          ),
          title: const SizedBox(),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/folder.png',
            color: _themeProvider.navigationIconColor,
            width: 30,
            height: 30,
          ),
          activeIcon: Image.asset(
            'assets/folder.png',
            color: _themeProvider.primaryColor,
            width: 30,
            height: 30,
          ),
          title: const SizedBox(),
        ),
        BottomNavigationBarItem(
          icon: const SizedBox(),
          title: const SizedBox(),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/user.png',
            color: _themeProvider.navigationIconColor,
            width: 30,
            height: 30,
          ),
          activeIcon: Image.asset(
            'assets/user.png',
            color: _themeProvider.primaryColor,
            width: 30,
            height: 30,
          ),
          title: const SizedBox(),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/settings.png',
            color: _themeProvider.navigationIconColor,
            width: 30,
            height: 30,
          ),
          activeIcon: Image.asset(
            'assets/settings.png',
            color: _themeProvider.primaryColor,
            width: 30,
            height: 30,
          ),
          title: const SizedBox(),
        ),
      ],
    );
  }

  Widget _displaysFloatingButton() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        ClipPath(
          clipper: HalfCircleClipper(),
          child: Container(
            height: 86,
            width: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _themeProvider.backgroundColor,
            ),
          ),
        ),
        SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            onPressed: () async {
              if (!_dataProvider.isLoading) {
                await Navigator.pushNamed(context, '/new_password_screen');
                _dataProvider.reloadHome();
                _dataProvider.reloadCategory();
              }
            },
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _themeProvider.primaryColor,
              ),
              child: Icon(Icons.add, size: 40),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _dataProvider = Provider.of<DataProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: _themeProvider.backgroundColor,
      bottomNavigationBar: _displayBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
          ? _displaysFloatingButton()
          : null,
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomeScreen(),
          CategoryScreen(),
          Container(),
          ProfileScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }
}
