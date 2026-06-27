// import 'package:flutter/material.dart';

// import 'core/routes/app_routes.dart';
// import 'core/routes/route_generator.dart';

// void main() {
//   runApp(const CitizenApp());
// }

// class CitizenApp extends StatelessWidget {
//   const CitizenApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: AppRoutes.splash,
//       onGenerateRoute: RouteGenerator.generateRoute,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_flutter/core/theme/app_theme.dart';
import 'package:mobile_flutter/screens/splash/splash_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const SawtiApp());
}

class SawtiApp extends StatelessWidget {
  const SawtiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAWTI',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: const SplashScreen(),
    );
  }
}