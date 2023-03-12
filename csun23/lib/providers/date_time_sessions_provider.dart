import 'package:collection/collection.dart';
import 'package:csun23/extensions/date_time_extension.dart';
import 'package:csun23/providers/all_sessions_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/session.dart';
import 'selected_date_provider.dart';
import 'selected_time_provider.dart';
import 'session_dates_provider.dart';

final dateTimeSessionsProvider =
    FutureProvider.autoDispose<List<Session>>((ref) async {
  final allDates = await ref.watch(sessionDatesProvider.future);
  final allSessions = await ref.watch(allSessionsProvider.future);
  final allSessionsSortedByDate =
      allSessions.sorted((a, b) => a.dateTime.compareTo(b.dateTime));
  final allTimes =
      allSessionsSortedByDate.map((session) => session.dateTime).toSet();
  final selectedDate = ref.watch(selectedDateProvider);
  final selectedDateNotifier = ref.watch(selectedDateProvider.notifier);
  final selectedDateTime = ref.watch(selectedDateTimeProvider);
  final selectedDateTimeNotifier = ref.watch(selectedDateTimeProvider.notifier);
  DateTime date;

  if (selectedDate == dateTimeShowAll) {
    return allSessionsSortedByDate;
  }

  if (selectedDate == null) {
    date = allSessionsSortedByDate
        .map((session) => session.dateTime.date)
        .toSet()
        .first;

    selectedDateNotifier.setDateTime(date);
  } else {
    date = selectedDate.snappedTo(allDates);
  }

  DateTime dateTime;
  if (selectedDateTime == null) {
    dateTime = allSessionsSortedByDate
        .map((session) => session.dateTime)
        .where((dateTime) => dateTime.date == date)
        .toSet()
        .first;

    selectedDateTimeNotifier.setDateTime(dateTime);
  } else {
    dateTime = selectedDateTime.snappedTo(allTimes);
  }

  if (selectedDateTime == dateTimeShowAll) {
    return allSessionsSortedByDate
        .where((session) => session.dateTime.date == date.date)
        .toList();
  }
  return allSessionsSortedByDate
      .where((session) => session.dateTime == dateTime)
      .toList();
});
