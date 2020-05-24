import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VaultItem extends StatelessWidget {
  final String title;

  VaultItem({
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, '/main_screen');
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
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  title,
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
