import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:quick_reminder/button.dart';
import "./buttonGroup.dart";

class Input extends StatefulWidget {
  Input({Key key}) : super(key: key);

  @override
  _Input createState() => _Input();
}


class _Input extends State<Input> {

  int _selectedDayIndex = -1;
  int _selectedTimeIndex = -1;
  DateTime _explicitedDateTime = null;

  List<String> dayButtons = ["heute", "morgen", "Fr", "Sa", "So", "Mo"];
  List<String> timeButtons = ["7:00", "11:00", "15:00", "19:00", "22:00"];

  @override
  Widget build(BuildContext context) {
    Widget quickButtonsOrText;
    if (_explicitedDateTime != null) {
      quickButtonsOrText = Text(_explicitedDateTime.toString());
    } else {
      quickButtonsOrText =
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ButtonGroup(
              callback: (index, enabled) {
                setState(() {
                  if (enabled) {
                    _selectedDayIndex = index;
                  } else {
                    _selectedDayIndex = -1;
                  }
                });
                print("Button $index is now ${enabled ? 'enabled' : 'disabled'}");
              },
              buttonAttributes: dayButtons.map((text) {
                return new ButtonAttributes(text: text);
              }).toList()
            ),
            const SizedBox(height: 12),
            ButtonGroup(
              callback: (index, enabled) {
                setState(() {
                  if (enabled) {
                    _selectedTimeIndex = index;
                  } else {
                    _selectedTimeIndex = -1;
                  }
                });
                print("Button $index is now ${enabled ? 'enabled' : 'disabled'}");
              },
              buttonAttributes: timeButtons.map((text) {
                return new ButtonAttributes(text: text);
              }).toList()
            ),
          ]
        );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            quickButtonsOrText,
            const SizedBox(width: 20),
            Button(
              buttonAttributes: new ButtonAttributes(text: ">>"),
              callback: (bool enabled) {
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  onConfirm: (date) {
                    setState(() {
                      _explicitedDateTime = date;
                    });
                    print('confirm $date');
                  },
                  currentTime: DateTime.now(),
                  locale: LocaleType.de
                );
              },
            )
          ]
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child:
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: TextField(
                    cursorColor: Colors.black,
                  )
                ),
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _explicitedDateTime = null;
                  _selectedDayIndex = -1;
                  _selectedTimeIndex = -1;
                });
                print("Pressed +");
              },
              child: Icon(Icons.add),
              mini: true,
            ),
          ]
        )
      ]
    );
  }
}
