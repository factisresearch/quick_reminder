import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderEntry {
  final String title;
  final Option<DateTime> dateTime;
  ReminderEntry(this.title, this.dateTime);
}

class Pair<T, U> {
  Pair(this.fst, this.snd);

  final T fst;
  final U snd;

  @override
  String toString() => 'Pair[$fst, $snd]';
}

Option<T> some<T>(T x) {
  return Option.some(x);
}

Option<T> none<T>() {
  return Option.none();
}

class Option<T> {
  final T _value;

  Option.some(T x) : _value = x {
    if (x == null) {
      throw new ArgumentError.notNull("value for some");
    }
  }

  Option.none() : _value = null;

  Option(this._value);

  Option<U> map<U>(U fun(T x)) {
    if (_value != null) {
      var res = fun(_value);
      if (res == null) {
        throw new ArgumentError.notNull("result of mapping function");
      }
      return Option.some(res);
    } else {
      return Option.none();
    }
  }

  void actOn(void fun(T x)) {
    if (_value != null) {
      fun(_value);
    }
  }

  bool hasValue() {
    return _value != null;
  }

  T getValue([String msg]) {
    if (_value != null) {
      return _value;
    } else {
      msg = msg ?? "Option is none";
      throw new AssertionError(msg);
    }
  }

  T toNullable() {
    return _value;
  }
}

class Day {
  static Day today() {
    return Day.fromDateTime(DateTime.now());
  }

  Day.fromDateTime(DateTime t)
    : year = t.year, month = t.month, day = t.day;


  final int year;
  final int month;
  final int day;

  Day({@required this.year, @required this.month, @required this.day});

  Day addDays(int days) {
    var t = toDateTime().add(new Duration(days: days));
    return Day.fromDateTime(t);
  }

  DateTime toDateTime([TimeOfDay t]) {
    if (t != null) {
      return DateTime(year, month, day, t.hour, t.minute);
    } else {
      return DateTime(year, month, day);
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! Day) return false;
    final Day typedOther = other;
    return year == typedOther.year && month == typedOther.month && day == typedOther.day;
  }

  @override
  int get hashCode => hashValues(year, month, day);

}

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

