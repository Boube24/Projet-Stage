// import 'package:flutter/material.dart';

// class AppColors {
//   // Primary palette – Mauritanian flag inspired
//   static const Color primaryGreen  = Color(0xFF006233); // dark forest green
//   static const Color accentGold    = Color(0xFFCFA820); // star/crescent gold
//   static const Color flagRed       = Color(0xFFCD2027); // Mauritanian red band
//   static const Color bgLight       = Color(0xFFF5F5F5);
//   static const Color cardWhite     = Color(0xFFFFFFFF);
//   static const Color textDark      = Color(0xFF1A1A1A);
//   static const Color textGrey      = Color(0xFF757575);
//   static const Color textLight     = Color(0xFFBDBDBD);
//   static const Color inputBorder   = Color(0xFFE0E0E0);
//   static const Color greenLight    = Color(0xFF00833E);

//   // Category colours
//   static const Color voirie        = Color(0xFF006233);
//   static const Color eau           = Color(0xFF1565C0);
//   static const Color electricite   = Color(0xFFCD2027);
//   static const Color environnement = Color(0xFF2E7D32);

//   // Status chips
//   static const Color statusEnCours  = Color(0xFF1565C0);
//   static const Color statusResolu   = Color(0xFF2E7D32);
//   static const Color statusEnAttente= Color(0xFFE65100);
// }

// class AppTextStyles {
//   static const String fontFamily = 'Roboto';

//   static const TextStyle heading1 = TextStyle(
//     fontSize: 28, fontWeight: FontWeight.w700,
//     color: AppColors.cardWhite, letterSpacing: -0.5,
//   );
//   static const TextStyle heading2 = TextStyle(
//     fontSize: 22, fontWeight: FontWeight.w700,
//     color: AppColors.textDark,
//   );
//   static const TextStyle heading3 = TextStyle(
//     fontSize: 18, fontWeight: FontWeight.w600,
//     color: AppColors.textDark,
//   );
//   static const TextStyle body = TextStyle(
//     fontSize: 14, fontWeight: FontWeight.w400,
//     color: AppColors.textGrey,
//   );
//   static const TextStyle label = TextStyle(
//     fontSize: 12, fontWeight: FontWeight.w500,
//     color: AppColors.textGrey,
//   );
//   static const TextStyle buttonText = TextStyle(
//     fontSize: 16, fontWeight: FontWeight.w600,
//     color: AppColors.cardWhite, letterSpacing: 0.3,
//   );
// }

// ThemeData appTheme() => ThemeData(
//   fontFamily: AppTextStyles.fontFamily,
//   primaryColor: AppColors.primaryGreen,
//   scaffoldBackgroundColor: AppColors.bgLight,
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: AppColors.primaryGreen,
//     primary: AppColors.primaryGreen,
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     filled: true,
//     fillColor: AppColors.cardWhite,
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: AppColors.inputBorder),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: AppColors.inputBorder),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
//     ),
//     hintStyle: AppTextStyles.body.copyWith(color: AppColors.textLight),
//     prefixIconColor: AppColors.textGrey,
//     suffixIconColor: AppColors.textGrey,
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: AppColors.primaryGreen,
//       foregroundColor: AppColors.cardWhite,
//       minimumSize: const Size(double.infinity, 52),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//       textStyle: AppTextStyles.buttonText,
//       elevation: 0,
//     ),
//   ),
// );
// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
class AppColors {
  // Primary palette – Mauritanian flag inspired
  static const Color primaryGreen  = Color(0xFF006233); // dark forest green
  static const Color accentGold    = Color(0xFFCFA820); // star/crescent gold
  static const Color flagRed       = Color(0xFFCD2027); // Mauritanian red band
  static const Color bgLight       = Color(0xFFF5F5F5);
  static const Color cardWhite     = Color(0xFFFFFFFF);
  static const Color textDark      = Color(0xFF1A1A1A);
  static const Color textGrey      = Color(0xFF757575);
  static const Color textLight     = Color(0xFFBDBDBD);
  static const Color inputBorder   = Color(0xFFE0E0E0);
  static const Color greenLight    = Color(0xFF00833E);

  // Category colours
  static const Color voirie        = Color(0xFF006233);
  static const Color eau           = Color(0xFF1565C0);
  static const Color electricite   = Color(0xFFCD2027);
  static const Color environnement = Color(0xFF2E7D32);

  // Status chips
  static const Color statusEnCours  = Color(0xFF1565C0);
  static const Color statusResolu   = Color(0xFF2E7D32);
  static const Color statusEnAttente= Color(0xFFE65100);
}

class AppTextStyles {
  static const String fontFamily = 'Roboto';

  static const TextStyle heading1 = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700,
    color: AppColors.cardWhite, letterSpacing: -0.5,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
  );
  static const TextStyle label = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );
  static const TextStyle buttonText = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.cardWhite, letterSpacing: 0.3,
  );
}

ThemeData appTheme() => ThemeData(
  fontFamily: AppTextStyles.fontFamily,
  primaryColor: AppColors.primaryGreen,
  scaffoldBackgroundColor: AppColors.bgLight,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryGreen,
    primary: AppColors.primaryGreen,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.cardWhite,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.inputBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.inputBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
    ),
    hintStyle: AppTextStyles.body.copyWith(color: AppColors.textLight),
    prefixIconColor: AppColors.textGrey,
    suffixIconColor: AppColors.textGrey,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.cardWhite,
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      textStyle: AppTextStyles.buttonText,
      elevation: 0,
    ),
  ),
);
