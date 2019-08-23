import 'package:flutter/material.dart';
import "./types.dart";
import 'package:kt_dart/collection.dart';

class ListWidget extends StatelessWidget {

  final KtList<ReminderEntry> entries;

  ListWidget({Key key, @required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: entries.size,
      itemBuilder: (context, i) {
        var item = entries[i];
        return Text(
          item.title + " (" + item.dateTime.toString() + ")"
        );
      }
    );
  }
}
