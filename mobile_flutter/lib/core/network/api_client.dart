import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import '../constants/api_constants.dart';
import '../storage/local_storage.dart';
import 'api_exception.dart';

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

  // static Future<http.StreamedResponse> uploadFile(
  //     String endpoint,
  //     File file,
  //     ) async {
  //
  //   final token = await LocalStorage.getToken();
  //
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse(ApiConstants.baseUrl + endpoint),
  //   );
  //
  //   if (token != null) {
  //     request.headers['Authorization'] = 'Bearer $token';
  //   }
  //
  //   request.files.add(
  //     await http.MultipartFile.fromPath(
  //       'file',
  //       file.path,
  //     ),
  //   );
  //
  //   return await request.send();
  // }

  static Future<http.Response> uploadFile(
      String endpoint,
      File file,
      ) async {
    final token = await LocalStorage.getToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.baseUrl + endpoint),
    );

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // 🛠️ التعديل هنا: استخراج الامتداد لتحديد الـ ContentType لكي يفهمه السيرفر
    String ext = file.path.split('.').last.toLowerCase();
    String mimeType = (ext == 'png') ? 'png' : 'jpeg';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('image', mimeType), // 💡 إرسال نوع الملف بدقة للسيرفر
      ),
    );

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  static void handleResponse(http.Response response) {

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return;
    }

    throw ApiException(
      response.body,
      statusCode: response.statusCode,
    );
  }
}