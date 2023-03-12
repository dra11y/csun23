import 'package:csun23/extensions/date_time_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'date_time_notifier.dart';
import 'selected_time_provider.dart';

class SelectedDateNotifier extends DateTimeNotifier {
  SelectedDateNotifier(super.ref, super.state);

  @override
  void setDateTime(DateTime? dateTime) {
    ref.read(selectedDateTimeProvider.notifier).resetIfNeeded(dateTime);
    state = dateTime?.date;
  }
}

final mockDateTime = DateTime(2023, 3, 15, 13, 10);

final selectedDateProvider =
    StateNotifierProvider<SelectedDateNotifier, DateTime?>(
        (ref) => SelectedDateNotifier(
            // ref, kDebugMode ? mockDateTime : DateTime.now().date));
            ref,
            DateTime.now().date));
