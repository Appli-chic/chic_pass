import 'dart:math';

import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingItem extends StatefulWidget {
  final String title;
  final bool hasArrowIcon;
  final IconData iconData;
  final String secondaryText;
  final double secondaryTextSize;
  final Function onClick;
  final bool isIconRotating;

  SettingItem({
    @required this.title,
    this.hasArrowIcon = true,
    this.iconData,
    this.secondaryText,
    this.secondaryTextSize,
    this.onClick,
    this.isIconRotating,
  });

  @override
  _SettingItemState createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animationController.repeat();
  }

  Widget _displaysSecondaryText(ThemeProvider themeProvider) {
    if (widget.secondaryText != null) {
      return Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: widget.iconData != null || widget.hasArrowIcon ? 0 : 16),
        child: Text(
          widget.secondaryText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: themeProvider.thirdTextColor,
            fontSize: widget.secondaryTextSize != null
                ? widget.secondaryTextSize
                : 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _displaysIcon(ThemeProvider themeProvider) {
    if (widget.iconData != null) {
      if (widget.isIconRotating) {
        return AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return Transform.rotate(
              angle: animationController.value * 6.3,
              child: child,
            );
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Icon(
              widget.iconData,
              color: themeProvider.thirdTextColor,
            ),
          ),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Icon(
            widget.iconData,
            color: themeProvider.thirdTextColor,
          ),
        );
      }
    } else if (widget.hasArrowIcon) {
      return Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Icon(
          Icons.arrow_forward_ios,
          color: themeProvider.thirdTextColor,
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return GestureDetector(
      onTap: () async {
        if (widget.onClick != null) {
          widget.onClick();
        }
      },
      child: Container(
        height: 56,
        margin: EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: themeProvider.secondBackgroundColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                _displaysSecondaryText(themeProvider),
                _displaysIcon(themeProvider),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
