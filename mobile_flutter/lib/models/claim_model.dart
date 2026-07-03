import 'media_model.dart';

class ClaimModel {
  final int id;
  final String reference;
  final String title;
  final String description;
  final double? latitude;
  final double? longitude;
  final String currentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? categoryName;
  final String? communeName;

  final List<MediaModel>? media;

  ClaimModel({
    required this.id,
    required this.reference,
    required this.title,
    required this.description,
    this.latitude,
    this.longitude,
    required this.currentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.categoryName,
    this.communeName,
    this.media,
  });

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
      id: json['id'],
      reference: json['reference'],
      title: json['title'],
      description: json['description'] ?? "",
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      currentStatus: json['currentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.parse(json['createdAt']),

      categoryName: json['categoryName'],
      communeName: json['communeName'],

      media: json['media'] != null
          ? (json['media'] as List)
          .map((e) => MediaModel.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'currentStatus': currentStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'categoryName': categoryName,
      'communeName': communeName,
      'media': media?.map((e) => e.toJson()).toList(),
    };
  }
}