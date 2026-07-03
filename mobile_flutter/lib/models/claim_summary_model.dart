class ClaimSummaryModel {
  final int id;
  final String reference;
  final String title;
  final String currentStatus;
  final DateTime createdAt;

  final String? categoryName;
  final String? communeName;

  ClaimSummaryModel({
    required this.id,
    required this.reference,
    required this.title,
    required this.currentStatus,
    required this.createdAt,
    this.categoryName,
    this.communeName,
  });

  factory ClaimSummaryModel.fromJson(Map<String, dynamic> json) {
    return ClaimSummaryModel(
      id: json['id'],
      reference: json['reference'],
      title: json['title'],
      currentStatus: json['currentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      categoryName: json['categoryName'],
      communeName: json['communeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'title': title,
      'currentStatus': currentStatus,
      'createdAt': createdAt.toIso8601String(),
      'categoryName': categoryName,
      'communeName': communeName,
    };
  }
}