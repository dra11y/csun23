import 'package:csun23/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';

class SessionListItem extends StatelessWidget {
  final Session session;
  final bool isFavorite;
  final bool showDate;
  final bool showTime;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  const SessionListItem({
    super.key,
    required this.session,
    required this.isFavorite,
    required this.showDate,
    required this.showTime,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    String dateFormatString = '';
    if (showTime || showDate) {
      dateFormatString += 'h:mm a';
    }
    if (showDate) {
      dateFormatString += ' on EEEE, MMMM d';
    }
    final dateFormat = DateFormat(dateFormatString);

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
      subtitle: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: session.audienceLevel.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: session.audienceLevel.color,
              ),
            ),
            if (showTime || showDate)
              TextSpan(
                text: ', ${dateFormat.format(session.dateTime)}',
              ),
            TextSpan(
              text: ', ${session.location}',
            ),
          ],
        ),
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
