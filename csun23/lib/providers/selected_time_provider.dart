import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/date_time_extension.dart';
import 'date_time_notifier.dart';

class SelectedTimeNotifier extends DateTimeNotifier {
  SelectedTimeNotifier(super.ref, super.state);

  @override
  void setDateTime(DateTime? dateTime) {
    state = dateTime;
  }

  void resetIfNeeded(DateTime? dateTime) {
    if (state != dateTimeShowAll) {
      final now = state ?? DateTime.now();
      state = dateTime == null
          ? null
          : DateTime(dateTime.year, dateTime.month, dateTime.day, now.hour,
              now.minute);
    }
  }
}

final selectedDateTimeProvider =
    StateNotifierProvider<SelectedTimeNotifier, DateTime?>((ref) =>
        // SelectedTimeNotifier(ref, kDebugMode ? mockDateTime : DateTime.now()));
        SelectedTimeNotifier(ref, DateTime.now()));
