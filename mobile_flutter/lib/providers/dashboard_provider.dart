import 'package:flutter/material.dart';

import '../models/dashboard_model.dart';
import '../services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {

  final DashboardService _service =
  DashboardService();

  DashboardModel? dashboard;

  bool isLoading = false;

  String? error;

  Future<void> loadDashboard() async {

    isLoading = true;

    error = null;

    notifyListeners();

    try {

      dashboard =
      await _service.getDashboard();

    } catch (e) {

      error = e.toString();

    }

    isLoading = false;

    notifyListeners();

  }

}