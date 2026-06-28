
import 'package:flutter/material.dart';
import 'package:mobile_flutter/core/theme/app_theme.dart';
import 'package:mobile_flutter/screens/auth/login_screen.dart';
import 'package:mobile_flutter/screens/home/home_screen.dart';

import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nomCtrl   = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl   = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confCtrl  = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConf = true;
  bool _acceptCGU   = false;

  @override
  void dispose() {
    for (final c in [_nomCtrl, _emailCtrl, _telCtrl, _passCtrl, _confCtrl]) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.cardWhite,
      body: Column(
        children: [
          // ── Mini hero header
          _RegisterHeroHeader(onBack: () => Navigator.pop(context)),

          // ── Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Créer un compte', style: AppTextStyles.heading2),
                  const SizedBox(height: 6),
                  Text('Rejoignez SAWTI pour contribuer à un meilleur avenir.',
                      style: AppTextStyles.body),
                  const SizedBox(height: 24),

                  // Nom complet
                  _Field(controller: _nomCtrl, hint: 'Nom complet',
                      icon: Icons.person_outline),
                  const SizedBox(height: 14),

                  // Email
                  _Field(controller: _emailCtrl, hint: 'Email',
                      icon: Icons.email_outlined,
                      type: TextInputType.emailAddress),
                  const SizedBox(height: 14),

                  // Téléphone
                  _Field(controller: _telCtrl, hint: 'Téléphone',
                      icon: Icons.phone_outlined,
                      type: TextInputType.phone),
                  const SizedBox(height: 14),

                  // Mot de passe
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscurePass,
                    decoration: InputDecoration(
                      hintText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () => setState(() => _obscurePass = !_obscurePass),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Confirmer mot de passe
                  TextFormField(
                    controller: _confCtrl,
                    obscureText: _obscureConf,
                    decoration: InputDecoration(
                      hintText: 'Confirmer le mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConf
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () => setState(() => _obscureConf = !_obscureConf),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CGU checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24, height: 24,
                        child: Checkbox(
                          value: _acceptCGU,
                          activeColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (v) => setState(() => _acceptCGU = v ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                            children: [
                              TextSpan(text: "J'accepte les "),
                              TextSpan(text: "Conditions d'utilisation",
                                  style: TextStyle(color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline)),
                              TextSpan(text: " et la "),
                              TextSpan(text: "Politique de confidentialité",
                                  style: TextStyle(color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // S'inscrire button
                  ElevatedButton(
                    onPressed: !_acceptCGU || authProvider.isLoading
                        ? null
                        : () async {

                      if (_nomCtrl.text.trim().isEmpty ||
                          _emailCtrl.text.trim().isEmpty ||
                          _telCtrl.text.trim().isEmpty ||
                          _passCtrl.text.isEmpty ||
                          _confCtrl.text.isEmpty) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Veuillez remplir tous les champs.",
                            ),
                          ),
                        );

                        return;
                      }

                      if (_passCtrl.text != _confCtrl.text) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Les mots de passe ne correspondent pas.",
                            ),
                          ),
                        );

                        return;
                      }

                      final names = _nomCtrl.text.trim().split(' ');

                      final firstName = names.first;

                      final lastName =
                      names.length > 1
                          ? names.sublist(1).join(' ')
                          : '';

                      try {

                        await context
                            .read<AuthProvider>()
                            .register(

                          firstName: firstName,

                          lastName: lastName,

                          email: _emailCtrl.text.trim(),

                          phone: _telCtrl.text.trim(),

                          password: _passCtrl.text,

                        );

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Compte créé avec succès.",
                            ),
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const LoginScreen(),
                          ),
                        );

                      } catch (e) {

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString(),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor:
                      AppColors.primaryGreen.withOpacity(0.4),
                    ),
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
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: const [
                        Text("S'inscrire"),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // OU divider
                  _OrDivider(),
                  const SizedBox(height: 16),

                  // Google
                  _GoogleButton(label: "S'inscrire avec Google"),

                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.body,
                        children: [
                          const TextSpan(text: "Vous avez déjà un compte ? "),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen())),
                              child: const Text('Se connecter',
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  )),
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
          ),
        ],
      ),
    );
  }
}

