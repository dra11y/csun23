import 'package:csun23/extensions/date_time_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'date_time_notifier.dart';
import 'selected_time_provider.dart';

class SelectedDateNotifier extends DateTimeNotifier {
  SelectedDateNotifier(super.ref);

  @override
  void setDateTime(DateTime? dateTime) {
    ref.read(selectedDateTimeProvider.notifier).setDateTime(null);
    state = dateTime?.date;
  }
}

final selectedDateProvider =
    StateNotifierProvider<SelectedDateNotifier, DateTime?>(
        (ref) => SelectedDateNotifier(ref));
