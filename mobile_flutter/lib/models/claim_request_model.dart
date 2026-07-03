class ClaimRequestModel {
  final String title;

  final String description;

  final double latitude;

  final double longitude;

  final int categoryId;

  final int communeId;

  ClaimRequestModel({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.categoryId,
    required this.communeId,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "categoryId": categoryId,
      "communeId": communeId,
    };
  }
}