class _RegisterHeroHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _RegisterHeroHeader({required this.onBack});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 160,
    child: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0xFFF5F0E0), Color(0xFFE8E0CC)],
            ),
          ),
        ),
        Positioned.fill(child: CustomPaint(painter: _CitySilhouetteSmallPainter())),
        // Mauritanian sun
        Positioned(top: 20, right: 60,
          child: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentGold.withOpacity(0.3),
            ),
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentGold,
              ),
            ),
          ),
        ),
        // Flag
        Positioned(top: 36, right: 24, child: _MiniFlag()),
        // Back button
        Positioned(
          top: 44, left: 12,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
            onPressed: onBack,
          ),
        ),
        // Bottom wave
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 28, width: double.infinity,
            child: CustomPaint(painter: _SmallWavePainter()),
          ),
        ),
      ],
    ),
  );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType type;
  const _Field({required this.controller, required this.hint,
    required this.icon, this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: type,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
    ),
  );
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(children: [
    const Expanded(child: Divider()),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text('OU', style: AppTextStyles.label),
    ),
    const Expanded(child: Divider()),
  ]);
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
        Text(label, style: const TextStyle(fontSize: 15, color: AppColors.textDark,
            fontWeight: FontWeight.w500)),
      ],
    ),
  );
}

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 22, height: 22,
    child: CustomPaint(painter: _GoogleLogoPainter()),
  );
}
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -1.1, 1.8, true, paint);
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -1.9, -1.4, true, paint);
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), 2.2, 1.0, true, paint);
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), 0.6, 1.6, true, paint);
    paint.color = Colors.white;
    canvas.drawCircle(c, r * 0.6, paint);
    paint.color = const Color(0xFF4285F4);
    canvas.drawRect(Rect.fromLTWH(c.dx, c.dy - r * 0.12, r * 0.9, r * 0.24), paint);
  }
  @override bool shouldRepaint(_) => false;
}

class _MiniFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 36, height: 24,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(2),
      boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 4)],
    ),
    child: Column(children: [
      Expanded(flex: 1, child: Container(color: AppColors.flagRed)),
      Expanded(flex: 2, child: Container(
        color: AppColors.primaryGreen,
        child: const Center(child: Text('☽⭐', style: TextStyle(fontSize: 8))),
      )),
      Expanded(flex: 1, child: Container(color: AppColors.flagRed)),
    ]),
  );
}

class _CitySilhouetteSmallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreen.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.6)
      ..lineTo(size.width * 0.1, size.height * 0.6)
      ..lineTo(size.width * 0.1, size.height * 0.4)
      ..lineTo(size.width * 0.15, size.height * 0.4)
      ..lineTo(size.width * 0.15, size.height * 0.55)
      ..lineTo(size.width * 0.25, size.height * 0.55)
      ..lineTo(size.width * 0.25, size.height * 0.3)
      ..lineTo(size.width * 0.28, size.height * 0.25)
      ..lineTo(size.width * 0.31, size.height * 0.3)
      ..lineTo(size.width * 0.31, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.35)
      ..lineTo(size.width * 0.55, size.height * 0.28)
      ..lineTo(size.width * 0.6, size.height * 0.35)
      ..lineTo(size.width * 0.6, size.height * 0.5)
      ..lineTo(size.width * 0.75, size.height * 0.5)
      ..lineTo(size.width * 0.75, size.height * 0.4)
      ..lineTo(size.width * 0.82, size.height * 0.4)
      ..lineTo(size.width * 0.82, size.height * 0.55)
      ..lineTo(size.width, size.height * 0.55)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(_) => false;
}

class _SmallWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final g = Paint()..color = AppColors.primaryGreen;
    final gPath = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.75, size.height, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height) ..lineTo(0, size.height) ..close();
    canvas.drawPath(gPath, g);
    final r = Paint()..color = AppColors.flagRed;
    final rPath = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.75, size.height * 1.3, size.width, size.height * 0.8)
      ..lineTo(size.width, size.height) ..lineTo(0, size.height) ..close();
    canvas.drawPath(rPath, r);
  }
  @override bool shouldRepaint(_) => false;
}
