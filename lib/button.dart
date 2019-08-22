import 'package:flutter/material.dart';

class ButtonAttributes {
  final String text;
  ButtonAttributes({@required this.text});
}

Widget renderButton(ButtonAttributes attrs, StatelessButtonCallback cb, bool enabled) {
    var bgColor = enabled ? Colors.blue : Colors.blueGrey;
    var textColor = enabled ? Colors.white : Colors.white;
    return GestureDetector(
      onTap: cb,
      child: Container(
        height: 36.0,
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: bgColor,
        ),
        child: Center(
          child: Text(
            attrs.text,
            style: TextStyle(color: textColor),
          ),
        ),
      )
    );
}

typedef void StatelessButtonCallback();

class StatelessButton extends StatelessWidget {
  final ButtonAttributes buttonAttributes;
  final StatelessButtonCallback callback;
  final bool enabled;

  StatelessButton(
    {Key key, @required this.buttonAttributes, @required this.enabled, @required this.callback}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return renderButton(buttonAttributes, callback, enabled);
  }
}

typedef void ButtonCallback(bool enabled);

class Button extends StatefulWidget {

  final ButtonAttributes buttonAttributes;
  final ButtonCallback callback;

  Button({Key key, @required this.buttonAttributes, @required this.callback}) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {

  bool _enabled = false;

  void toggle() {
    setButtonState(!_enabled);
  }

  void setButtonState(bool enabled) {
    setState(() {
      _enabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cb = () {
      var oldState = this._enabled;
      toggle();
      widget.callback(!oldState);
    };
    return renderButton(widget.buttonAttributes, cb, this._enabled);
  }
}
