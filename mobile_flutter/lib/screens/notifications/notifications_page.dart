import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';

import '../../models/notification_model.dart';

import '../claims/claim_details_page.dart';

// ============================================================
// DESIGN TOKENS — Mauritanian government identity palette
// ============================================================
class _NotifColors {
  static const Color primaryGreen = Color(0xFF0B6B3A);
  static const Color darkGreen = Color(0xFF064A28);
  static const Color gold = Color(0xFFD4AF37);
  static const Color errorRed = Color(0xFFD62828);
  static const Color background = Color(0xFFFDFBF7);
  static const Color cardWhite = Colors.white;
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int? _userId;

  // UI-only state for the tabs (0: Toutes / 1: Non lues).
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final auth = context.read<AuthProvider>();
      _userId = auth.user?.id;

      print("USER ID = $_userId");

      if (_userId != null) {
        await context.read<NotificationProvider>().loadNotifications(_userId!);
        print("Notifications loaded");
      }
    });
  }

  Future<void> _refresh() async {
    if (_userId == null) return;
    await context.read<NotificationProvider>().refresh(_userId!);
  }

  // ------------------------------------------------------------
  // UI HELPERS (presentation only — no business logic)
  // ------------------------------------------------------------
  static const List<String> _frMonths = [
    'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
    'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
  ];

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 60) return "À l'instant";
    if (diff.inMinutes < 60) return "Il y a ${diff.inMinutes} min";
    if (diff.inHours < 24) return "Il y a ${diff.inHours} h";

    final today = DateTime(now.year, now.month, now.day);
    final thatDay = DateTime(dt.year, dt.month, dt.day);
    final dayDiff = today.difference(thatDay).inDays;

    if (dayDiff == 1) return "Hier";
    if (dayDiff < 7) return "${dt.day} ${_frMonths[dt.month - 1]}";
    return "${dt.day} ${_frMonths[dt.month - 1]} ${dt.year}";
  }

  (IconData, Color) _iconForNotification(NotificationModel n) {
    final t = n.title.toLowerCase();

    if (t.contains('résolu') || t.contains('resolu')) {
      return (Icons.check_circle_outline, _NotifColors.primaryGreen);
    }
    if (t.contains('annul') || t.contains('supprim')) {
      return (Icons.delete_outline, _NotifColors.errorRed);
    }
    if (t.contains('message')) {
      return (Icons.notifications_active_outlined, _NotifColors.gold);
    }
    if (t.contains('information') || t.contains('info')) {
      return (Icons.campaign_outlined, _NotifColors.gold);
    }
    if (t.contains('enregistr') || t.contains('créé') || t.contains('cree')) {
      return (Icons.description_outlined, _NotifColors.primaryGreen);
    }
    if (n.claimId != null) {
      return (Icons.assignment_outlined, _NotifColors.primaryGreen);
    }
    return (Icons.notifications_outlined, _NotifColors.primaryGreen);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _NotifColors.primaryGreen,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Consumer<NotificationProvider>(
                builder: (_, provider, __) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: _NotifColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildTabs(provider),
                        const SizedBox(height: 12),
                        Expanded(
                          child: _buildBody(provider),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _NotifColors.primaryGreen,
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Islamic geometric decorations
            Positioned(
              top: -10,
              left: -20,
              child: Opacity(
                opacity: 0.06,
                child: const Icon(Icons.star, size: 90, color: Colors.white),
              ),
            ),
            Positioned(
              top: 40,
              right: -25,
              child: Opacity(
                opacity: 0.06,
                child: const Icon(Icons.star, size: 120, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 40,
              child: Opacity(
                opacity: 0.05,
                child: const Icon(Icons.brightness_high, size: 70, color: Colors.white),
              ),
            ),

            // Main Content (Sawti Title & Subtitle)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Sawti",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Votre voix, votre engagement",
                            style: TextStyle(
                              color: _NotifColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Settings button
            Positioned(
              top: 20,
              right: 16,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TABS
  // ------------------------------------------------------------
  Widget _buildTabs(NotificationProvider provider) {
    final totalCount = provider.notifications.length;
    final unreadCount = provider.unread.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _tabItem(
              label: "Toutes",
              count: totalCount,
              index: 0,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _tabItem(
              label: "Non lues",
              count: unreadCount,
              index: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabItem({
    required String label,
    required int count,
    required int index,
  }) {
    final bool selected = _selectedTab == index;

    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? _NotifColors.darkGreen : Colors.black45,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: selected
                      ? _NotifColors.primaryGreen.withOpacity(0.12)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$count",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: selected ? _NotifColors.primaryGreen : Colors.black45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: selected ? 40 : 0, // تم زيادة العرض قليلاً ليناسب التوزيع الجديد
            decoration: BoxDecoration(
              color: _NotifColors.primaryGreen,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BODY (loading / empty / list)
  // ------------------------------------------------------------
  Widget _buildBody(NotificationProvider provider) {
    if (provider.isLoading) {
      return _buildLoading();
    }

    if (provider.notifications.isEmpty) {
      return _buildEmpty();
    }

    List<NotificationModel> items;
    if (_selectedTab == 1) {
      items = provider.unread;
    } else {
      items = provider.notifications;
    }

    if (items.isEmpty) {
      return _buildEmpty();
    }

    return RefreshIndicator(
      color: _NotifColors.primaryGreen,
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final NotificationModel notification = items[index];

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 300 + (index * 40).clamp(0, 400)),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 16),
                  child: child,
                ),
              );
            },
            child: _buildNotificationCard(provider, notification),
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: _NotifColors.primaryGreen,
          ),
          const SizedBox(height: 16),
          Text(
            "Chargement des notifications...",
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return RefreshIndicator(
      color: _NotifColors.primaryGreen,
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.12),
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: _NotifColors.primaryGreen.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 48,
                color: _NotifColors.primaryGreen.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              "Aucune notification",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _NotifColors.darkGreen,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                "Vous n'avez aucune notification pour le moment.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.45),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // NOTIFICATION CARD
  // ------------------------------------------------------------
  Widget _buildNotificationCard(
      NotificationProvider provider,
      NotificationModel notification,
      ) {
    final (icon, color) = _iconForNotification(notification);

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: _NotifColors.primaryGreen,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) async {
        if (_userId != null) {
          await provider.markAsRead(
            notification.id,
            _userId!,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _NotifColors.cardWhite,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () async {
              if (!notification.isRead && _userId != null) {
                await provider.markAsRead(
                  notification.id,
                  _userId!,
                );
              }

              if (!mounted) return;

              if (notification.claimId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClaimDetailsPage(
                      claimId: notification.claimId!,
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Unread dot
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 6),
                    child: SizedBox(
                      width: 8,
                      child: !notification.isRead
                          ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: _NotifColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      )
                          : null,
                    ),
                  ),

                  // Icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),

                  const SizedBox(width: 12),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                                  color: _NotifColors.darkGreen,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatTime(notification.sentAt),
                              style: TextStyle(
                                  fontSize: 11.5, color: Colors.black.withOpacity(0.4)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: Colors.black.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.black.withOpacity(0.25),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}