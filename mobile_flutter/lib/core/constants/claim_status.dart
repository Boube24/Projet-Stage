import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ClaimStatusConstants {
  ClaimStatusConstants._();

  static const String newClaim = "NEW";
  static const String inProgress = "IN_PROGRESS";
  static const String resolved = "RESOLVED";
  static const String rejected = "REJECTED";

  static String label(String status) {
    switch (status.toUpperCase()) {
      case newClaim:
        return "Nouvelle";

      case inProgress:
        return "En cours";

      case resolved:
        return "Résolue";

      case rejected:
        return "Rejetée";

      default:
        return status;
    }
  }

  static Color color(String status) {
    switch (status.toUpperCase()) {
      case newClaim:
        return Colors.blue;

      case inProgress:
        return Colors.orange;

      case resolved:
        return AppColors.success;

      case rejected:
        return AppColors.error;

      default:
        return Colors.grey;
    }
  }

  static IconData icon(String status) {
    switch (status.toUpperCase()) {
      case newClaim:
        return Icons.fiber_new;

      case inProgress:
        return Icons.sync;

      case resolved:
        return Icons.check_circle;

      case rejected:
        return Icons.cancel;

      default:
        return Icons.help;
    }
  }
}