class ClaimResponseModel {
  final int id;
  final String reference;
  final String title;
  final String description;
  final String status;

  final int categoryId;
  final String categoryName;

  final int communeId;
  final String communeName;

  final int? regionId;
  final String? regionName;

  final double latitude;
  final double longitude;

  final DateTime createdAt;
  final DateTime updatedAt;

  ClaimResponseModel({
    required this.id,
    required this.reference,
    required this.title,
    required this.description,
    required this.status,
    required this.categoryId,
    required this.categoryName,
    required this.communeId,
    required this.communeName,
    this.regionId,
    this.regionName,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClaimResponseModel.fromJson(
      Map<String, dynamic> json) {
    return ClaimResponseModel(
      id: json["id"],
      reference: json["reference"],
      title: json["title"],
      description: json["description"],
      status: json["status"].toString(),

      categoryId: json["categoryId"],
      categoryName: json["categoryName"],

      communeId: json["communeId"],
      communeName: json["communeName"],

      regionId: json["regionId"],
      regionName: json["regionName"],

      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),

      createdAt: DateTime.parse(
        json["createdAt"],
      ),

      updatedAt: DateTime.parse(
        json["updatedAt"],
      ),
    );
  }
}