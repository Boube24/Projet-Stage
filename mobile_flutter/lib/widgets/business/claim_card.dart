// import 'package:flutter/material.dart';
//
// import '../../models/claim_summary_model.dart';
// import '../app_card.dart';
// import 'status_chip.dart';
// import '../../core/utils/date_formatter.dart';
//
// class ClaimCard extends StatelessWidget {
//   const ClaimCard({
//     super.key,
//     required this.claim,
//     this.onTap,
//   });
//
//   final ClaimSummaryModel claim;
//
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return AppCard(
//
//       onTap: onTap,
//
//       child: Column(
//
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//
//         children: [
//
//           Row(
//
//             children: [
//
//               Expanded(
//
//                 child: Text(
//
//                   claim.title,
//
//                   style: const TextStyle(
//
//                     fontSize: 18,
//
//                     fontWeight:
//                     FontWeight.bold,
//
//                   ),
//
//                 ),
//
//               ),
//
//               StatusChip(
//                 status: claim.currentStatus,
//               ),
//
//             ],
//
//           ),
//
//           const SizedBox(height: 12),
//
//           Row(
//
//             children: [
//
//               const Icon(
//                 Icons.confirmation_number,
//                 size: 18,
//               ),
//
//               const SizedBox(width: 8),
//
//               Expanded(
//
//                 child: Text(
//                   claim.reference,
//                 ),
//
//               ),
//
//             ],
//
//           ),
//
//           const SizedBox(height: 10),
//
//           Row(
//
//             children: [
//
//               const Icon(
//                 Icons.category,
//                 size: 18,
//               ),
//
//               const SizedBox(width: 8),
//
//               Expanded(
//
//                 child: Text(
//                   claim.categoryName ?? '',
//                 ),
//
//               ),
//
//             ],
//
//           ),
//
//           const SizedBox(height: 10),
//
//           Row(
//
//             children: [
//
//               const Icon(
//                 Icons.location_city,
//                 size: 18,
//               ),
//
//               const SizedBox(width: 8),
//
//               Expanded(
//
//                 child: Text(
//                   claim.communeName ?? '',
//                 ),
//
//               ),
//
//             ],
//
//           ),
//
//           const Divider(height: 30),
//
//           Row(
//
//             children: [
//
//               const Icon(
//                 Icons.schedule,
//                 size: 18,
//               ),
//
//               const SizedBox(width: 8),
//
//               Expanded(
//
//                 child: Text(
//                     DateFormatter.format(
//                         claim.createdAt.toString()),
//                   ),
//
//               ),
//
//               const Icon(
//                 Icons.arrow_forward_ios,
//                 size: 16,
//               ),
//
//             ],
//
//           ),
//
//         ],
//
//       ),
//
//     );
//
//   }
//


import 'package:flutter/material.dart';

import '../../models/claim_summary_model.dart';
import '../../core/utils/date_formatter.dart';

/// Shared design tokens for the claims UI (kept local to this file so the
/// widget is self-contained; move to a theme/constants file if you already
/// have one).
class ClaimUiColors {
  ClaimUiColors._();

  static const primary = Color(0xFF0B6E3E);
  static const border = Color(0xFFE9ECEF);
  static const textPrimary = Color(0xFF1A1D1F);
  static const textSecondary = Color(0xFF7A8288);

  static const statusNew = Color(0xFF2F80ED);
  static const statusInProgress = Color(0xFFF2994A);
  static const statusResolved = Color(0xFF0B6E3E);
  static const statusRejected = Color(0xFFEB5757);
}

class ClaimCard extends StatelessWidget {
  const ClaimCard({
    super.key,
    required this.claim,
    this.onTap,
  });

  final ClaimSummaryModel claim;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final reference =
    claim.reference.startsWith('#') ? claim.reference : '#${claim.reference}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ClaimUiColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + status badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              claim.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: ClaimUiColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _StatusBadge(status: claim.currentStatus),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Location
                      Text(
                        claim.communeName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: ClaimUiColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Date + reference
                      Row(
                        children: [
                          Text(
                            DateFormatter.format(claim.createdAt.toString()),
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: ClaimUiColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            reference,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: ClaimUiColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: ClaimUiColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  Color get _color {
    switch (status) {
      case 'NEW':
        return ClaimUiColors.statusNew;
      case 'IN_PROGRESS':
        return ClaimUiColors.statusInProgress;
      case 'RESOLVED':
        return ClaimUiColors.statusResolved;
      case 'REJECTED':
        return ClaimUiColors.statusRejected;
      default:
        return ClaimUiColors.textSecondary;
    }
  }

  String get _label {
    switch (status) {
      case 'NEW':
        return 'Nouvelle';
      case 'IN_PROGRESS':
        return 'En cours';
      case 'RESOLVED':
        return 'Résolue';
      case 'REJECTED':
        return 'Rejetée';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// }