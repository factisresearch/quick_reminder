import 'package:flutter/material.dart';
import "./button.dart";

typedef void ButtonGroupCallback(int index, bool enabled);

class ButtonGroup extends StatelessWidget {
  final List<ButtonAttributes> buttonAttributes;
  final ButtonGroupCallback callback;
  final int selectedIndex;

  ButtonGroup(
    {Key key, @required this.buttonAttributes, @required this.callback, this.selectedIndex}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttons = buttonAttributes.asMap().map((index, attrs) {
      final enabled = index == this.selectedIndex;
      return MapEntry(
        index,
        StatelessButton(
          buttonAttributes: attrs,
          enabled: enabled,
          callback: () {
            this.callback(index, !enabled);
          }
        )
      );
    }).values.toList();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons
    );
  }
}
