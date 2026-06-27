import 'dart:convert';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/storage/local_storage.dart';

import '../models/login_response_model.dart';
import '../models/user_model.dart';

class AuthService {

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {

    final response =
    await ApiClient.post(
      ApiConstants.register,
      {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {

      throw Exception(
        response.body,
      );
    }
  }

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {

    final response =
    await ApiClient.post(
      ApiConstants.login,
      {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Login failed',
      );
    }

    final data =
    jsonDecode(
      response.body,
    );

    final loginResponse =
    LoginResponseModel.fromJson(
      data,
    );

    await LocalStorage.saveToken(
      loginResponse.token,
    );

    return loginResponse;
  }

  Future<UserModel> getProfile()
  async {

    final response =
    await ApiClient.get(
      ApiConstants.profile,
    );

    if (response.statusCode != 200) {

      throw Exception(
        'Failed to load profile',
      );
    }

    return UserModel.fromJson(
      jsonDecode(
        response.body,
      ),
    );
  }

  Future<void> logout()
  async {

    await LocalStorage.clearToken();
  }
}