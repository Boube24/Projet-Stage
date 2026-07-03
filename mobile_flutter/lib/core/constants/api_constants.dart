class ApiConstants {
  ApiConstants._();

  // Spring Boot

  // للسيرفر فقط (الصور)
  // static const String serverUrl =
  //     'http://192.168.100.94:8080';

  static const String serverUrl =
      'http://172.20.10.6:8080';

  // للـ API
  static const String baseUrl =
      '$serverUrl/api';
  // 'http://localhost:8080/api';

  // Auth

  static const String register =
      '/auth/register';

  static const String login =
      '/auth/login';

  static const String dashboard =
      "/dashboard";

  static const String profile =
      '/auth/me';

  // Claims

  static const String claims =
      '/claims';

  static const String myClaims =
      '/claims/my';

  // Notifications

  static const String notifications =
      '/notifications';

  static const String categories =
      "/categories";

  // Media
  static const String claimMedia =
      '/claims';

  static String claimMediaById(int id) {
    return '/claims/$id/media';
  }

  static const String updateFcmToken =
      "/auth/fcm-token";

  static const String communes =
      "/communes";
}