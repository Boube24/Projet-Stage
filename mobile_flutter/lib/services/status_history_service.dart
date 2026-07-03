import 'dart:convert';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/status_history_model.dart';

class StatusHistoryService {
  StatusHistoryService._();

  /// GET /claims/{claimId}/history
  static Future<List<StatusHistoryModel>> getHistoryByClaim(
      int claimId) async {
    final response = await ApiClient.get(
      "${ApiConstants.claims}/$claimId/history",
    );

    print("STATUS = ${response.statusCode}");
    print("BODY = ${response.body}");


    if (response.statusCode == 200) {
      final List<dynamic> data =
      jsonDecode(response.body);

      return data
          .map(
            (e) => StatusHistoryModel.fromJson(e),
      )
          .toList();
    }

    throw Exception(
      "Erreur lors du chargement de l'historique",
    );
  }
}