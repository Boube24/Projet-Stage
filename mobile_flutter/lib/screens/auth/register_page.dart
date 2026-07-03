import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dialog.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/app_text_field.dart';

const Color _kPrimaryGreen = Color(0xFF0B6B3A);
const Color _kDarkGreen = Color(0xFF064A28);
const Color _kGold = Color(0xFFD4AF37);
const Color _kErrorRed = Color(0xFFD62828);
const Color _kBackground = Color(0xFFFDFBF7);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final l = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    try {
      await auth.register(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      await AppDialog.success(
        context: context,
        title: l.text('reussi'),
        message: l.text('succes'),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      AppDialog.error(
        context: context,
        title: l.text('errer'),
        message: auth.error ?? l.text('message_errer'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: _kBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _GeometricPatternPainter(),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _CircleBackButton(
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(height: 20), // زيادة المساحة لتنفس المحتوى العلوي

                        // كتلة الاسم والشعار النصي لـ Sawti
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                'Sawti',
                                style: TextStyle(
                                  fontSize: 34, // خط بارز يعوض غياب الهوية الصورية
                                  fontWeight: FontWeight.w900,
                                  color: _kPrimaryGreen,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Votre voix, votre engagement',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: _kGold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // الحاوية الكبيرة (Card Container) بانحناء ممتاز ومتناسق
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFEDEDED),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _kDarkGreen.withOpacity(0.05),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l.text('new_compte'),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headline.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _kDarkGreen,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l.text('rejoin'),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.subtitle.copyWith(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 28),

                              // الحقول المحسنة بالكامل مع زوايا الانحناء الموحدة
                              _FieldShell(
                                child: AppTextField(
                                  controller: _firstNameController,
                                  label: l.text('prenom'),
                                  prefixIcon: Icons.person,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return l.text('obligatoire');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _FieldShell(
                                child: AppTextField(
                                  controller: _lastNameController,
                                  label: l.text('nom'),
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return l.text('obligatoire');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _FieldShell(
                                child: AppTextField(
                                  controller: _emailController,
                                  label: l.text('email_ob'),
                                  prefixIcon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return l.text('email_invalide');
                                    }
                                    if (!value.contains("@")) {
                                      return l.text('email_invalide');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _FieldShell(
                                child: AppTextField(
                                  controller: _phoneController,
                                  label: l.text('telephone'),
                                  prefixIcon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return l.text('obligatoire');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _FieldShell(
                                child: AppTextField(
                                  controller: _passwordController,
                                  label: l.text('password'),
                                  prefixIcon: Icons.lock,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.length < 6) {
                                      return l.text('password_min');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _FieldShell(
                                child: AppTextField(
                                  controller: _confirmPasswordController,
                                  label: l.text('confirm_password'),
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value != _passwordController.text) {
                                      return l.text('password_not_same');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),

                              // شروط الاستخدام
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: Checkbox(
                                      value: _acceptTerms,
                                      activeColor: _kPrimaryGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          _acceptTerms = val ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            color: Colors.grey.shade700,
                                            height: 1.4,
                                          ),
                                          children: [
                                            const TextSpan(text: "J'accepte les "),
                                            TextSpan(
                                              text: "Conditions d'utilisation",
                                              style: const TextStyle(
                                                color: _kPrimaryGreen,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const TextSpan(text: " et la "),
                                            TextSpan(
                                              text: "Politique de confidentialité",
                                              style: const TextStyle(
                                                color: _kPrimaryGreen,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 28),

                              // زر إنشاء الحساب المحسن بانحنائه المتناسق ($16$)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _kDarkGreen.withOpacity(0.22),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: AppButton(
                                  text: l.text('new_compte'),
                                  isLoading: auth.isLoading,
                                  onPressed: _register,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // تذييل الصفحة للعودة لتسجيل الدخول
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "Vous avez déjà un compte ?",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  l.text('already_register'),
                                  style: const TextStyle(
                                    color: _kPrimaryGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldShell extends StatelessWidget {
  final Widget child;
  const _FieldShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // جعل زاوية الانحناء متناسقة ومريحة بصرياً
        border: Border.all(
          color: const Color(0xFFE5E5E5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CircleBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE5E5E5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back,
            color: _kDarkGreen,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _kPrimaryGreen.withOpacity(0.025) // جعل النقش خفيفاً وهادئاً جداً بالخلفية
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    const spacing = 64.0;
    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        _drawStar(canvas, Offset(x, y), 22, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 8;
    for (int i = 0; i <= points * 2; i++) {
      final angle = (math.pi / points) * i;
      final r = i.isEven ? radius : radius * 0.55;
      final dx = center.dx + r * math.cos(angle);
      final dy = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}