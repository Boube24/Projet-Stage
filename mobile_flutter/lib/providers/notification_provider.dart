import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {

  List<NotificationModel> _notifications = [];
  List<NotificationModel> _unread = [];

  bool _isLoading = false;
  String? _error;

  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unread => _unread;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all notifications
  Future<void> loadNotifications(int userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _notifications =
      await NotificationService.getUserNotifications(userId);

      _unread =
      await NotificationService.getUnread(userId);

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh
  Future<void> refresh(int userId) async {
    await loadNotifications(userId);
  }

  /// Mark as read
  Future<void> markAsRead(int id, int userId) async {
    try {
      await NotificationService.markAsRead(id);

      await loadNotifications(userId);

    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}