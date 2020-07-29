import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldType {
  const TextFieldType._(this.index);

  final int index;

  static const TextFieldType text = TextFieldType._(0);

  static const TextFieldType date = TextFieldType._(1);

  static const TextFieldType select = TextFieldType._(2);

  static const TextFieldType multipleSelect = TextFieldType._(3);
}

class Input extends StatefulWidget {
  final Key key;
  final bool obscureText;
  final bool readOnly;
  final EdgeInsetsGeometry margin;
  final String hint;
  final IconData suffixIconData;
  final IconData prefixIconData;
  final TextEditingController textController;
  final Function onSuffixIconClicked;
  final TextInputAction textInputAction;
  final TextInputType inputType;
  final TextCapitalization textCapitalization;
  final FocusNode focus;
  final Widget suffix;
  final Function(String) onSubmitted;
  final Function(String) onTextChanged;
  final TextFieldType fieldType;
  final List<String> listFields;
  final Function singleSelectChoose;
  final int singleSelectDefaultIndex;
  final Function(String) onClick;

  Input({
    this.key,
    this.margin,
    this.focus,
    @required this.hint,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIconData,
    this.prefixIconData,
    this.textController,
    this.onSuffixIconClicked,
    this.textInputAction = TextInputAction.next,
    this.inputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.suffix,
    this.onSubmitted,
    this.onTextChanged,
    this.fieldType = TextFieldType.text,
    this.listFields,
    this.singleSelectChoose,
    this.singleSelectDefaultIndex,
    this.onClick,
  });

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  ThemeProvider _themeProvider;

  /// Displays a suffix icon in this text form unless there is no one
  Widget _displaySuffixIcon() {
    return Material(
      color: _themeProvider.secondBackgroundColor,
      child: IconButton(
        icon: Icon(widget.suffixIconData, color: _themeProvider.thirdTextColor),
        onPressed: () {
          widget.onSuffixIconClicked();
        },
      ),
    );
  }

  Widget _displayPrefixIcon() {
    if (widget.prefixIconData != null) {
      return Material(
        color: _themeProvider.secondBackgroundColor,
        child: IconButton(
          icon:
              Icon(widget.prefixIconData, color: _themeProvider.thirdTextColor),
          onPressed: () {},
        ),
      );
    } else {
      return null;
    }
  }

  Widget _displaySuffix() {
    if (widget.suffix != null) {
      return widget.suffix;
    } else if (widget.suffixIconData != null) {
      return _displaySuffixIcon();
    } else {
      return Container();
    }
  }

  _onSelectInputClicked() async {
    FixedExtentScrollController scrollController = FixedExtentScrollController(
        initialItem: widget.singleSelectDefaultIndex);

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: CupertinoPicker(
            scrollController: scrollController,
            backgroundColor: _themeProvider.secondBackgroundColor,
            itemExtent: 30,
            onSelectedItemChanged: (int index) {
              widget.textController.text = widget.listFields[index];
            },
            children:
                List<Widget>.generate(widget.listFields.length, (int index) {
              return Center(
                child: Text(
                  widget.listFields[index],
                  style: TextStyle(
                    color: _themeProvider.textColor,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );

    widget.singleSelectChoose();
  }

  bool _isReadOnly() {
    if (widget.readOnly) {
      return true;
    } else {
      return widget.fieldType == TextFieldType.date ||
              widget.fieldType == TextFieldType.select ||
              widget.fieldType == TextFieldType.multipleSelect
          ? true
          : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      height: 56,
      margin: widget.margin,
      child: Material(
        color: _themeProvider.secondBackgroundColor,
        child: InkWell(
          onTap: () {},
          child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: widget.textController,
                    focusNode: widget.focus,
                    autocorrect: false,
                    obscureText: widget.obscureText,
                    keyboardType: widget.inputType,
                    textCapitalization: widget.textCapitalization,
                    textInputAction: widget.textInputAction,
                    onSubmitted: widget.onSubmitted,
                    onChanged: widget.onTextChanged,
                    style: TextStyle(
                      color: _themeProvider.textColor,
                    ),
                    readOnly: _isReadOnly(),
                    onTap: () {
                      if (widget.fieldType == TextFieldType.select) {
                        _onSelectInputClicked();
                      } else if (widget.fieldType == TextFieldType.text &&
                          widget.onClick != null) {
                        widget.onClick(widget.textController.text);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        color: _themeProvider.thirdTextColor,
                      ),
                      prefixIcon: _displayPrefixIcon(),
                      contentPadding: EdgeInsets.only(
                          left: 18, top: 16, bottom: 16, right: 16),
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                  ),
                ),
                _displaySuffix(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
