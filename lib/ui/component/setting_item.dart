import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final bool hasArrowIcon;
  final IconData iconData;
  final String secondaryText;
  final Function onClick;

  SettingItem({
    @required this.title,
    this.hasArrowIcon = true,
    this.iconData,
    this.secondaryText,
    this.onClick,
  });

  Widget _displaysSecondaryText(ThemeProvider themeProvider) {
    if (secondaryText != null) {
      return Padding(
        padding: EdgeInsets.only(
            left: 16, right: iconData != null || hasArrowIcon ? 0 : 16),
        child: Text(
          secondaryText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: themeProvider.thirdTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _displaysArrowIcon(ThemeProvider themeProvider) {
    if (iconData != null) {
      return Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Icon(
          iconData,
          color: themeProvider.thirdTextColor,
        ),
      );
    } else if (hasArrowIcon) {
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
        if(onClick != null) {
          onClick();
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
                  title,
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
                _displaysArrowIcon(themeProvider),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
