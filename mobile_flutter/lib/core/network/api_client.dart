import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../storage/local_storage.dart';

class ApiClient {
  ApiClient._();

  static Future<Map<String, String>>
  _headers() async {
    final token =
    await LocalStorage.getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null)
        'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(
      String endpoint) async {
    return http.get(
      Uri.parse(
        ApiConstants.baseUrl + endpoint,
      ),
      headers: await _headers(),
    );
  }

  static Future<http.Response> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    return http.post(
      Uri.parse(
        ApiConstants.baseUrl + endpoint,
      ),
      headers: await _headers(),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    return http.put(
      Uri.parse(
        ApiConstants.baseUrl + endpoint,
      ),
      headers: await _headers(),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(
      String endpoint) async {
    return http.delete(
      Uri.parse(
        ApiConstants.baseUrl + endpoint,
      ),
      headers: await _headers(),
    );
  }
}