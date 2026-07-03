import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.message = "Chargement...",
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const CircularProgressIndicator(),

          const SizedBox(height: 16),

          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

        ],
      ),
    );
  }
}