import 'package:flutter/material.dart';

enum AudienceLevel {
  beginning,
  intermediate,
  advanced;

  @override
  String toString() => name[0].toUpperCase() + name.substring(1);

  Color get color {
    switch (this) {
      case AudienceLevel.beginning:
        return Colors.green;
      case AudienceLevel.intermediate:
        return Colors.orange;
      case AudienceLevel.advanced:
        return Colors.red;
    }
  }

  factory AudienceLevel.fromValue(String value) {
    switch (value.toLowerCase()) {
      case 'beginning':
        return AudienceLevel.beginning;
      case 'intermediate':
        return AudienceLevel.intermediate;
      case 'advanced':
        return AudienceLevel.advanced;
      default:
        throw ArgumentError('Invalid audience level: $value');
    }
  }
}
