enum AudienceLevel {
  beginning,
  intermediate,
  advanced;

  @override
  String toString() => name[0].toUpperCase() + name.substring(1);

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
