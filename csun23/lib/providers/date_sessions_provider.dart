import 'package:collection/collection.dart';
import 'package:csun23/extensions/date_time_extension.dart';
import 'package:csun23/providers/all_sessions_provider.dart';
import 'package:csun23/providers/session_dates_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/session.dart';
import 'selected_date_provider.dart';

final dateSessionsProvider =
    FutureProvider.autoDispose<List<Session>>((ref) async {
  final allSessions = await ref.watch(allSessionsProvider.future);
  final allDates = await ref.watch(sessionDatesProvider.future);
  final earliestDate = allDates.min;
  final latestDate = allDates.max;
  final selectedDateNotifier = ref.watch(selectedDateProvider.notifier);
  final selectedDate = ref.watch(selectedDateProvider)?.date;
  if (selectedDate == null) {
    selectedDateNotifier.setDateTime(earliestDate);
  }
  final date = [
    earliestDate,
    [latestDate, selectedDate ?? earliestDate].min
  ].max;
  return allSessions.where((session) => session.dateTime.date == date).toList();
});
