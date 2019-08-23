import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_reminder/types.dart';
import './input.dart';
import "./listWidget.dart";
import 'package:kt_dart/collection.dart';

void main() => runApp(QuickReminderApp());

class QuickReminderApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var title = "Quick Reminder";
    return MaterialApp(
      title: title,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: QuickReminderMainWidget(title: title),
    );
  }
}

class QuickReminderMainWidget extends StatefulWidget {
  QuickReminderMainWidget({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  _QuickReminderMainWidgetState createState() => _QuickReminderMainWidgetState();
}

class _QuickReminderMainWidgetState extends State<QuickReminderMainWidget> {

  static const platform = const MethodChannel('com.factisresearch/reminders');

  KtList<ReminderEntry> _entries;
  ScrollController _scrollController;

  @override
  void initState() {
    _entries = KtList.empty();
    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: false,
    );
    super.initState();
  }

  void _toEnd() {
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
  }

  void _deleteEntry(int idx) {
    setState(() {
      _entries = _entries.filterIndexed((i, elem) {
        return i != idx;
      });
    });
  }

  Future<void> _createReminder(ReminderEntry entry) async {
    try {
      List<dynamic> args = [entry.title];
      entry.dateTime.actOn((x) {
        var secs = x.millisecondsSinceEpoch / 1000;
        args.add(secs);
      });
      await platform.invokeMethod(
        'createReminder', args
      );
      print("Reminder created successfully");
    } on PlatformException catch (e) {
      print("Could not create reminder: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: ListWidget(
                entries: _entries,
                scrollController: _scrollController,
                deleteCallback: _deleteEntry),
            ),
            const SizedBox(height: 10),
            Input(
              callback: (entry) async {
                setState(() {
                  _entries = _entries.plusElement(entry);
                });
                WidgetsBinding.instance.addPostFrameCallback((d) {
                  _toEnd();
                });
                await _createReminder(entry);
              }
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
