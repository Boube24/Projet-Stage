class NotificationModel {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime sentAt;
  final int userId;
  final int? claimId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.sentAt,
    required this.userId,
    this.claimId,
  });

  factory NotificationModel.fromJson(
      Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      isRead: json['isRead'],
      sentAt: DateTime.parse(json['sentAt']),
      userId: json['userId'],
      claimId: json['claimId'],
    );
  }
}