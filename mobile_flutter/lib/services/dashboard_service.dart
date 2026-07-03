import 'dart:convert';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/dashboard_model.dart';

class DashboardService {

  Future<DashboardModel> getDashboard() async {

    final response =
    await ApiClient.get(
      ApiConstants.dashboard,
    );

    if (response.statusCode != 200) {

      throw Exception(
        "Erreur Dashboard",
      );

    }

    return DashboardModel.fromJson(
      jsonDecode(response.body),
    );

  }

}