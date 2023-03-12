import 'package:csun23/extensions/date_time_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'all_sessions_provider.dart';

final sessionTimesProvider = FutureProvider.autoDispose
    .family<Set<DateTime>, DateTime?>((ref, date) async {
  final allSessions = await ref.watch(allSessionsProvider.future);
  print('sessionTimesProvider date = $date');
  return allSessions
      .map((session) => session.dateTime)
      .where((dateTime) => dateTime.date == date?.date)
      .toSet();
});
