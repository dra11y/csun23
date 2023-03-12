import 'package:csun23/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/models.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(session.name),
      ),
      body: ListView(
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
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            DateFormat('h:mm a on EEEE, MMMM d')
                                .format(session.dateTime),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Semantics(
                        sortKey: const OrdinalSortKey(1.5),
                        container: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            session.location,
                            textAlign: TextAlign.center,
                          ),
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
                  onTap: () => favoritesNotifier.toggle(session.id),
                  child: Padding(
                    padding: const EdgeInsets.all(10).copyWith(right: 20),
                    child: MaterialButton(
                      onPressed: () => favoritesNotifier.toggle(session.id),
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
                              color: isFavorite
                                  ? Colors.amber
                                  : Colors.transparent,
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
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Table(
              border: TableBorder.all(
                color: Colors.grey,
              ),
              columnWidths: const {
                0: IntrinsicColumnWidth(),
              },
              children: [
                _tableRow(
                    label: 'Audience Level',
                    text: session.audienceLevel.toString()),
                _tableRow(label: 'Abstract', text: session.abstractText),
                _tableRow(label: 'Session Type', text: session.sessionType),
                _tableRow(
                    label: 'Presenters', text: session.presenters.join('\n')),
                _tableRow(label: 'Primary Topic', text: session.primaryTopic),
                _tableRow(
                    label: 'Secondary Topics',
                    text: session.secondaryTopics.join(', ')),
                _tableRow(
                    label: 'View on Web',
                    content: GestureDetector(
                      onTap: openLink,
                      child: Semantics(
                        container: true,
                        link: true,
                        onTap: openLink,
                        child: Text(
                          session.url,
                          style: TextStyle(
                            color: colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Semantics(
              header: true,
              container: true,
              child: const Text(
                'Description',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              ...session.description.split('\n').map(
                    (p) => Semantics(
                      container: true,
                      child: Text(p),
                    ),
                  ),
            ]),
          )
        ],
      ),
    );
  }

  TableRow _tableRow({required String label, String? text, Widget? content}) {
    assert(
        (text != null && content == null) || (content != null && text == null));
    return TableRow(
      children: [
        TableCell(
          child: Semantics(
            container: true,
            header: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        TableCell(
          child: Semantics(
            container: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: text != null ? Text(text) : content,
            ),
          ),
        ),
      ],
    );
  }
}
