import 'dart:convert';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/commune_model.dart';

class CommuneService {

  static Future<List<CommuneModel>>
  getCommunes() async {

    final response =
    await ApiClient.get(
      ApiConstants.communes,
    );

    if (response.statusCode == 200) {

      final List data =
      jsonDecode(response.body);

      return data
          .map(
            (e) => CommuneModel.fromJson(e),
      )
          .toList();

    }

    throw Exception(
      "Erreur lors du chargement des communes",
    );
  }
}