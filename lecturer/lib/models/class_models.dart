class LectureModel {
  final String title;
  final String description;
  final String audioUrl;

  LectureModel({
    required this.title,
    required this.description,
    required this.audioUrl,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      title: json['title'] as String,
      description: json['description'] as String,
      audioUrl: json['audioUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'audioUrl': audioUrl};
  }
}
