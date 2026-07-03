import 'package:flutter/material.dart';

class AppDialog {

  /// Confirmation
  static Future<bool> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "Confirmer",
    String cancelText = "Annuler",
  }) async {

    final result = await showDialog<bool>(

      context: context,

      builder: (_) => AlertDialog(

        title: Text(title),

        content: Text(message),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.pop(
                context,
                false,
              );

            },

            child: Text(cancelText),

          ),

          ElevatedButton(

            onPressed: () {

              Navigator.pop(
                context,
                true,
              );

            },

            child: Text(confirmText),

          ),

        ],

      ),

    );

    return result ?? false;
  }

  /// Succès
  static Future<void> success({
    required BuildContext context,
    required String title,
    required String message,
  }) {

    return showDialog(

      context: context,

      builder: (_) => AlertDialog(

        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 50,
        ),

        title: Text(title),

        content: Text(message),

        actions: [

          ElevatedButton(

            onPressed: () {

              Navigator.pop(context);

            },

            child: const Text("OK"),

          ),

        ],

      ),

    );
  }

  /// Erreur
  static Future<void> error({
    required BuildContext context,
    required String title,
    required String message,
  }) {

    return showDialog(

      context: context,

      builder: (_) => AlertDialog(

        icon: const Icon(
          Icons.error,
          color: Colors.red,
          size: 50,
        ),

        title: Text(title),

        content: Text(message),

        actions: [

          ElevatedButton(

            onPressed: () {

              Navigator.pop(context);

            },

            child: const Text("OK"),

          ),

        ],

      ),

    );
  }
}