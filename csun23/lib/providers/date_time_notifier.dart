import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class DateTimeNotifier extends StateNotifier<DateTime?> {
  DateTimeNotifier(this.ref) : super(null);

  final Ref ref;

  void setDateTime(DateTime? dateTime);
}
