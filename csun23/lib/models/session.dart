import 'audience_level.dart';
import 'presenter.dart';

class Session {
  final int id;
  final DateTime dateTime;
  final String name;
  final String abstractText;
  final String sessionType;
  final AudienceLevel audienceLevel;
  final List<String> audiences;
  final String description;
  final String primaryTopic;
  final List<String> secondaryTopics;
  final List<Presenter> presenters;
  final String location;
  final String url;

  Session({
    required this.id,
    required this.dateTime,
    required this.name,
    required this.abstractText,
    required this.sessionType,
    required this.audienceLevel,
    required this.audiences,
    required this.description,
    required this.primaryTopic,
    required this.secondaryTopics,
    required this.presenters,
    required this.location,
    required this.url,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    var presentersList = json['presenters'] as List;
    List<Presenter> presenters =
        presentersList.map((i) => Presenter.fromJson(i)).toList();

    return Session(
      id: json['id'],
      dateTime: DateTime.parse(json['date_time']),
      name: json['name'],
      abstractText: json['abstract'],
      sessionType: json['session_type'],
      audienceLevel: AudienceLevel.fromValue(json['audience_level']),
      audiences: List<String>.from(json['audiences']),
      description: json['description'],
      primaryTopic: json['primary_topic'],
      secondaryTopics: List<String>.from(json['secondary_topics']),
      presenters: presenters,
      location: json['location'],
      url: json['url'],
    );
  }
}
