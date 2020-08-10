import 'package:chicpass/localization/app_translations.dart';
import 'package:chicpass/model/db/entry.dart';
import 'package:chicpass/provider/theme_provider.dart';
import 'package:chicpass/service/entry_serice.dart';
import 'package:chicpass/ui/component/dialog_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordItem extends StatelessWidget {
  final Entry entry;
  final Function(Entry) onDismiss;

  PasswordItem({
    @required this.entry,
    @required this.onDismiss,
  });

  Future<bool> _onConfirmDismiss(DismissDirection direction,
      BuildContext context, ThemeProvider themeProvider) async {
    return await DialogMessage.display(
      context,
      themeProvider,
      title: AppTranslations.of(context).text("warning"),
      body: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              AppTranslations.of(context).text("entry_sure_to_delete"),
              style: TextStyle(color: themeProvider.textColor),
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
            style: TextStyle(color: themeProvider.primaryColor),
          ),
          onPressed: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

  _onDismiss(BuildContext context, ThemeProvider themeProvider) async {
    await EntryService.delete(entry);
    onDismiss(entry);
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Dismissible(
      key: Key("password_item${entry.uid}"),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return _onConfirmDismiss(direction, context, themeProvider);
      },
      onDismissed: (direction) {
        _onDismiss(context, themeProvider);
      },
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: GestureDetector(
        onTap: () async {
          await Navigator.pushNamed(context, '/entry_details_screen',
              arguments: entry);
        },
        child: Container(
          height: 75,
          margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: themeProvider.secondBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 16),
                child: Image.asset(
                  "assets/category/${entry.category.iconName}",
                  width: 30,
                  height: 30,
                  color: themeProvider.textColor,
                ),
              ),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: themeProvider.textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      entry.login,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: themeProvider.secondTextColor,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
