import 'package:collection/collection.dart';
import 'package:csun23/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/date_time_notifier.dart';

class DateTimeDropdownButton extends StatelessWidget {
  const DateTimeDropdownButton({
    super.key,
    required this.notifier,
    required this.dateTimes,
    required this.value,
    required this.dateFormat,
    required this.buttonColor,
    required this.selectedColor,
  });

  final DateTimeNotifier notifier;
  final AsyncValue<Set<DateTime>> dateTimes;
  final DateTime? value;
  final DateFormat dateFormat;
  final Color buttonColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return dateTimes.when(
      data: (Set<DateTime> dates) {
        if (dates.isEmpty) {
          return const SizedBox.shrink();
        }
        final sortedDates = dates.sorted((a, b) => a.compareTo(b)).toSet();

        /// Add our special `dateTimeShowAll` value to the end of the list.
        sortedDates.add(dateTimeShowAll);

        /// Consider our special `dateTimeShowAll` value to be valid.
        /// Otherwise, constrain to one of the session `DateTime` values.
        final validValue = value == dateTimeShowAll
            ? dateTimeShowAll
            : (value ?? sortedDates.firstOrNull ?? DateTime.now())
                .snappedToSameDay(sortedDates);

        return DropdownButton<DateTime>(
          underline: const SizedBox(),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          iconSize: 24,
          iconEnabledColor: buttonColor,
          value: validValue,
          enableFeedback: true,
          onChanged: (DateTime? date) {
            notifier.setDateTime(date);
          },
          selectedItemBuilder: (BuildContext context) => sortedDates
              .map(
                (DateTime date) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      date.format(dateFormat),
                      style: TextStyle(color: buttonColor),
                      textScaleFactor: 1.3,
                    ),
                  ),
                ),
              )
              .toList(),
          items: sortedDates.map<DropdownMenuItem<DateTime>>((DateTime date) {
            final isSelected = date == validValue;
            return DropdownMenuItem<DateTime>(
              value: date,
              child: Semantics(
                selected: isSelected,
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check : null,
                      color: selectedColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date.format(dateFormat),
                      style: TextStyle(color: selectedColor),
                      textScaleFactor: 1.3,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
      error: (error, stackTrace) => const Text('Error!'),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }
}
