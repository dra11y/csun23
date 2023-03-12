import 'package:collection/collection.dart';
import 'package:csun23/pages/session_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/date_time_dropdown_button.dart';
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

  bool showOnlyFavorites = false;
  int? sessionsBeingShown;
  DateTime? lastSelectedDateTime;
  String get title => '${widget.title}${showOnlyFavorites ? ' Favorites' : ''}';

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
      // dateFormat: DateFormat('EEEE, MMMM d'),
      dateFormat: DateFormat('EEEE'),
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
          actions: [
            Semantics(
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    showOnlyFavorites = !showOnlyFavorites;
                  });
                },
                icon: Icon(
                  showOnlyFavorites ? Icons.star : Icons.star_outline,
                  semanticLabel:
                      showOnlyFavorites ? 'Show all' : 'Show only favorites',
                ),
              ),
            ),
          ],
          title: Text(title),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Row(
              children: [
                datesDropdown,
                timesDropdown,
              ],
            ),
          ),
        ),
        body: dateTimeSessions.when(
          data: (sessions) => _buildSessionList(
            sessions: sessions,
            favorites: favorites,
            showOnlyFavorites: showOnlyFavorites,
            selectedDateTime: selectedDateTime,
          ),
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

  void _toggleFavorite(Session session) async {
    await ref.read(favoritesProvider.notifier).toggle(session.id);
    final isFavorite = ref.read(favoritesProvider).contains(session.id);
    final action = isFavorite ? 'Added Favorite' : 'Removed Favorite';
    SemanticsService.announce('$action: ${session.name}', TextDirection.ltr);
  }

  Widget _buildSessionList({
    required List<Session> sessions,
    required Set<int> favorites,
    required bool showOnlyFavorites,
    required DateTime? selectedDateTime,
  }) {
    final filteredSessions = showOnlyFavorites
        ? sessions.where((session) => favorites.contains(session.id)).toList()
        : sessions;
    // final groups = groupBy(filteredSessions, (session) => session.dateTime);
    filteredSessions
        .sort((a, b) => b.audienceLevel.index.compareTo(a.audienceLevel.index));

    if (selectedDateTime != lastSelectedDateTime ||
        filteredSessions.length != sessionsBeingShown) {
      final count = filteredSessions.length;
      sessionsBeingShown = count;
      lastSelectedDateTime = selectedDateTime;
      Future.delayed(const Duration(milliseconds: 100), () {
        SemanticsService.announce(
            'Showing $count${showOnlyFavorites ? ' favorited' : ''} ${Intl.plural(count, one: 'session', other: 'sessions')}',
            TextDirection.ltr,
            assertiveness: Assertiveness.polite);
      });
    }

    return ListView(
      children: [
        ...filteredSessions.map((session) {
          final isFavorite = favorites.contains(session.id);
          return Semantics(
            customSemanticsActions: {
              CustomSemanticsAction(
                      label: isFavorite ? 'Unfavorite' : 'Favorite'):
                  () => _toggleFavorite(session),
            },
            child: SessionListItem(
              session: session,
              isFavorite: isFavorite,
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return SessionDetailsPage(session: session);
              })),
              onLongPress: () => _toggleFavorite(session),
            ),
          );
        }),
      ],
    );

    // return CustomScrollView(
    //   slivers: groups.entries.map((entry) {
    //     final group = entry.key;
    //     final sessions = entry.value;
    //     sessions.sort(
    //         (a, b) => b.audienceLevel.index.compareTo(a.audienceLevel.index));

    //     final sessionWidgets = sessions.map((session) {
    //       final isFavorite = favorites.contains(session.id);
    //       return Semantics(
    //         customSemanticsActions: {
    //           CustomSemanticsAction(
    //                   label: isFavorite ? 'Unfavorite' : 'Favorite'):
    //               () => _toggleFavorite(session),
    //         },
    //         child: SessionListItem(
    //           session: session,
    //           isFavorite: isFavorite,
    //           onTap: () => Navigator.of(context)
    //               .push(MaterialPageRoute(builder: (context) {
    //             return SessionDetailsPage(session: session);
    //           })),
    //           onLongPress: () => Platform.isMacOS || Platform.isWindows
    //               ? _toggleFavorite(session)
    //               : null,
    //         ),
    //       );
    //     }).toList();

    //     final dateString = DateFormat('h:mm a on EEEE, MMMM d').format(group);
    //     return Section(
    //       title: dateString,
    //       headerColor: colorScheme.primary,
    //       titleColor: colorScheme.onPrimary,
    //       items: sessionWidgets,
    //     );
    //   }).toList(),
    // );
  }
}
