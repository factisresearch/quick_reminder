import 'package:flutter/material.dart';
import "./types.dart";
import 'package:intl/intl.dart';
import 'package:kt_dart/collection.dart';

const double itemHeight = 30;

typedef void ListWidgetDeleteCallback(int idx);

final dateFormatter = new DateFormat('dd.MM.yyyy');

String formatDate(DateTime t, Day today) {
  final day = Day.fromDateTime(t);
  if (day == today) {
    return "heute";
  } else if (day == today.addDays(1)) {
    return "morgen";
  } else {
    return dateFormatter.format(t);
  }
}

final timeFormatter = new DateFormat("HH:mm");

String formatDateTime(DateTime t, Day today) {
  final date = formatDate(t, today);
  final time = timeFormatter.format(t) + " Uhr";
  return date + ", " + time;
}

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
    var today = Day.today();
    var w = ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      itemCount: entries.size ,
      itemBuilder: (context, idx) {
        final item = entries[idx];
        var title = item.title;
        final tOpt = item.dateTime;
        if (tOpt.hasValue()) {
          final t = tOpt.getValue();
          final fmt = formatDateTime(t, today);
          title = title + " (" + fmt + ")";
        }
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
                Text(title)
              ]
            )
        );
      }
    );
    return w;
  }
}
