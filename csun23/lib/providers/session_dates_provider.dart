import 'package:csun23/extensions/date_time_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'all_sessions_provider.dart';

final sessionDatesProvider =
    FutureProvider.autoDispose<Set<DateTime>>((ref) async {
  final allSessions = await ref.watch(allSessionsProvider.future);
  return allSessions.map((session) => session.dateTime.date).toSet();
});
