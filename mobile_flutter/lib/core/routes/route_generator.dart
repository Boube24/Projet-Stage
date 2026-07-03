import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_page.dart';
import '../../screens/home/home_page.dart';
import '../../screens/splash/splash_screen.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(
      RouteSettings settings) {

    switch (settings.name) {

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) =>
          const LoginPage(),
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) =>
          const RegisterPage(),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) =>
          const HomePage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
          const SplashPage(),
        );
    }
  }
}
class AppRoutes {
  static const String splash = '/';

  static const String login = '/login';

  static const String register = '/register';

  static const String home = '/home';
}