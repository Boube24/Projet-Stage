import 'package:flutter/material.dart';

import '../../core/constants/claim_status.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        ClaimStatusConstants.icon(status),
        color: Colors.white,
        size: 18,
      ),
      label: Text(
        ClaimStatusConstants.label(status),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor:
      ClaimStatusConstants.color(status),
    );
  }
}