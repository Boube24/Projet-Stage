
import 'package:flutter/material.dart';
import 'package:mobile_flutter/core/theme/app_theme.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<_Complaint> _recents = const [
    _Complaint(icon: Icons.construction, color: AppColors.voirie,
        title: 'Route endommagée', location: 'Nouakchott, Tevragh Zeina',
        status: 'En cours', statusColor: AppColors.statusEnCours),
    _Complaint(icon: Icons.water_drop, color: AppColors.eau,
        title: 'Fuite d\'eau', location: 'Nouakchott, Ksar',
        status: 'Résolu', statusColor: AppColors.statusResolu),
    _Complaint(icon: Icons.bolt, color: AppColors.electricite,
        title: 'Panne d\'électricité', location: 'Nouakchott, Arafat',
        status: 'En cours', statusColor: AppColors.statusEnCours),
    _Complaint(icon: Icons.eco, color: AppColors.environnement,
        title: 'Déchets sauvages', location: 'Nouakchott, Sebkha',
        status: 'En attente', statusColor: AppColors.statusEnAttente),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Column(
        children: [
          // ── Top hero header
          _HomeHeroHeader(),

          // ── Scrollable body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category section card
                  _SectionCard(
                    title: 'Signaler un problème',
                    subtitle: 'Choisissez une catégorie pour commencer',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _CategoryItem(icon: Icons.construction, label: 'Voirie',
                            color: AppColors.voirie),
                        _CategoryItem(icon: Icons.water_drop, label: 'Eau',
                            color: AppColors.eau),
                        _CategoryItem(icon: Icons.bolt, label: 'Électricité',
                            color: AppColors.electricite),
                        _CategoryItem(icon: Icons.eco, label: 'Environnement',
                            color: AppColors.environnement),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Recent complaints
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Signalements récents', style: AppTextStyles.heading3),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Voir tout',
                            style: TextStyle(color: AppColors.primaryGreen,
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._recents.map((c) => _ComplaintCard(complaint: c)).toList(),
                  const SizedBox(height: 80), // nav bar clearance
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom navigation
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(icon: Icons.home, label: 'Accueil',
                    selected: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0)),
                // FAB central
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 56, height: 56,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryGreen,
                          boxShadow: [
                            BoxShadow(color: Color(0x4400833E),
                                blurRadius: 12, offset: Offset(0, 4)),
                          ],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 28),
                      ),
                    ),
                  ),
                ),
                _NavItem(icon: Icons.person_outline, label: 'Profil',
                    selected: _currentIndex == 2,
                    onTap: () => setState(() => _currentIndex = 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Top hero header with green gradient + greeting
class _HomeHeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF004D25), AppColors.primaryGreen],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Subtle city silhouette at bottom
            Positioned.fill(child: CustomPaint(painter: _HeroBgPainter())),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar: menu + notifications + avatar
                  Row(
                    children: [
                      const Icon(Icons.menu, color: Colors.white, size: 26),
                      const Spacer(),
                      Stack(
                        children: [
                          const Icon(Icons.notifications_outlined,
                              color: Colors.white, size: 26),
                          Positioned(
                            right: 0, top: 0,
                            child: Container(
                              width: 14, height: 14,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.flagRed,
                              ),
                              child: const Center(
                                child: Text('2',
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 8, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Avatar
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accentGold, width: 2),
                          color: AppColors.accentGold.withOpacity(0.2),
                        ),
                        child: const Icon(Icons.star, color: AppColors.accentGold, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Greeting
                  const Text('Bonjour,',
                      style: TextStyle(color: Colors.white70, fontSize: 15)),
                  Row(
                    children: const [
                      Text('Citoyen ', style: TextStyle(
                          color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      Text('👋', style: TextStyle(fontSize: 22)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Ensemble, améliorons notre pays.',
                      style: TextStyle(color: Colors.white60, fontSize: 12)),

                  const SizedBox(height: 16),
                  // Mauritanian flag banner line + city at bottom
                  SizedBox(
                    height: 80,
                    child: Stack(
                      children: [
                        // City silhouette
                        Positioned.fill(child: CustomPaint(painter: _CitySilhouettePainter())),
                        // Flag
                        Positioned(bottom: 10, right: 0,
                          child: _AnimatedFlag()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 60, height: 40,
    child: Column(children: [
      Expanded(flex: 1, child: Container(color: AppColors.flagRed)),
      Expanded(flex: 2, child: Container(
        color: AppColors.primaryGreen,
        child: const Center(child: Text('☽⭐', style: TextStyle(fontSize: 12))),
      )),
      Expanded(flex: 1, child: Container(color: AppColors.flagRed)),
    ]),
  );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const _SectionCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
          blurRadius: 10, offset: const Offset(0, 2))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.heading3),
        const SizedBox(height: 2),
        Text(subtitle, style: AppTextStyles.body.copyWith(fontSize: 12)),
        const SizedBox(height: 14),
        child,
      ],
    ),
  );
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _CategoryItem({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {},
    child: Column(
      children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle, color: color,
            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
            color: AppColors.textDark)),
      ],
    ),
  );
}

class _ComplaintCard extends StatelessWidget {
  final _Complaint complaint;
  const _ComplaintCard({required this.complaint});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
          blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Row(
      children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: complaint.color.withOpacity(0.12),
          ),
          child: Icon(complaint.icon, color: complaint.color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(complaint.title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
              const SizedBox(height: 2),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textGrey),
                const SizedBox(width: 2),
                Text(complaint.location,
                    style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ]),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: complaint.statusColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(complaint.status,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: complaint.statusColor)),
        ),
      ],
    ),
  );
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label,
    required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: selected ? AppColors.primaryGreen : AppColors.textLight,
              size: 24),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500,
                color: selected ? AppColors.primaryGreen : AppColors.textLight,
              )),
        ],
      ),
    ),
  );
}

@immutable
class _Complaint {
  final IconData icon;
  final Color color;
  final String title;
  final String location;
  final String status;
  final Color statusColor;
  const _Complaint({required this.icon, required this.color,
    required this.title, required this.location,
    required this.status, required this.statusColor});
}

class _HeroBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 80, p);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.8), 50, p);
  }
  @override bool shouldRepaint(_) => false;
}

class _CitySilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.55)
      ..lineTo(size.width * 0.06, size.height * 0.55)
      ..lineTo(size.width * 0.06, size.height * 0.35)
      ..lineTo(size.width * 0.09, size.height * 0.25)
      ..lineTo(size.width * 0.12, size.height * 0.35)
      ..lineTo(size.width * 0.12, size.height * 0.5)
      ..lineTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.2, size.height * 0.4)
      ..lineTo(size.width * 0.26, size.height * 0.3)
      ..lineTo(size.width * 0.32, size.height * 0.4)
      ..lineTo(size.width * 0.32, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.38)
      ..lineTo(size.width * 0.55, size.height * 0.2)
      ..lineTo(size.width * 0.6, size.height * 0.38)
      ..lineTo(size.width * 0.6, size.height * 0.55)
      ..lineTo(size.width * 0.7, size.height * 0.55)
      ..lineTo(size.width * 0.7, size.height * 0.42)
      ..lineTo(size.width * 0.76, size.height * 0.42)
      ..lineTo(size.width * 0.76, size.height * 0.58)
      ..lineTo(size.width, size.height * 0.58)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(_) => false;
}
