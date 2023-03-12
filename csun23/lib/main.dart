import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/sessions_list_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSUN 2023',
      // theme: ThemeData(
      //   iconTheme: IconThemeData(
      //     size: Theme.of(context).iconTheme.size ?? 24,
      //   ),
      //   textTheme: Theme.of(context).textTheme.apply(
      //         fontSizeFactor: 1.0,
      //         // fontSizeDelta: 5,
      //       ),
      // ),
      home: SessionsListPage(title: 'CSUN ’23'),
    );
  }
}
