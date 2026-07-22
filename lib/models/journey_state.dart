class JourneyState {
  String id;
  String? videoUrl;
  bool hideVideoBtn;
  bool completed;

  JourneyState({
    required this.id,
    this.videoUrl,
    this.hideVideoBtn = false,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'videoUrl': videoUrl,
        'hideVideoBtn': hideVideoBtn,
        'completed': completed,
      };

  factory JourneyState.fromJson(Map<String, dynamic> json) => JourneyState(
        id: json['id'],
        videoUrl: json['videoUrl'],
        hideVideoBtn: json['hideVideoBtn'] ?? false,
        completed: json['completed'] ?? false,
      );
}
