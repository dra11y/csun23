import 'package:collection/collection.dart';
import 'package:csun23/pages/session_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/date_time_dropdown_button.dart';
import '../widgets/section.dart';
import '../widgets/session_list_item.dart';

class SessionsListPage extends ConsumerStatefulWidget {
  final String title;

  const SessionsListPage({super.key, required this.title});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SessionsListPageState();
}

class _SessionsListPageState extends ConsumerState<SessionsListPage> {
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    final sessionDates = ref.watch(sessionDatesProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final dateTimeSessions = ref.watch(dateTimeSessionsProvider);
    final sessionTimes = ref.watch(sessionTimesProvider(selectedDate));
    final selectedDateNotifier = ref.watch(selectedDateProvider.notifier);
    final selectedDateTime = ref.watch(selectedDateTimeProvider);
    final selectedDateTimeNotifier =
        ref.watch(selectedDateTimeProvider.notifier);
    final favorites = ref.watch(favoritesProvider);

    if (selectedDate == null) {
      final firstDate = sessionDates.maybeWhen(
        data: (sessionDates) =>
            sessionDates.sorted((a, b) => a.compareTo(b)).first,
        orElse: () => null,
      );
      if (firstDate != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          selectedDateNotifier.setDateTime(firstDate);
        });
      }
    }

    final datesDropdown = DateTimeDropdownButton(
      dateTimes: sessionDates,
      buttonColor: colorScheme.onPrimary,
      selectedColor: colorScheme.onSurface,
      notifier: selectedDateNotifier,
      value: selectedDate,
      dateFormat: DateFormat('EEEE, MMMM d'),
    );

    final timesDropdown = DateTimeDropdownButton(
      dateTimes: sessionTimes,
      buttonColor: colorScheme.onPrimary,
      selectedColor: colorScheme.onSurface,
      notifier: selectedDateTimeNotifier,
      value: selectedDateTime,
      dateFormat: DateFormat('h:mm a'),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.amberAccent,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title),
              const SizedBox(width: 16),
              datesDropdown,
              timesDropdown,
            ],
          ),
        ),
        body: dateTimeSessions.when(
          data: (sessions) => _buildSessionList(sessions, favorites),
          error: (error, stackTrace) => Center(
            child: ListView(
              children: [
                const Text('Error loading sessions:'),
                Text(error.toString()),
                ...stackTrace.toString().split('\n').map((line) => Text(line))
              ],
            ),
          ),
          loading: () => const CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  Widget _buildSessionList(List<Session> sessions, Set<int> favorites) {
    final groups = groupBy(sessions, (session) => session.dateTime);

    return CustomScrollView(
      slivers: groups.entries.map((entry) {
        final group = entry.key;
        final sessions = entry.value;
        sessions.sort(
            (a, b) => b.audienceLevel.index.compareTo(a.audienceLevel.index));

        final sessionWidgets = sessions
            .map((session) => SessionListItem(
                  session: session,
                  isFavorite: favorites.contains(session.id),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SessionDetailsPage(session: session);
                  })),
                  onLongPress: () =>
                      ref.read(favoritesProvider.notifier).toggle(session.id),
                ))
            .toList();

        final dateString = DateFormat('h:mm a on EEEE, MMMM d').format(group);
        return Section(
          title: dateString,
          headerColor: colorScheme.primary,
          titleColor: colorScheme.onPrimary,
          items: sessionWidgets,
        );
      }).toList(),
    );
  }
}