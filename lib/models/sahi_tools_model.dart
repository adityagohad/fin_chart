class SahiToolsModel {
  final String title;
  bool isVisible;
  bool isEnabled;

  SahiToolsModel({
    required this.title,
    this.isVisible = false,
    this.isEnabled = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'isVisible': isVisible,
        'isEnabled': isEnabled,
      };

  factory SahiToolsModel.fromJson(Map<String, dynamic> json) {
    return SahiToolsModel(
      title: json['title'] ?? '',
      isVisible: json['isVisible'] ?? false,
      isEnabled: json['isEnabled'] ?? false,
    );
  }
}
