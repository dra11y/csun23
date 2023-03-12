import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';

import '../models/models.dart';

class SessionListItem extends StatelessWidget {
  final Session session;
  final bool isFavorite;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  const SessionListItem({
    super.key,
    required this.session,
    required this.isFavorite,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;

    return ListTile(
      minLeadingWidth: 0,
      leading: DecoratedIcon(
        decoration: isFavorite
            ? IconDecoration(border: IconBorder(width: textScale * 3))
            : null,
        icon: Icon(
          isFavorite ? Icons.star : Icons.clear,
          semanticLabel: isFavorite ? 'Favorite' : null,
          color: isFavorite ? Colors.amber : Colors.transparent,
        ),
      ),
      title: Text(session.name),
      subtitle: Text(
        '${session.audienceLevel} - ${session.location}',
      ),
      trailing: const SizedBox(
        width: 24,
        child: Icon(
          Icons.chevron_right,
          size: 48,
        ),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
