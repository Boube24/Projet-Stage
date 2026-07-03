import 'dart:io';

import 'package:flutter/material.dart';

import '../models/claim_details_model.dart';
import '../models/claim_request_model.dart';
import '../models/claim_summary_model.dart';
import '../services/claim_service.dart';
import '../models/media_model.dart';
import '../models/claim_response_model.dart';

class ClaimProvider extends ChangeNotifier {
  ClaimProvider();

  /// ==========================
  /// Data
  /// ==========================

  List<ClaimSummaryModel> _claims = [];

  ClaimDetailsModel? _selectedClaim;

  int? _selectedClaimId;

  List<MediaModel> _media = [];

  int? get selectedClaimId => _selectedClaimId;

  /// ==========================
  /// States
  /// ==========================

  bool _isLoading = false;

  bool _isUploading = false;

  String? _error;

  /// ==========================
  /// Getters
  /// ==========================

  List<ClaimSummaryModel> get claims => _claims;

  ClaimDetailsModel? get selectedClaim =>
      _selectedClaim;

  List<MediaModel> get media => _media;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  String? get error => _error;


  Future<void> loadMedia(int claimId) async {
    try {
      _error = null;

      _media = await ClaimService.getMedia(claimId);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }


  /// ==========================
  /// Load My Claims
  /// ==========================

  Future<void> loadMyClaims() async {
    try {
      _isLoading = true;

      _error = null;

      notifyListeners();

      _claims =
      await ClaimService.getMyClaims();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  /// ==========================
  /// Load Claim Details
  /// ==========================

  Future<void> loadClaimById(
      int id) async {
    try {
      _isLoading = true;

      _error = null;

      notifyListeners();

      _selectedClaim =
      await ClaimService.getClaimById(id);

      _selectedClaimId = id;

      _media = await ClaimService.getMedia(id);

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  /// ==========================
  /// Create Claim
  /// ==========================

  Future<ClaimResponseModel?> createClaim(
      ClaimRequestModel request,
      ) async {

    try {

      _isLoading = true;

      _error = null;

      notifyListeners();

      final claim =
      await ClaimService.createClaim(
        request,
      );

      await loadMyClaims();

      return claim;

    } catch (e) {

      _error = e.toString();

      return null;

    } finally {

      _isLoading = false;

      notifyListeners();

    }

  }

  /// ==========================
  /// Upload Media
  /// ==========================

  // Future<void> uploadMedia(
  //     int claimId,
  //     File file,
  //     ) async {
  //   try {
  //     _isUploading = true;
  //
  //     _error = null;
  //
  //     notifyListeners();
  //
  //     await ClaimService.uploadMedia(
  //       claimId,
  //       file,
  //     );
  //
  //     await loadClaimById(claimId);
  //   } catch (e) {
  //     _error = e.toString();
  //   } finally {
  //     _isUploading = false;
  //
  //     notifyListeners();
  //   }
  // }

  /// ==========================
  /// Upload Multiple Media (تم التحديث لمنع انكسار الـ Loop)
  /// ==========================
  Future<void> uploadMultipleMedia(
      int claimId,
      List<File> files,
      ) async {
    if (files.isEmpty) return;

    try {
      _isUploading = true;
      _error = null;
      notifyListeners();

      // رفع الملفات واحداً تلو الآخر بشكل متسلسل ومستقر
      for (final file in files) {
        await ClaimService.uploadMedia(claimId, file);
      }

      // بعد انتهاء الرفع بالكامل بنجاح، نقوم بتحديث البيانات لمرة واحدة فقط
      await loadClaimById(claimId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
  /// ==========================
  /// Refresh
  /// ==========================

  Future<void> refresh() async {
    await loadMyClaims();
  }

  /// ==========================
  /// Clear Selected Claim
  /// ==========================

  void clearSelectedClaim() {
    _selectedClaim = null;
    _selectedClaimId = null;
    _media = [];
    notifyListeners();
  }
}