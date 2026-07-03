class StatusHistoryModel {
  final int id;

  final String? oldStatus;

  final String newStatus;

  final String? comment;

  final DateTime changedAt;

  final int changedById;

  final String changedByName;

  StatusHistoryModel({
    required this.id,
    this.oldStatus,
    required this.newStatus,
    this.comment,
    required this.changedAt,
    required this.changedById,
    required this.changedByName,
  });

  factory StatusHistoryModel.fromJson(
      Map<String, dynamic> json) {
    return StatusHistoryModel(
      id: json["id"],

      oldStatus: json["oldStatus"] as String?,

      newStatus: json["newStatus"],

      comment: json["comment"],

      changedAt: DateTime.parse(
        json["changedAt"],
      ),

      changedById: json["changedById"],

      changedByName: json["changedByName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "oldStatus": oldStatus,

      "newStatus": newStatus,

      "comment": comment,

      "changedAt":
      changedAt.toIso8601String(),

      "changedById": changedById,

      "changedByName": changedByName,
    };
  }
}