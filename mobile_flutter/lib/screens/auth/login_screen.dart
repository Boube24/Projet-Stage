import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports المحلية الخاصة بالمشروع
import '../../providers/auth_provider.dart';
import 'package:mobile_flutter/core/theme/app_theme.dart';
import 'package:mobile_flutter/screens/auth/register_screen.dart';
import 'package:mobile_flutter/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.cardWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Top hero illustration panel
            _HeroPanel(height: h * 0.36),

            // ── Form card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Bienvenue !', style: AppTextStyles.heading2),
                  const SizedBox(height: 4),
                  Text('Connectez-vous pour continuer', style: AppTextStyles.body),
                  const SizedBox(height: 24),

                  // Email / Téléphone
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email ou téléphone',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Mot de passe
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),

                  // Mot de passe oublié
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(color: AppColors.flagRed, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Bouton Se connecter
                  ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                      final provider = context.read<AuthProvider>();

                      try {
                        if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Veuillez remplir tous les champs'),
                            ),
                          );
                          return;
                        }

                        await provider.login(
                          email: _emailCtrl.text.trim(),
                          password: _passCtrl.text,
                        );

                        if (!mounted) return;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    child: authProvider.isLoading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Se connecter'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  _OrDivider(),
                  const SizedBox(height: 16),

                  // Google
                  const _GoogleButton(label: 'Continuer avec Google'),

                  const SizedBox(height: 24),

                  // Pas de compte ?
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.body,
                        children: [
                          const TextSpan(text: "Vous n'avez pas de compte ? "),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              ),
                              child: const Text(
                                'Créer un compte',
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero illustration with Mauritania city silhouette + category bubbles
class _HeroPanel extends StatelessWidget {
  final double height;
  const _HeroPanel({required this.height});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: Stack(
      fit: StackFit.expand,
      children: [
        // Gradient sky
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5F0E0), Color(0xFFE8E0CC)],
            ),
          ),
        ),

        // City silhouette
        Positioned.fill(child: CustomPaint(painter: _CitySilhouettePainter())),

        // Mauritanian flag (top right)
        Positioned(
          top: 36,
          right: 24,
          child: _MiniFlag(),
        ),

        // Category bubble – Voirie (top-left)
        Positioned(
          top: 60,
          left: 28,
          child: _CategoryBubble(
            icon: Icons.construction,
            label: 'VOIRIE',
            color: AppColors.voirie,
          ),
        ),

        // Category bubble – Électricité (top-right offset)
        Positioned(
          top: 55,
          right: 80,
          child: _CategoryBubble(
            icon: Icons.bolt,
            label: 'ÉLECTRICITÉ',
            color: AppColors.electricite,
          ),
        ),

        // Category bubble – Eau (bottom-left)
        Positioned(
          bottom: 48,
          left: 20,
          child: _CategoryBubble(
            icon: Icons.water_drop,
            label: 'EAU',
            color: AppColors.eau,
            size: 44,
          ),
        ),

        // Category bubble – Environnement (bottom-right)
        Positioned(
          bottom: 44,
          right: 24,
          child: _CategoryBubble(
            icon: Icons.eco,
            label: 'ENVIRONNEMENT',
            color: AppColors.environnement,
            size: 44,
          ),
        ),

        // Central phone mockup circle
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 4,
                )
              ],
            ),
            child: const Icon(Icons.people, color: Colors.white, size: 40),
          ),
        ),

        // Bottom flag wave
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 32,
            width: double.infinity,
            child: CustomPaint(painter: _SmallWavePainter()),
          ),
        ),
      ],
    ),
  );
}

class _CategoryBubble extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double size;

  const _CategoryBubble({
    required this.icon,
    required this.label,
    required this.color,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.48),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
    ],
  );
}

class _MiniFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 24,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(2),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
    ),
    child: Column(
      children: [
        Expanded(flex: 1, child: Container(color: AppColors.flagRed)),
        Expanded(
          flex: 2,
          child: Container(
            color: AppColors.primaryGreen,
            child: const Center(
              child: Text('☽⭐', style: TextStyle(fontSize: 8)),
            ),
          ),
        ),
        Expanded(flex: 1, child: Container(color: AppColors.flagRed)),
      ],
    ),
  );
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text('OU', style: AppTextStyles.label),
      ),
      const Expanded(child: Divider()),
    ],
  );
}

class _GoogleButton extends StatelessWidget {
  final String label;
  const _GoogleButton({required this.label});

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      side: const BorderSide(color: AppColors.inputBorder, width: 1.5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _GoogleLogo(),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 22,
    height: 22,
    child: CustomPaint(painter: _GoogleLogoPainter()),
  );
}

class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    // Blue
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -1.1, 1.8, true, paint);
    // Red
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -1.9, -1.4, true, paint);
    // Yellow
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), 2.2, 1.0, true, paint);
    // Green
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), 0.6, 1.6, true, paint);
    // White inner circle
    paint.color = Colors.white;
    canvas.drawCircle(c, r * 0.6, paint);
    // "G" bar
    paint.color = const Color(0xFF4285F4);
    canvas.drawRect(Rect.fromLTWH(c.dx, c.dy - r * 0.12, r * 0.9, r * 0.24), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CitySilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreen.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.65)
      ..lineTo(size.width * 0.08, size.height * 0.65)
      ..lineTo(size.width * 0.08, size.height * 0.5)
      ..lineTo(size.width * 0.12, size.height * 0.5)
      ..lineTo(size.width * 0.12, size.height * 0.4)
      ..lineTo(size.width * 0.16, size.height * 0.4)
      ..lineTo(size.width * 0.16, size.height * 0.6)
      ..lineTo(size.width * 0.22, size.height * 0.6)
      ..lineTo(size.width * 0.22, size.height * 0.35)
      ..lineTo(size.width * 0.25, size.height * 0.3)
      ..lineTo(size.width * 0.28, size.height * 0.35)
      ..lineTo(size.width * 0.28, size.height * 0.55)
      ..lineTo(size.width * 0.35, size.height * 0.55)
      ..lineTo(size.width * 0.35, size.height * 0.45)
      ..lineTo(size.width * 0.4, size.height * 0.38)
      ..lineTo(size.width * 0.45, size.height * 0.45)
      ..lineTo(size.width * 0.45, size.height * 0.55)
      ..lineTo(size.width * 0.55, size.height * 0.55)
      ..lineTo(size.width * 0.55, size.height * 0.42)
      ..lineTo(size.width * 0.6, size.height * 0.35)
      ..lineTo(size.width * 0.65, size.height * 0.42)
      ..lineTo(size.width * 0.65, size.height * 0.55)
      ..lineTo(size.width * 0.72, size.height * 0.55)
      ..lineTo(size.width * 0.72, size.height * 0.48)
      ..lineTo(size.width * 0.78, size.height * 0.48)
      ..lineTo(size.width * 0.78, size.height * 0.62)
      ..lineTo(size.width * 0.85, size.height * 0.62)
      ..lineTo(size.width * 0.85, size.height * 0.5)
      ..lineTo(size.width * 0.9, size.height * 0.42)
      ..lineTo(size.width * 0.95, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _SmallWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final g = Paint()..color = AppColors.primaryGreen;
    final gPath = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.75, size.height, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(gPath, g);

    final r = Paint()..color = AppColors.flagRed;
    final rPath = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.75, size.height * 1.3, size.width, size.height * 0.8)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(rPath, r);
  }

  @override
  bool shouldRepaint(_) => false;
}