import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/session.dart';

final allSessionsProvider = FutureProvider.autoDispose((ref) async {
  String jsonString = await rootBundle.loadString('assets/csun23.json');
  List<dynamic> jsonResponse = jsonDecode(jsonString);
  return jsonResponse.map((session) => Session.fromJson(session)).toList();
});
