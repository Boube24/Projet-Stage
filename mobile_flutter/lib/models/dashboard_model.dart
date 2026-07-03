import 'claim_summary_model.dart';

class DashboardModel {
  final int totalClaims;
  final int newClaims;
  final int inProgressClaims;
  final int resolvedClaims;
  final int rejectedClaims;
  final int unreadNotifications;
  final List<ClaimSummaryModel> recentClaims;

  DashboardModel({
    required this.totalClaims,
    required this.newClaims,
    required this.inProgressClaims,
    required this.resolvedClaims,
    required this.rejectedClaims,
    required this.unreadNotifications,
    required this.recentClaims,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalClaims: json['totalClaims'],
      newClaims: json['newClaims'],
      inProgressClaims: json['inProgressClaims'],
      resolvedClaims: json['resolvedClaims'],
      rejectedClaims: json['rejectedClaims'],
      unreadNotifications: json['unreadNotifications'],
      recentClaims: (json['recentClaims'] as List)
          .map((e) => ClaimSummaryModel.fromJson(e))
          .toList(),
    );
  }
}