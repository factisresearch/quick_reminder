import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:quick_reminder/button.dart';
import 'package:quick_reminder/types.dart';
import "./buttonGroup.dart";

typedef void InputCallback(ReminderEntry entry);

class Input extends StatefulWidget {
  final InputCallback callback;

  Input({Key key, @required this.callback}) : super(key: key);

  @override
  _Input createState() => _Input(callback);
}

List<Pair<String, Day>> makeDayList() {
  var now = DateTime.now();
  var today = Day.fromDateTime(now);
  var weekday = now.weekday;
  var result = [
    Pair("heute", today),
    Pair("morgen", today.addDays(1))
  ];
  void add(List<String> labels, int offset) {
    for (var i = 0; i < labels.length; i++) {
      result.add(Pair(labels[i], today.addDays(offset + i)));
    }
  }
  switch (weekday) {
    case DateTime.monday:
        add(["Fr", "Sa", "So", "Mo"], 4);
        break;
    case DateTime.tuesday:
        add(["Fr", "Sa", "So", "Mo"], 3);
        break;
    case DateTime.wednesday:
        add(["Fr", "Sa", "So", "Mo"], 2);
        break;
    case DateTime.thursday:
        add(["Sa", "So", "Mo", "Di"], 2);
        break;
    case DateTime.friday:
        add(["So", "Mo", "Di", "Mi"], 2);
        break;
    case DateTime.saturday:
        add(["Mo", "Di", "Mi", "Do"], 2);
        break;
    case DateTime.sunday:
        add(["Di", "Mi", "Do", "Fr"], 2);
        break;
  }
  return result;
}

class _Input extends State<Input> {

  int _selectedDayIndex;
  int _selectedTimeIndex;
  DateTime _explicitedDateTime;
  bool _textFocused;
  TextEditingController _controller;
  final FocusNode focusNode = FocusNode();

  final List<Pair<String, Day>> dayButtons = makeDayList();
  final List<Pair<String, TimeOfDay>> timeButtons =
    [
      Pair("7:00", TimeOfDay(hour: 7, minute: 0)),
      Pair("11:00", TimeOfDay(hour: 11, minute: 0)),
      Pair("15:00", TimeOfDay(hour: 15, minute: 0)),
      Pair("19:00", TimeOfDay(hour: 19, minute: 0)),
      Pair("22:00", TimeOfDay(hour: 22, minute: 0))
    ];
  final InputCallback callback;

  _Input(this.callback);

  @override
  void initState() {
    super.initState();
    _selectedDayIndex = -1;
    _selectedTimeIndex = -1;
    _explicitedDateTime = null;
    _textFocused = true;
    _controller = new TextEditingController();
  }

  Option<DateTime> getDateTime() {
    if (_explicitedDateTime != null) {
      return some(_explicitedDateTime);
    } else if (_selectedDayIndex >= 0 && _selectedTimeIndex >= 0) {
      var day = dayButtons[_selectedDayIndex].snd;
      var time = timeButtons[_selectedTimeIndex].snd;
      return some(day.toDateTime(time));
    } else {
      return none();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget quickButtonsOrText;
    final today = Day.today();
    const buttonGroupSpacing = 12.0;
    if (_explicitedDateTime != null) {
      quickButtonsOrText =
        Container(
          height: 2 * buttonHeight + buttonGroupSpacing,
          padding: buttonPadding,
          margin: buttonMargin,
          alignment: Alignment.center,
          child: Text(formatDateTime(_explicitedDateTime, today))
        );
    } else {
      quickButtonsOrText =
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ButtonGroup(
              selectedIndex: this._selectedDayIndex,
              callback: (index, enabled) {
                setState(() {
                  if (enabled) {
                    _selectedDayIndex = index;
                  } else {
                    _selectedDayIndex = -1;
                  }
                });
              },
              buttonAttributes: dayButtons.map((p) {
                return new ButtonAttributes(text: p.fst);
              }).toList()
            ),
            const SizedBox(height: buttonGroupSpacing),
            ButtonGroup(
              selectedIndex: this._selectedTimeIndex,
              callback: (index, enabled) {
                setState(() {
                  if (enabled) {
                    _selectedTimeIndex = index;
                  } else {
                    _selectedTimeIndex = -1;
                  }
                });
              },
              buttonAttributes: timeButtons.map((p) {
                return new ButtonAttributes(text: p.fst);
              }).toList()
            ),
          ]
        );
    }
    var result = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: quickButtonsOrText),
            const SizedBox(width: 20),
            GestureDetector(
              child: Container(
                height: buttonHeight,
                margin: const EdgeInsets.symmetric(horizontal: 9.0),
                child: Icon(Icons.date_range, size: buttonHeight * 0.9)
              ),
              onTap: () async {
                setState(() {
                  _textFocused = false;
                });
                await DatePicker.showDateTimePicker(
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
                setState(() {
                  _textFocused = true;
                });
              }
            ),
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
                    focusNode: focusNode,
                    autofocus: true,
                    controller: _controller,
                  )
                ),
            ),
            FloatingActionButton(
              onPressed: () {
                var title = _controller.text.trim();
                if (title == "") {
                  return;
                }
                var entry = new ReminderEntry(title, getDateTime());
                setState(() {
                  _explicitedDateTime = null;
                  _selectedDayIndex = -1;
                  _selectedTimeIndex = -1;
                  _controller.clear();
                });
                callback(entry);
              },
              child: Icon(Icons.add),
              mini: true,
            ),
          ]
        )
      ]
    );
    if (_textFocused) {
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
    }
    return result;
  }
}
