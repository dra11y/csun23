import 'package:flutter/material.dart';

import '../models/models.dart';

class SessionListItem extends StatelessWidget {
  final Session session;

  const SessionListItem({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(session.name),
      subtitle: Text(
        '${session.audienceLevel} - ${session.location}',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigate to the session details page
      },
    );
  }
}
