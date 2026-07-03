import 'dart:convert';
import 'dart:io';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';

import '../models/claim_summary_model.dart';
import '../models/claim_details_model.dart';
import '../models/claim_request_model.dart';
import '../models/media_model.dart';

import '../models/claim_response_model.dart';

class ClaimService {
  ClaimService._();

  /// ==========================
  /// Get My Claims
  /// GET /claims/my
  /// ==========================

  static Future<List<ClaimSummaryModel>>
  getMyClaims() async {
    final response = await ApiClient.get(
      ApiConstants.myClaims,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data =
      jsonDecode(response.body);

      return data
          .map(
            (e) =>
            ClaimSummaryModel.fromJson(e),
      )
          .toList();
    }

    throw Exception(
      "Erreur lors du chargement des réclamations",
    );
  }

  /// ==========================
  /// Get Claim Details
  /// GET /claims/{id}
  /// ==========================

  static Future<ClaimDetailsModel>
  getClaimById(int id) async {
    final response = await ApiClient.get(
      "/claims/$id",
    );

    if (response.statusCode == 200) {
      return ClaimDetailsModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Réclamation introuvable",
    );
  }

  /// ==========================
  /// Create Claim
  /// POST /claims
  /// ==========================

  static Future<ClaimResponseModel> createClaim(
      ClaimRequestModel request,
      ) async {
    final response = await ApiClient.post(
      ApiConstants.claims,
      request.toJson(),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        "Création impossible",
      );
    }

    return ClaimResponseModel.fromJson(
      jsonDecode(response.body),
    );
  }

  /// ==========================
  /// Upload Media
  /// POST /claims/{id}/media
  /// ==========================

  static Future<void> uploadMedia(
      int claimId,
      File file,
      ) async {
    final response =
    await ApiClient.uploadFile(
      "/claims/$claimId/media",
      file,
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        "Erreur upload média",
      );
    }
  }

  /// ==========================
  /// Get Claim Media
  /// GET /claims/{id}/media
  /// ==========================

  static Future<List<MediaModel>>
  getMedia(int claimId) async {
    final response = await ApiClient.get(
      "/claims/$claimId/media",
    );

    if (response.statusCode == 200) {
      final List<dynamic> data =
      jsonDecode(response.body);

      return data
          .map(
            (e) => MediaModel.fromJson(e),
      )
          .toList();
    }

    throw Exception(
      "Erreur chargement médias",
    );
  }
}