import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

/// Special DateTime to show all sessions on a given day, because
/// `null` indicates an unknown and auto-selects the first time of day.
final dateTimeShowAll = DateTime(1900);

extension DateTimeExtension on DateTime {
  DateTime get date => DateTime(year, month, day);
  DateTime get time => DateTime(1901, 1, 1, hour, minute);

  String format(DateFormat formatter) =>
      this == dateTimeShowAll ? 'Show All' : formatter.format(this);

  DateTime snappedTo(Set<DateTime> dates) => dates
      .sorted((a, b) =>
          a.difference(this).abs().compareTo(b.difference(this).abs()))
      .first;

  DateTime snappedToSameDay(Set<DateTime> dates) {
    // Get the current date
    final currentDate = DateTime(year, month, day);

    // Sort the dates by their absolute distance from the target date
    final sortedDates = dates.toList()
      ..sort((a, b) =>
          a.difference(this).abs().compareTo(b.difference(this).abs()));

    // Iterate over the sorted dates and return the first date on the same day
    for (final date in sortedDates) {
      if (date.year == currentDate.year &&
          date.month == currentDate.month &&
          date.day == currentDate.day) {
        return date;
      }
    }

    // If no dates on the same day are found, return the closest date
    return sortedDates.first;
  }

  DateTime constrainedTo(Set<DateTime> dates) =>
      dates.firstWhereOrNull((date) => date == this) ?? dates.first;
}
