import 'package:flutter/material.dart';

class AppEmpty extends StatelessWidget {
  const AppEmpty({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.buttonText,
    this.onPressed,
  });

  final String message;

  final IconData icon;

  final String? buttonText;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              icon,
              size: 80,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            if (buttonText != null &&
                onPressed != null) ...[

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.add),
                label: Text(buttonText!),
              ),

            ]

          ],
        ),
      ),
    );
  }
}