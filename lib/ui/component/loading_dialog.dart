import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';

class LoadingDialog extends StatefulWidget {
  final Widget child;
  final bool isDisplayed;

  LoadingDialog({
    @required this.child,
    @required this.isDisplayed,
  });

  @override
  State<StatefulWidget> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    if (widget.isDisplayed) {
      return Stack(
        children: <Widget>[
          widget.child,
          Opacity(
            child: Container(
              color: _themeProvider.backgroundColor,
              child: ModalBarrier(dismissible: false),
            ),
            opacity: 0.3,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: _themeProvider.secondBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              width: 100,
              height: 100,
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      _themeProvider.primaryColor),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return widget.child;
    }
  }
}
