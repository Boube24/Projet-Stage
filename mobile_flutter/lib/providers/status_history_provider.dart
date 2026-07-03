import 'package:flutter/material.dart';

import '../models/status_history_model.dart';
import '../services/status_history_service.dart';

class StatusHistoryProvider extends ChangeNotifier {

  /// ==========================
  /// Data
  /// ==========================

  List<StatusHistoryModel> _history = [];

  /// ==========================
  /// States
  /// ==========================

  bool _isLoading = false;

  String? _error;

  /// ==========================
  /// Getters
  /// ==========================

  List<StatusHistoryModel> get history =>
      _history;

  bool get isLoading => _isLoading;

  String? get error => _error;

  /// ==========================
  /// Load History
  /// ==========================

  Future<void> loadHistory(
      int claimId) async {
    try {

      _isLoading = true;

      _error = null;

      notifyListeners();

      _history =
      await StatusHistoryService
          .getHistoryByClaim(claimId);

      print("History count = ${_history.length}");
      print(_history);

    } catch (e, s) {
      print("ERROR = $e");
      print(s);

      _error = e.toString();
    } finally {

      _isLoading = false;

      notifyListeners();

    }
  }

  /// ==========================
  /// Refresh
  /// ==========================

  Future<void> refresh(
      int claimId) async {

    await loadHistory(claimId);

  }

  /// ==========================
  /// Clear History
  /// ==========================

  void clearHistory() {

    _history = [];

    notifyListeners();

  }

}