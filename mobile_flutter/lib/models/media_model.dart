class MediaModel {
  final int id;
  final String url;
  final String type;
  final DateTime uploadedAt;

  MediaModel({
    required this.id,
    required this.url,
    required this.type,
    required this.uploadedAt,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'],
      url: json['url'],
      type: json['type'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'type': type,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}