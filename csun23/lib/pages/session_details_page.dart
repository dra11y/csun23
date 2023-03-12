import 'package:csun23/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:url_launcher/url_launcher_string.dart';

import '../models/models.dart';
import '../widgets/heading.dart';

class SessionDetailsPage extends ConsumerStatefulWidget {
  const SessionDetailsPage({super.key, required this.session});

  final Session session;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SessionDetailsPageState();
}

class _SessionDetailsPageState extends ConsumerState<SessionDetailsPage> {
  late final Session session = widget.session;

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(favoritesProvider).contains(session.id);
    final favoritesNotifier = ref.watch(favoritesProvider.notifier);
    Future<void> openLink() async => await launchUrlString(session.url);
    final colorScheme = Theme.of(context).colorScheme;
    final textScale = MediaQuery.of(context).textScaleFactor;

    void toggleFavorite() {
      favoritesNotifier.toggle(session.id);
      Future.delayed(const Duration(milliseconds: 100), () {
        final isFavorite = ref.read(favoritesProvider).contains(session.id);
        SemanticsService.announce(
            isFavorite ? 'Added favorite' : 'Removed favorite',
            TextDirection.ltr);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(session.name),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        cacheExtent: 100,
        addSemanticIndexes: true,
        children: [
          Semantics(
            sortKey: const OrdinalSortKey(1),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Semantics(
                        sortKey: const OrdinalSortKey(1),
                        container: true,
                        child: Text(
                          DateFormat('h:mm a on EEEE, MMMM d')
                              .format(session.dateTime),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Semantics(
                        sortKey: const OrdinalSortKey(1.5),
                        container: true,
                        child: Text(
                          session.location,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Semantics(
                  sortKey: const OrdinalSortKey(1.7),
                  container: true,
                  button: true,
                  label: isFavorite ? 'Remove Favorite' : 'Add Favorite',
                  excludeSemantics: true,
                  onTap: toggleFavorite,
                  child: MaterialButton(
                    onPressed: toggleFavorite,
                    child: Column(
                      children: [
                        DecoratedIcon(
                          decoration: isFavorite
                              ? IconDecoration(
                                  border: IconBorder(width: textScale * 3))
                              : null,
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.clear,
                            semanticLabel: isFavorite ? 'Favorite' : null,
                            color:
                                isFavorite ? Colors.amber : Colors.transparent,
                          ),
                        ),
                        Text(
                          isFavorite ? 'Remove\nFavorite' : 'Add\nFavorite',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Heading(text: 'Audience Level'),
          Text(session.audienceLevel.toString()),
          const Heading(text: 'Abstract'),
          Text(session.abstractText),
          const Heading(text: 'Session Type'),
          Text(session.sessionType),
          const Heading(text: 'Presenters'),
          Text(session.presenters.join('\n')),
          const Heading(text: 'Primary Topic'),
          Text(session.primaryTopic),
          const Heading(text: 'Secondary Topics'),
          Text(session.secondaryTopics.join(', ')),
          const Heading(text: 'View on Web'),
          Semantics(
            link: true,
            onTap: openLink,
            label: 'View on web',
            excludeSemantics: true,
            child: GestureDetector(
              onTap: openLink,
              child: Text(
                'View on web',
                style: TextStyle(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const Heading(text: 'Description'),
          Column(children: [
            ...session.description
                .split('\n')
                .map(
                  (p) => p.trim().isEmpty
                      ? null
                      : Semantics(
                          container: true,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(p),
                          ),
                        ),
                )
                .whereType<Widget>(),
          ]),
        ]
            .map((item) => Padding(
                  padding: const EdgeInsets.all(10).copyWith(bottom: 0),
                  child: item,
                ))
            .toList(),
      ),
    );
  }
}
