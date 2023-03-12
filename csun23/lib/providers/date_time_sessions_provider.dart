import 'package:collection/collection.dart';
import 'package:csun23/extensions/date_time_extension.dart';
import 'package:csun23/providers/all_sessions_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/session.dart';
import 'selected_date_provider.dart';
import 'selected_time_provider.dart';

final dateTimeSessionsProvider =
    FutureProvider.autoDispose<List<Session>>((ref) async {
  final allSessions = await ref.watch(allSessionsProvider.future);
  final selectedDate = ref.watch(selectedDateProvider);
  final selectedDateNotifier = ref.watch(selectedDateProvider.notifier);
  final selectedDateTime = ref.watch(selectedDateTimeProvider);
  final selectedDateTimeNotifier = ref.watch(selectedDateTimeProvider.notifier);
  DateTime date;
  if (selectedDate == null) {
    date = allSessions
        .map((session) => session.dateTime.date)
        .toSet()
        .sorted((a, b) => a.compareTo(b))
        .first;

    selectedDateNotifier.setDateTime(date);
  } else {
    date = selectedDate;
  }

  DateTime dateTime;
  if (selectedDateTime == null) {
    dateTime = allSessions
        .map((session) => session.dateTime)
        .where((dateTime) => dateTime.date == date)
        .toSet()
        .sorted((a, b) => a.compareTo(b))
        .first;

    selectedDateTimeNotifier.setDateTime(dateTime);
  } else {
    dateTime = selectedDateTime;
  }
  return allSessions.where((session) => session.dateTime == dateTime).toList();
});
