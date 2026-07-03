import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/notification_model.dart';

class NotificationService {
  NotificationService._();

  /// GET all notifications of user
  static Future<List<NotificationModel>> getUserNotifications(int userId) async {
    final response = await ApiClient.get(
      "${ApiConstants.notifications}/user/$userId",
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    }

    throw Exception("Erreur chargement notifications");
  }

  /// GET unread notifications
  static Future<List<NotificationModel>> getUnread(int userId) async {
    final response = await ApiClient.get(
      "${ApiConstants.notifications}/user/$userId/unread",
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    }

    throw Exception("Erreur notifications non lues");
  }

  /// Mark as read
  static Future<void> markAsRead(int id) async {
    final response = await ApiClient.put(
      "${ApiConstants.notifications}/$id/read",
      {},
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur mark as read");
    }
  }
}