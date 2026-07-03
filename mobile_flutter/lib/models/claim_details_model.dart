class ClaimDetailsModel {
  final int id;

  final String reference;

  final String title;

  final String description;

  final String currentStatus;

  final double? latitude;

  final double? longitude;

  final DateTime createdAt;

  final DateTime updatedAt;

  final String categoryName;

  final String communeName;

  ClaimDetailsModel({
    required this.id,
    required this.reference,
    required this.title,
    required this.description,
    required this.currentStatus,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryName,
    required this.communeName,
  });

  factory ClaimDetailsModel.fromJson(
      Map<String, dynamic> json) {
    return ClaimDetailsModel(
      id: json["id"],

      reference: json["reference"],

      title: json["title"],

      description: json["description"],

      currentStatus: json["currentStatus"],

      latitude: json["latitude"]?.toDouble(),

      longitude: json["longitude"]?.toDouble(),

      createdAt: DateTime.parse(
        json["createdAt"],
      ),

      updatedAt: DateTime.parse(
        json["updatedAt"],
      ),

      categoryName: json["categoryName"],

      communeName: json["communeName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "reference": reference,

      "title": title,

      "description": description,

      "currentStatus": currentStatus,

      "latitude": latitude,

      "longitude": longitude,

      "createdAt":
      createdAt.toIso8601String(),

      "updatedAt":
      updatedAt.toIso8601String(),

      "categoryName": categoryName,

      "communeName": communeName,
    };
  }
}