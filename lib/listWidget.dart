import 'package:flutter/material.dart';
import "./types.dart";
import 'package:kt_dart/collection.dart';

const double itemHeight = 30;

typedef void ListWidgetDeleteCallback(int idx);

class ListWidget extends StatelessWidget {

  final KtList<ReminderEntry> entries;
  final ScrollController scrollController;
  final ListWidgetDeleteCallback deleteCallback;

  ListWidget({
    Key key,
    @required this.entries,
    @required this.scrollController,
    @required this.deleteCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      itemCount: entries.size ,
      itemBuilder: (context, idx) {
        var item = entries[idx];
        return Container(
          height: itemHeight,
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          child:
            Row(
              children: [
                GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () {
                    deleteCallback(idx);
                  }
                ),
                Text(
                  item.title + " (" + item.dateTime.toString() + ")"
                )
              ]
            )
        );
      }
    );
    return w;
  }
}
