import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'date_time_notifier.dart';

class SelectedTimeNotifier extends DateTimeNotifier {
  SelectedTimeNotifier(super.ref);

  @override
  void setDateTime(DateTime? dateTime) {
    state = dateTime;
  }
}

final selectedDateTimeProvider =
    StateNotifierProvider<SelectedTimeNotifier, DateTime?>(
        (ref) => SelectedTimeNotifier(ref));
