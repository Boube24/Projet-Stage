import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<CategoryModel> _categories = [];

  bool _isLoading = false;

  String? _errorMessage;

  // Getters

  List<CategoryModel> get categories => _categories;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  /// Charger toutes les catégories
  Future<void> loadCategories() async {

    if (_categories.isNotEmpty) {
      return;
    }

    _isLoading = true;

    _errorMessage = null;

    notifyListeners();

    try {

      _categories =
      await _categoryService.getCategories();

    } catch (e) {

      _errorMessage = e.toString();

    } finally {

      _isLoading = false;

      notifyListeners();

    }

  }

  /// Vider les données
  void clear() {
    _categories = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}