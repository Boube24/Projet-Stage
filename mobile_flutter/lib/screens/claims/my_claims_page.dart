import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/claim_provider.dart';
import '../../widgets/app_app_bar.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/app_error.dart';
import '../../widgets/app_empty.dart';
import '../../widgets/business/claim_card.dart';

import 'claim_details_page.dart';
import 'create_claim_page.dart';

class MyClaimsPage extends StatefulWidget {
  const MyClaimsPage({super.key});

  @override
  State<MyClaimsPage> createState() => _MyClaimsPageState();
}

class _MyClaimsPageState extends State<MyClaimsPage> {
  // "ALL" | "IN_PROGRESS" | "RESOLVED" | "REJECTED"
  String _selectedStatus = "ALL";

  static const List<_StatusTab> _tabs = [
    _StatusTab(value: "ALL", label: "Toutes"),
    _StatusTab(value: "IN_PROGRESS", label: "En cours"),
    _StatusTab(value: "RESOLVED", label: "Résolues"),
    _StatusTab(value: "REJECTED", label: "Rejetées"),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ClaimProvider>().loadMyClaims();
    });
  }

  List get filteredClaims {
    final provider = context.read<ClaimProvider>();
    return provider.claims.where((claim) {
      final matchStatus =
          _selectedStatus == "ALL" || claim.currentStatus == _selectedStatus;
      return matchStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClaimProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(
        title: "Mes réclamations",
        automaticallyImplyLeading: false,
      ),
      body: Builder(
        builder: (_) {
          if (provider.isLoading) {
            return const AppLoading();
          }

          if (provider.error != null) {
            return AppError(
              message: provider.error!,
              onRetry: () {
                provider.loadMyClaims();
              },
            );
          }

          if (provider.claims.isEmpty) {
            return RefreshIndicator(
              onRefresh: provider.loadMyClaims,
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const AppEmpty(message: "Aucune réclamation trouvée"),
                  ),
                ],
              ),
            );
          }

          final claims = filteredClaims;

          return Column(
            children: [
              // Segmented status tab bar (fixed at top)
              _ClaimStatusTabBar(
                tabs: _tabs,
                selectedValue: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),

              // List section, scrollable, wrapped with RefreshIndicator
              Expanded(
                child: claims.isEmpty
                    ? RefreshIndicator(
                  onRefresh: provider.loadMyClaims,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const AppEmpty(message: "Aucun résultat"),
                      ),
                    ],
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: provider.loadMyClaims,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    itemCount: claims.length,
                    itemBuilder: (_, index) {
                      final claim = claims[index];
                      return ClaimCard(
                        claim: claim,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ClaimDetailsPage(claimId: claim.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusTab {
  const _StatusTab({required this.value, required this.label});

  final String value;
  final String label;
}

/// Modern Material 3 segmented tab bar: green text + underline for the
/// selected tab, gray text for inactive tabs.
class _ClaimStatusTabBar extends StatelessWidget {
  const _ClaimStatusTabBar({
    required this.tabs,
    required this.selectedValue,
    required this.onChanged,
  });

  final List<_StatusTab> tabs;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  static const Color _primary = Color(0xFF0B6E3E);
  static const Color _inactive = Color(0xFF9AA0A6);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEDEFF1), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tabs.map((tab) {
          final isSelected = tab.value == selectedValue;
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(tab.value),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tab.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? _primary : _inactive,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 3,
                      width: isSelected ? 28 : 0,
                      decoration: BoxDecoration(
                        color: _primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
