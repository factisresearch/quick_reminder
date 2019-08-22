import 'package:flutter/material.dart';
import "./button.dart";

typedef void ButtonGroupCallback(int index, bool enabled);

class ButtonGroup extends StatefulWidget {
  final List<ButtonAttributes> buttonAttributes;
  final ButtonGroupCallback callback;

  ButtonGroup(
    {Key key, @required this.buttonAttributes, @required this.callback}
  ) : super(key: key);

  @override
  _ButtonGroupState createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {

  int _indexOfEnabledButton = -1;

  _buttonPressed(int index) {
    var newIndexOfEnabledButton = (index == _indexOfEnabledButton) ? -1 : index;
    setState(() {
      _indexOfEnabledButton = newIndexOfEnabledButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    var buttons = widget.buttonAttributes.asMap().map((index, attrs) {
        return MapEntry(
          index,
          StatelessButton(
            buttonAttributes: attrs,
            enabled: index == this._indexOfEnabledButton,
            callback: () {
              this._buttonPressed(index);
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
