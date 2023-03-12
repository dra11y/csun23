import 'dart:io';

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
    final textScale =
        Platform.isMacOS ? 1.7 : MediaQuery.of(context).textScaleFactor;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSUN 2023',
      theme: ThemeData(
        iconTheme: IconThemeData(
          size: textScale * (Theme.of(context).iconTheme.size ?? 24),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: textScale,
              // fontSizeDelta: 5,
            ),
      ),
      home: SessionsListPage(title: 'CSUN ’23'),
    );
  }
}
