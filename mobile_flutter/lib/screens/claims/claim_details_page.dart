import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';

import '../../providers/claim_provider.dart';
import '../../providers/status_history_provider.dart';

import '../../models/claim_details_model.dart';
import '../../models/media_model.dart';
import '../../models/status_history_model.dart';
import '../../core/constants/api_constants.dart';

// ─────────────────────────────────────────────────────────────────────────
// Sawti design tokens
// ─────────────────────────────────────────────────────────────────────────
class _SawtiColors {
  static const primaryGreen = Color(0xFF0B6B3A);
  static const darkGreen = Color(0xFF064A28);
  static const gold = Color(0xFFD4AF37);
  static const red = Color(0xFFD62828);
  static const background = Color(0xFFFDFBF7);
  static const card = Colors.white;
  static const grey = Color(0xFF9AA0A6);
  static const textDark = Color(0xFF1B1B1B);
}

class ClaimDetailsPage extends StatefulWidget {
  final int claimId;

  const ClaimDetailsPage({
    super.key,
    required this.claimId,
  });

  @override
  State<ClaimDetailsPage> createState() => _ClaimDetailsPageState();
}

class _ClaimDetailsPageState extends State<ClaimDetailsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // ── Original data-loading logic — unchanged ──
    Future.microtask(() async {
      await context.read<ClaimProvider>().loadClaimById(widget.claimId);
      await context.read<StatusHistoryProvider>().loadHistory(widget.claimId);
    });

    // ── UI-only entrance animation ──
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _playEntranceAnimationOnce() {
    if (_animController.status == AnimationStatus.dismissed) {
      _animController.forward();
    }
  }

  // ── Original status → color logic — kept, values updated to Sawti palette ──
  Color _statusColor(String status) {
    switch (status) {
      case "NEW":
        return _SawtiColors.gold;
      case "IN_PROGRESS":
        return _SawtiColors.primaryGreen;
      case "RESOLVED":
        return _SawtiColors.darkGreen;
      case "REJECTED":
        return _SawtiColors.red;
      default:
        return _SawtiColors.grey;
    }
  }

  // Soft background pair for the premium pill badge (style only)
  Color _statusSoftBg(String status) {
    switch (status) {
      case "NEW":
        return _SawtiColors.gold.withOpacity(0.14);
      case "IN_PROGRESS":
        return _SawtiColors.primaryGreen.withOpacity(0.12);
      case "RESOLVED":
        return _SawtiColors.darkGreen.withOpacity(0.12);
      case "REJECTED":
        return _SawtiColors.red.withOpacity(0.12);
      default:
        return _SawtiColors.grey.withOpacity(0.14);
    }
  }

  String _statusText(String status) {
    final l = AppLocalizations.of(context);
    switch (status) {
      case "NEW":
        return l.text("status_new");
      case "IN_PROGRESS":
        return l.text("status_in_progress");
      case "RESOLVED":
        return l.text("status_resolved");
      case "REJECTED":
        return l.text("status_rejected");
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final mq = MediaQuery.of(context);
    final isTablet = mq.size.width >= 700;
    final horizontalPad = isTablet ? 32.0 : 16.0;

    return Scaffold(
      backgroundColor: _SawtiColors.background,
      body: Consumer<ClaimProvider>(
        builder: (_, provider, __) {
          final ClaimDetailsModel? claim = provider.selectedClaim;

          if (!provider.isLoading && claim != null) {
            // fire the entrance animation once data is ready
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _playEntranceAnimationOnce();
            });
          }

          return Column(
            children: [
              _buildHeader(context, l, claim),
              Expanded(
                child: Builder(
                  builder: (_) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: _SawtiColors.primaryGreen,
                        ),
                      );
                    }

                    if (claim == null) {
                      return Center(
                        child: _emptyState(
                          icon: Icons.search_off_rounded,
                          text: l.text("claim_not_found"),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: _SawtiColors.primaryGreen,
                      onRefresh: () async {
                        await provider.loadClaimById(widget.claimId);
                      },
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPad,
                              vertical: 16,
                            ),
                            children: [
                              _buildStatusBadge(claim),
                              const SizedBox(height: 16),
                              _buildMainCard(claim, l),
                              const SizedBox(height: 16),
                              _buildDescriptionCard(claim, l),
                              const SizedBox(height: 16),
                              _buildAttachmentsCard(provider.media, l, context),
                              const SizedBox(height: 16),
                              _buildMapCard(claim, l),
                              const SizedBox(height: 16),
                              _buildInfoCard(claim, l),
                              const SizedBox(height: 16),
                              _buildTimelineCard(l),
                              const SizedBox(height: 24),
                              _buildCancelButton(l),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // HEADER
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildHeader(
      BuildContext context,
      AppLocalizations l,
      ClaimDetailsModel? claim,
      ) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_SawtiColors.primaryGreen, _SawtiColors.darkGreen],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.10,
                child: CustomPaint(
                  painter: _IslamicPatternPainter(),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _circleIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            l.text("claim_details"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (claim != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              claim.reference,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    _circleIconButton(
                      icon: Icons.more_vert,
                      onTap: () {
                        // Existing menu / actions logic (if any) stays wired
                        // by the caller — UI hook only.
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIconButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white.withOpacity(0.15),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // STATUS BADGE
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildStatusBadge(ClaimDetailsModel claim) {
    final color = _statusColor(claim.currentStatus);
    final bg = _statusSoftBg(claim.currentStatus);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              _statusText(claim.currentStatus),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // MAIN CARD
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildMainCard(ClaimDetailsModel claim, AppLocalizations l) {
    return _premiumCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _SawtiColors.primaryGreen.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.report_problem_rounded,
                    color: _SawtiColors.primaryGreen,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        claim.title,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: _SawtiColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 15, color: _SawtiColors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              claim.communeName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: _SawtiColors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                DateFormat("dd/MM/yyyy HH:mm").format(claim.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: _SawtiColors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // DESCRIPTION
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildDescriptionCard(ClaimDetailsModel claim, AppLocalizations l) {
    return _premiumCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _SawtiColors.primaryGreen.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.description_outlined,
                      size: 16, color: _SawtiColors.primaryGreen),
                ),
                const SizedBox(width: 10),
                Text(
                  l.text("description"),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: _SawtiColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              claim.description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.55,
                color: _SawtiColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // ATTACHMENTS — same media data & tap/navigation logic, new layout
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildAttachmentsCard(
      List<MediaModel> media,
      AppLocalizations l,
      BuildContext context,
      ) {
    return _premiumCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.text("photos"),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: _SawtiColors.textDark,
              ),
            ),
            const SizedBox(height: 14),
            if (media.isEmpty)
              _emptyState(
                icon: Icons.image_not_supported_outlined,
                text: l.text("no_photo"),
              )
            else
              SizedBox(
                height: 96,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: media.length > 4 ? 4 : media.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) {
                    // "+N autres" tile when there are more than 3 photos
                    final bool isOverflowTile = media.length > 4 && index == 3;
                    if (isOverflowTile) {
                      final remaining = media.length - 3;
                      return _attachmentOverflowTile(remaining, context, media);
                    }

                    final MediaModel item = media[index];
                    return _attachmentThumb(item, context, media, index);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentThumb(
      MediaModel media,
      BuildContext context,
      List<MediaModel> allMedia,
      int index,
      ) {
    return GestureDetector(
      onTap: () => _openFullScreenImage(context, media),
      child: Hero(
        tag: media.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            "${ApiConstants.serverUrl}/${media.url}",
            width: 96,
            height: 96,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                print(
                    "🔗 IMAGE URL LOADED SUCCESSFULLY = ${ApiConstants.baseUrl}/${media.url}");
                return child;
              }
              return const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print("🚨 FLUTTER IMAGE NETWORK ERROR = $error");
              return const Center(
                child: Icon(Icons.broken_image, size: 30, color: Colors.red),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _attachmentOverflowTile(
      int remaining,
      BuildContext context,
      List<MediaModel> allMedia,
      ) {
    return GestureDetector(
      onTap: () => _openFullScreenImage(context, allMedia[3]),
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: _SawtiColors.primaryGreen.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          "+$remaining\n${remaining == 1 ? 'autre' : 'autres'}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _SawtiColors.primaryGreen,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // Same navigation target / Hero tag / Image.network logic as the original
  void _openFullScreenImage(BuildContext context, MediaModel media) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: InteractiveViewer(
                child: Hero(
                  tag: media.id,
                  child: Image.network(
                    "${ApiConstants.serverUrl}/${media.url}",
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        print(
                            "🔗 IMAGE URL LOADED SUCCESSFULLY = ${ApiConstants.baseUrl}/${media.url}");
                        return child;
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print("🚨 FLUTTER IMAGE NETWORK ERROR = $error");
                      return const Center(
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.red),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // MAP PREVIEW — same GoogleMap widget/properties, new card wrapper
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildMapCard(ClaimDetailsModel claim, AppLocalizations l) {
    return _premiumCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.text("location"),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _SawtiColors.textDark,
              ),
            ),
            const SizedBox(height: 14),
            if (claim.latitude != null && claim.longitude != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  height: 180,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        claim.latitude!,
                        claim.longitude!,
                      ),
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("claim"),
                        position: LatLng(
                          claim.latitude!,
                          claim.longitude!,
                        ),
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                  ),
                ),
              )
            else
              _emptyState(
                icon: Icons.map_outlined,
                text: l.text("no_location"),
              ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // INFO CARD — same claim fields, new row style
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildInfoCard(ClaimDetailsModel claim, AppLocalizations l) {
    return _premiumCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Column(
          children: [
            _infoRow(
              icon: Icons.category_outlined,
              label: l.text("category"),
              value: claim.categoryName,
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _infoRow(
              icon: Icons.location_city_outlined,
              label: l.text("commune"),
              value: claim.communeName,
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _infoRow(
              icon: Icons.calendar_today_outlined,
              label: l.text("created_at"),
              value: DateFormat("dd/MM/yyyy HH:mm").format(claim.createdAt),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _infoRow(
              icon: Icons.update_outlined,
              label: l.text("updated_at"),
              value: DateFormat("dd/MM/yyyy HH:mm").format(claim.updatedAt),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _SawtiColors.primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: _SawtiColors.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: _SawtiColors.textDark,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _SawtiColors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // TIMELINE — same StatusHistoryProvider / history logic, new visual
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildTimelineCard(AppLocalizations l) {
    return _premiumCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Consumer<StatusHistoryProvider>(
          builder: (_, historyProvider, __) {
            print("UI History = ${historyProvider.history.length}");

            if (historyProvider.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: _SawtiColors.primaryGreen,
                  ),
                ),
              );
            }

            if (historyProvider.history.isEmpty) {
              return _emptyState(
                icon: Icons.history_toggle_off,
                text: l.text("no_history"),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Suivi de la réclamation",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _SawtiColors.textDark,
                  ),
                ),
                const SizedBox(height: 18),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: historyProvider.history.length,
                  itemBuilder: (_, index) {
                    final history = historyProvider.history[index];
                    final isLastItem =
                        index == historyProvider.history.length - 1;
                    // Latest entry (index 0) treated as the current step.
                    final bool isCurrent = index == 0;
                    final Color dotColor = isCurrent
                        ? _statusColor(history.newStatus)
                        : _SawtiColors.darkGreen;

                    return _TimelineTile(
                      isLast: isLastItem,
                      isCurrent: isCurrent,
                      dotColor: dotColor,
                      title: _statusText(history.newStatus),
                      subtitle: history.changedByName,
                      comment: history.comment,
                      date:
                      DateFormat("dd/MM/yyyy HH:mm").format(history.changedAt),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // CANCEL BUTTON (UI only — wire the onPressed to your existing
  // cancel-claim method/provider call; no such method existed in the
  // original file, so none is invented here).
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildCancelButton(AppLocalizations l) {
    return _AnimatedPressable(
      onTap: () {
        // TODO: hook this up to your existing cancel-claim logic,
        // e.g. context.read<ClaimProvider>().cancelClaim(widget.claimId);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _SawtiColors.red, width: 1.4),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: _SawtiColors.red, size: 20),
            SizedBox(width: 8),
            Text(
              "Annuler la réclamation",
              style: TextStyle(
                color: _SawtiColors.red,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Shared helpers
  // ───────────────────────────────────────────────────────────────────────
  Widget _premiumCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: _SawtiColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _emptyState({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 34, color: _SawtiColors.grey.withOpacity(0.6)),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(color: _SawtiColors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Vertical timeline tile
// ─────────────────────────────────────────────────────────────────────────
class _TimelineTile extends StatelessWidget {
  final bool isLast;
  final bool isCurrent;
  final Color dotColor;
  final String title;
  final String subtitle;
  final String? comment;
  final String date;

  const _TimelineTile({
    required this.isLast,
    required this.isCurrent,
    required this.dotColor,
    required this.title,
    required this.subtitle,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isCurrent ? dotColor : dotColor.withOpacity(0.85),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: dotColor.withOpacity(0.35),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: _SawtiColors.grey.withOpacity(0.25),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: isCurrent
                                ? _SawtiColors.textDark
                                : _SawtiColors.textDark.withOpacity(0.75),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: _SawtiColors.grey,
                            fontSize: 12.5,
                          ),
                        ),
                        if (comment != null && comment!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            comment!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: _SawtiColors.textDark,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: const TextStyle(
                      color: _SawtiColors.grey,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Subtle Islamic geometric pattern used behind the header
// ─────────────────────────────────────────────────────────────────────────
class _IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    const spacing = 34.0;
    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        _drawStar(canvas, paint, Offset(x, y), 10);
      }
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double r) {
    final path = Path();
    const points = 8;
    for (int i = 0; i < points; i++) {
      final angle = (math.pi / points) * i * 2;
      final radius = i.isEven ? r : r * 0.5;
      final offset = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────
// Small press-animation wrapper for buttons
// ─────────────────────────────────────────────────────────────────────────
class _AnimatedPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _AnimatedPressable({required this.child, required this.onTap});

  @override
  State<_AnimatedPressable> createState() => _AnimatedPressableState();
}

class _AnimatedPressableState extends State<_AnimatedPressable> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
