import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/splash/splash_screen.dart';
import 'app_routes.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(
      RouteSettings settings) {

    switch (settings.name) {

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) =>
          const LoginScreen(),
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) =>
          const RegisterScreen(),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) =>
          const HomeScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
          const SplashScreen(),
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