class ApiConstants {
  ApiConstants._();

  // Spring Boot

  static const String baseUrl =
      // 'http://10.0.2.2:8080/api';
  'http://localhost:8080/api';

  // Auth

  static const String register =
      '/auth/register';

  static const String login =
      '/auth/login';

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
}