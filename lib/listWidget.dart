import 'package:flutter/material.dart';
import "./types.dart";
import 'package:kt_dart/collection.dart';

const double itemHeight = 40;

class ListWidget extends StatelessWidget {

  final KtList<ReminderEntry> entries;
  final ScrollController scrollController;

  ListWidget({Key key, @required this.entries, @required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      itemCount: entries.size ,
      itemBuilder: (context, i) {
        var item = entries[i];
        return Container(
          height: itemHeight,
          child:
            Text(
              item.title + " (" + item.dateTime.toString() + ")"
            )
        );
      }
    );
    return w;
  }
}
