class Presenter {
  final String name;
  final String? organization;

  Presenter({
    required this.name,
    required this.organization,
  });

  factory Presenter.fromJson(Map<String, dynamic> json) {
    return Presenter(
      name: json['name'],
      organization: json['organization'],
    );
  }
}
