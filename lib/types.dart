import 'package:meta_types/meta_types.dart';

@DataClass()
abstract class Reminder {
  String get title;
  Nullable<DateTime> get dateTime;
}
