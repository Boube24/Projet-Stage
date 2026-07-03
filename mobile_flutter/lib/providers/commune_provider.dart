import 'package:flutter/material.dart';

import '../models/commune_model.dart';
import '../services/commune_service.dart';

class CommuneProvider extends ChangeNotifier {

  List<CommuneModel> _communes = [];

  bool _isLoading = false;

  String? _error;

  List<CommuneModel> get communes =>
      _communes;

  bool get isLoading =>
      _isLoading;

  String? get error =>
      _error;

  Future<void> loadCommunes() async {

    if (_communes.isNotEmpty) {
      return;
    }

    try {

      _isLoading = true;

      _error = null;

      notifyListeners();

      _communes =
      await CommuneService.getCommunes();

    } catch (e) {

      _error = e.toString();

    } finally {

      _isLoading = false;

      notifyListeners();

    }

  }

  CommuneModel? getById(int id) {

    try {

      return _communes.firstWhere(
            (e) => e.id == id,
      );

    } catch (_) {

      return null;

    }
  }
}