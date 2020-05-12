import 'package:chicpass/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Input extends StatefulWidget {
  final bool obscureText;
  final EdgeInsetsGeometry margin;
  final String hint;
  final IconData suffixIconData;
  final TextEditingController textController;
  final Function onSuffixIconClicked;
  final TextInputAction textInputAction;
  final TextInputType inputType;
  final FocusNode focus;
  final Function(String) onSubmitted;

  Input({
    this.margin,
    this.focus,
    @required this.hint,
    this.obscureText = false,
    this.suffixIconData,
    this.textController,
    this.onSuffixIconClicked,
    this.textInputAction = TextInputAction.next,
    this.inputType = TextInputType.text,
    this.onSubmitted,
  });

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  ThemeProvider _themeProvider;

  /// Displays a suffix icon in this text form unless there is no one
  Widget _displaySuffixIcon() {
    if (widget.suffixIconData != null) {
      return Material(
        color: _themeProvider.secondBackgroundColor,
        child: IconButton(
          icon: Icon(widget.suffixIconData, color: _themeProvider.secondTextColor),
          onPressed: () {
            widget.onSuffixIconClicked();
          },
        ),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      height: 56,
      margin: widget.margin,
      color: _themeProvider.secondBackgroundColor,
      child: Center(
        child: TextField(
          controller: widget.textController,
          focusNode: widget.focus,
          autocorrect: false,
          obscureText: widget.obscureText,
          keyboardType: widget.inputType,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          style: TextStyle(
            color: _themeProvider.textColor,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            fillColor: _themeProvider.secondBackgroundColor,
            hintStyle: TextStyle(
              color: _themeProvider.secondTextColor,
            ),
            suffixIcon: _displaySuffixIcon(),
            contentPadding: EdgeInsets.only(left: 18,top: 16, bottom: 16, right: 16),
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
