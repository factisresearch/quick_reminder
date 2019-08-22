import 'package:flutter/material.dart';
import 'package:quick_reminder/button.dart';
import "./buttonGroup.dart";

class Input extends StatefulWidget {
  Input({Key key}) : super(key: key);

  @override
  _Input createState() => _Input();
}


class _Input extends State<Input> {

  List<String> dayButtons = ["heute", "morgen", "Fr", "Sa", "So", "Mo"];
  List<String> timeButtons = ["7:00", "11:00", "15:00", "19:00", "22:00"];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ButtonGroup(
                  callback: (index, enabled) {
                    print("Button $index is now ${enabled ? 'enabled' : 'disabled'}");
                  },
                  buttonAttributes: dayButtons.map((text) {
                    return new ButtonAttributes(text: text);
                  }).toList()
                ),
                const SizedBox(height: 12),
                ButtonGroup(
                  callback: (index, enabled) {
                    print("Button $index is now ${enabled ? 'enabled' : 'disabled'}");
                  },
                  buttonAttributes: timeButtons.map((text) {
                    return new ButtonAttributes(text: text);
                  }).toList()
                ),
              ]
            ),
            const SizedBox(width: 20),
            Button(
              buttonAttributes: new ButtonAttributes(text: ">>"),
              callback: (bool enabled) {
                print("hit >>");
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
                  //height: 36.0,
                  //width: 300,
                  //padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: TextField(
                    cursorColor: Colors.black,
                  )
                ),
            ),
            FloatingActionButton(
              onPressed: () { print("Pressed +"); },
              tooltip: 'Increment',
              child: Icon(Icons.add),
              mini: true,
            ),
          ]
        )
      ]
    );
  }
}
