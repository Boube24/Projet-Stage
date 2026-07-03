import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../home/home_page.dart';
import '../../core/localization/app_localizations.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  // Additional staggered animations for the premium UI redesign.
  // These are purely visual and do not affect app logic or navigation.
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoFadeAnimation;
  late final Animation<Offset> _logoSlideAnimation;
  late final Animation<double> _titleFadeAnimation;
  late final Animation<Offset> _titleSlideAnimation;
  late final Animation<double> _sloganFadeAnimation;
  late final Animation<Offset> _sloganSlideAnimation;
  late final Animation<double> _bottomFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Logo: gentle scale + fade + slight upward settle, starts immediately.
    _logoScaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _logoSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    // App title: fades in shortly after the logo begins appearing.
    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.70, curve: Curves.easeOut),
      ),
    );
    _titleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.30, 0.70, curve: Curves.easeOutCubic),
          ),
        );

    // Slogan: appears last among the top elements.
    _sloganFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.90, curve: Curves.easeOut),
      ),
    );
    _sloganSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.50, 0.90, curve: Curves.easeOutCubic),
          ),
        );

    // Bottom emblem section fades in last.
    _bottomFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    _initialize();
  }

  Future<void> _initialize() async {

    await Future.delayed(
      const Duration(seconds: 2),
    );

    final auth =
    context.read<AuthProvider>();

    await auth.checkAuthStatus();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
        auth.isAuthenticated
            ? const HomePage()
            : const LoginPage(),
      ),
    );
  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    // Mauritanian-inspired premium dark green palette.
    const Color deepGreen = Color(0xFF0B3D24);
    const Color midGreen = Color(0xFF0E4A2B);
    const Color gold = Color(0xFFD4A72C);

    return Scaffold(
      backgroundColor: deepGreen,
      body: Stack(
        children: [
          // Base premium gradient background.
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2),
                  radius: 1.2,
                  colors: [midGreen, deepGreen],
                ),
              ),
            ),
          ),

          // Subtle Islamic geometric pattern overlay.
          Positioned.fill(
            child: Opacity(
              opacity: 0.06,
              child: CustomPaint(
                painter: _IslamicPatternPainter(color: gold),
                size: size,
              ),
            ),
          ),

          // Decorative corner motifs, echoing the reference design.
          Positioned(
            top: 0,
            left: 0,
            child: Opacity(
              opacity: 0.16,
              child: CustomPaint(
                painter: _CornerMotifPainter(color: gold),
                size: const Size(120, 120),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Transform.flip(
              flipX: true,
              child: Opacity(
                opacity: 0.16,
                child: CustomPaint(
                  painter: _CornerMotifPainter(color: gold),
                  size: const Size(120, 120),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Transform.flip(
              flipY: true,
              child: Opacity(
                opacity: 0.16,
                child: CustomPaint(
                  painter: _CornerMotifPainter(color: gold),
                  size: const Size(120, 120),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Transform.flip(
              flipX: true,
              flipY: true,
              child: Opacity(
                opacity: 0.16,
                child: CustomPaint(
                  painter: _CornerMotifPainter(color: gold),
                  size: const Size(120, 120),
                ),
              ),
            ),
          ),

          // Foreground content.
          SafeArea(
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // Logo
                  SlideTransition(
                    position: _logoSlideAnimation,
                    child: FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 130,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // App name
                  SlideTransition(
                    position: _titleSlideAnimation,
                    child: FadeTransition(
                      opacity: _titleFadeAnimation,
                      child: Text(
                        l.text("appName"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Slogan: Signalé. Suivez. Améliorez.
                  SlideTransition(
                    position: _sloganSlideAnimation,
                    child: FadeTransition(
                      opacity: _sloganFadeAnimation,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: "Signalé. ",
                              style: TextStyle(color: Color(0xFFE04B3F)),
                            ),
                            TextSpan(
                              text: "Suivez. ",
                              style: TextStyle(color: Color(0xFF3FAE5C)),
                            ),
                            TextSpan(
                              text: "Améliorez.",
                              style: TextStyle(color: Color(0xFFD4A72C)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 4),

                  const CircularProgressIndicator(
                    color: gold,
                    strokeWidth: 2.4,
                  ),

                  const SizedBox(height: 32),

                  // Bottom section: official emblem + republic name.
                  FadeTransition(
                    opacity: _bottomFadeAnimation,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 1,
                              color: gold.withOpacity(0.5),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              child: Image.asset(
                                "assets/images/emblem.png",
                                width: 40,
                                height: 40,
                              ),
                            ),
                            Container(
                              width: 70,
                              height: 1,
                              color: gold.withOpacity(0.5),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "République Islamique de Mauritanie",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Plateforme citoyenne",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: gold.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints a very subtle repeating Islamic-inspired geometric pattern
/// (interlocking eight-point stars) used as a low-opacity background texture.
class _IslamicPatternPainter extends CustomPainter {
  final Color color;

  _IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double spacing = 60;

    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        _drawStar(canvas, paint, Offset(x, y), spacing * 0.42);
      }
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    const int points = 8;
    for (int i = 0; i < points; i++) {
      final double angleOuter = (i * 2 * math.pi) / points;
      final double angleInner = angleOuter + (math.pi / points);
      final Offset outer = Offset(
        center.dx + radius * math.cos(angleOuter),
        center.dy + radius * math.sin(angleOuter),
      );
      final Offset inner = Offset(
        center.dx + (radius * 0.5) * math.cos(angleInner),
        center.dy + (radius * 0.5) * math.sin(angleInner),
      );
      if (i == 0) {
        path.moveTo(outer.dx, outer.dy);
      } else {
        path.lineTo(outer.dx, outer.dy);
      }
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _IslamicPatternPainter oldDelegate) => false;
}

/// Paints an elegant decorative corner flourish (arabesque-style corner motif)
/// echoing the reference design's ornamental corners.
class _CornerMotifPainter extends CustomPainter {
  final Color color;

  _CornerMotifPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    path.moveTo(0, size.height * 0.55);
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.15,
      size.width * 0.55,
      0,
    );
    canvas.drawPath(path, paint);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.75);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.3,
      size.width * 0.75,
      0,
    );
    canvas.drawPath(path2, paint);

    canvas.drawCircle(
      Offset(size.width * 0.12, size.height * 0.12),
      3,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerMotifPainter oldDelegate) => false;
}