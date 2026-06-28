
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_flutter/core/theme/app_theme.dart';
import 'package:mobile_flutter/screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF004D25), Color(0xFF001A0D)],
              ),
            ),
          ),

          // ── Mauritania map silhouette watermark
          Positioned.fill(
            child: CustomPaint(painter: _MapWatermarkPainter()),
          ),

          // ── Gold star constellation dots (decorative)
          ..._starDots(),

          // ── Main content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo + pin marker
                FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Column(
                      children: [
                        // Location pin with logo
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(Icons.location_pin,
                                size: 130, color: AppColors.accentGold),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _SawtiLogoIcon(size: 58),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // SAWTI lettering
                        Text('SAWTI',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 6,
                            shadows: [
                              Shadow(
                                color: AppColors.accentGold.withOpacity(0.5),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Tagline – Signalez, Suivez, Améliorez
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 15, letterSpacing: 0.5),
                            children: [
                              TextSpan(text: 'Signalez. ', style: TextStyle(color: Colors.white70)),
                              TextSpan(text: 'Suivez. ', style: TextStyle(color: Colors.white70)),
                              TextSpan(text: 'Améliorez.',
                                  style: TextStyle(color: AppColors.accentGold,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                        // Gold divider stars
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: AppColors.accentGold, size: 14),
                            const SizedBox(width: 8),
                            Container(width: 60, height: 1,
                                color: AppColors.accentGold.withOpacity(0.4)),
                            const SizedBox(width: 8),
                            const Icon(Icons.star, color: AppColors.accentGold, size: 14),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Mauritanian flag wave
                _FlagWaveDecoration(),

                // Bottom label
                Container(
                  color: Colors.black.withOpacity(0.3),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: const [
                      Text('RÉPUBLIQUE ISLAMIQUE DE MAURITANIE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70, fontSize: 10,
                          fontWeight: FontWeight.w600, letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('PLATEFORME CITOYENNE INTELLIGENTE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.accentGold, fontSize: 10,
                          fontWeight: FontWeight.w700, letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _starDots() {
    final positions = [
      [0.1, 0.08], [0.85, 0.12], [0.25, 0.22], [0.7, 0.18],
      [0.05, 0.45], [0.92, 0.35], [0.15, 0.65], [0.8, 0.6],
    ];
    return positions.map((p) => Positioned(
      left: MediaQuery.of(context).size.width * p[0],
      top: MediaQuery.of(context).size.height * p[1],
      child: Container(
        width: 3, height: 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accentGold.withOpacity(0.6),
        ),
      ),
    )).toList();
  }
}

// ── Shared logo icon (people inside location pin circle)
class _SawtiLogoIcon extends StatelessWidget {
  final double size;
  const _SawtiLogoIcon({this.size = 48});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.primaryGreen,
      border: Border.all(color: AppColors.accentGold, width: 2),
    ),
    child: Icon(Icons.people, color: Colors.white, size: size * 0.55),
  );
}

// ── Flag wave decoration
class _FlagWaveDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 60,
    child: CustomPaint(
      painter: _FlagWavePainter(),
      size: Size(MediaQuery.of(context).size.width, 60),
    ),
  );
}

class _FlagWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Green wave
    final g = Paint()..color = AppColors.primaryGreen..style = PaintingStyle.fill;
    final gPath = Path()
      ..moveTo(0, 20)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 20)
      ..quadraticBezierTo(size.width * 0.75, 40, size.width, 20)
      ..lineTo(size.width, 60) ..lineTo(0, 60) ..close();
    canvas.drawPath(gPath, g);

    // Red band
    final r = Paint()..color = AppColors.flagRed..style = PaintingStyle.fill;
    final rPath = Path()
      ..moveTo(0, 38)
      ..quadraticBezierTo(size.width * 0.25, 18, size.width * 0.5, 38)
      ..quadraticBezierTo(size.width * 0.75, 58, size.width, 38)
      ..lineTo(size.width, 60) ..lineTo(0, 60) ..close();
    canvas.drawPath(rPath, r);
  }
  @override bool shouldRepaint(_) => false;
}

class _MapWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Very faint map silhouette outline (simple Mauritania rough shape)
    final p = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.05)
      ..lineTo(size.width * 0.75, size.height * 0.07)
      ..lineTo(size.width * 0.82, size.height * 0.18)
      ..lineTo(size.width * 0.8, size.height * 0.55)
      ..lineTo(size.width * 0.72, size.height * 0.65)
      ..lineTo(size.width * 0.5, size.height * 0.68)
      ..lineTo(size.width * 0.2, size.height * 0.62)
      ..lineTo(size.width * 0.15, size.height * 0.45)
      ..lineTo(size.width * 0.22, size.height * 0.2)
      ..close();
    canvas.drawPath(path, p);
  }
  @override bool shouldRepaint(_) => false;
}
