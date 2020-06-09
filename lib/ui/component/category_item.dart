import 'package:chicpass/model/db/category.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  CategoryItem({
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, '/category_passwords_screen', arguments: category);
      },
      child: Container(
        height: 56,
        margin: EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: themeProvider.secondBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Image.asset(
                "assets/category/${category.iconName}",
                color: themeProvider.textColor,
                width: 30,
                height: 30,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  category.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Icon(
                Icons.arrow_forward_ios,
                color: themeProvider.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
