import 'dart:convert';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/category_model.dart';

class CategoryService {

  Future<List<CategoryModel>> getCategories() async {

    final response = await ApiClient.get(
      ApiConstants.categories,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load categories',
      );
    }

    final List<dynamic> data =
    jsonDecode(response.body);

    return data
        .map(
          (json) => CategoryModel.fromJson(json),
    )
        .toList();
  }
}