import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime get date => DateTime(year, month, day);

  String get formatWithWeekday => DateFormat('EEEE, MMMM d').format(this);

  DateTime constrainedTo(Set<DateTime> dates) =>
      dates.firstWhereOrNull((date) => date == this) ?? dates.first;
}
