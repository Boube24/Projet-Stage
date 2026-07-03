import 'package:flutter/material.dart';

import 'dart:convert';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/storage/local_storage.dart';

import '../models/login_response_model.dart';
import '../models/user_model.dart';
import '../core/network/api_exception.dart';


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

      throw ApiException(
        jsonDecode(response.body)["message"] ??
            "Erreur lors de l'inscription",
        statusCode: response.statusCode,
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

      String message = "Connexion impossible";

      try {

        final body =
        jsonDecode(response.body);

        message =
            body["message"] ?? message;

      } catch (_) {}

      throw ApiException(
        message,
        statusCode: response.statusCode,
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

      throw ApiException(
        "Impossible de charger le profil",
        statusCode: response.statusCode,
      );
    }

    return UserModel.fromJson(
      jsonDecode(
        response.body,
      ),
    );
  }

  // Future<void> logout()
  // async {
  //
  //   await LocalStorage.clearToken();
  // }

  Future<void> logout() async {
    await LocalStorage.clearToken();
    // احذف كود الـ Navigator من هنا تماماً لتبقى الدالة نظيفة
  }

  Future<void> updateFcmToken(
      String token,
      ) async {

    final response =
    await ApiClient.put(
      ApiConstants.updateFcmToken,
      {
        "token": token,
      },
    );

    print("=========== FCM ===========");
    print("Status : ${response.statusCode}");
    print("Body   : ${response.body}");
    print("===========================");

    if (response.statusCode != 200) {
      throw Exception(
        "Impossible de mettre à jour le token FCM",
      );
    }
  }
}