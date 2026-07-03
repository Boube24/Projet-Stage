// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../providers/auth_provider.dart';
// import '../../core/localization/app_localizations.dart';
// // قم باستيراد ملف شاشة تسجيل الدخول الخاص بك (تأكد من صحة هذا المسار)
// import '../auth/login_screen.dart';
//
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final l = AppLocalizations.of(context);
//
//     return Consumer<AuthProvider>(
//       builder: (_, auth, __) {
//         final user = auth.user;
//
//         // إذا أصبح المستخدم null (تم مسحه بالخلفية)
//         if (user == null) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             // 🛠️ التوجيه المباشر والآمن هنا دون الاعتماد على الأسماء
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(builder: (context) => const LoginPage()), // اسم كلاس صفحة الدخول لديك
//                   (Route<dynamic> route) => false,
//             );
//           });
//
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//
//         return Scaffold(
//           appBar: AppBar(
//             title: Text(
//               l.text("my_profile"),
//             ),
//           ),
//           body: ListView(
//             padding: const EdgeInsets.all(20),
//             children: [
//               const SizedBox(height: 20),
//               CircleAvatar(
//                 radius: 50,
//                 child: Text(
//                   user.firstName.substring(0, 1).toUpperCase(),
//                   style: const TextStyle(fontSize: 40),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: Text(
//                   "${user.firstName} ${user.lastName}",
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Center(
//                 child: Text(user.email),
//               ),
//               const SizedBox(height: 30),
//               Card(
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: const Icon(Icons.person),
//                       title: Text(l.text("prenom")),
//                       subtitle: Text(user.firstName),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.badge),
//                       title: Text(l.text("nom")),
//                       subtitle: Text(user.lastName),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.email),
//                       title: Text(l.text("email")),
//                       subtitle: Text(user.email),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.phone),
//                       title: Text(l.text("telephone")),
//                       subtitle: Text(user.phone),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.security),
//                       title: Text(l.text("role")),
//                       subtitle: Text(user.role),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 height: 55,
//                 child: ElevatedButton.icon(
//                   onPressed: () async {
//                     // مسح البيانات وتغيير الحالة لـ null
//                     await auth.logout();
//                   },
//                   icon: const Icon(Icons.logout),
//                   label: Text(l.text("logout")),
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../core/localization/app_localizations.dart';
// قم باستيراد ملف شاشة تسجيل الدخول الخاص بك (تأكد من صحة هذا المسار)
import '../auth/login_screen.dart';

// ==========================================================
// DESIGN TOKENS — Sawti design system
// ==========================================================
class _SawtiColors {
  static const green = Color(0xFF0B6B3A);
  static const greenLight = Color(0xFFE7F2EC);
  static const gold = Color(0xFFD8A93A);
  static const textDark = Color(0xFF1C1C1C);
  static const textGrey = Color(0xFF7A7A7A);
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        final user = auth.user;

        // إذا أصبح المستخدم null (تم مسحه بالخلفية)
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // 🛠️ التوجيه المباشر والآمن هنا دون الاعتماد على الأسماء
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()), // اسم كلاس صفحة الدخول لديك
                  (Route<dynamic> route) => false,
            );
          });

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF6F7F6),
          extendBodyBehindAppBar: true,
          body: SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                // Header + floating avatar section (overlapping via Stack)
                Padding(
                  padding: const EdgeInsets.only(bottom: 66),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      const _ProfileHeader(),
                      Positioned(
                        bottom: -66,
                        child: _ProfileAvatarSection(user: user),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    children: [
                      _ProfileMenuCard(user: user, l: l),
                      const SizedBox(height: 28),
                      _LogoutButton(
                        label: l.text("logout"),
                        onPressed: () async {
                          // مسح البيانات وتغيير الحالة لـ null
                          await auth.logout();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==========================================================
// HEADER — dark green, curved bottom, decorative pattern, logo
// ==========================================================
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            bottom: 28,
          ),
          decoration: const BoxDecoration(
            color: _SawtiColors.green,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative Islamic pattern, very low opacity.
              // Falls back to nothing if the asset isn't present in the project.
              Positioned.fill(
                child: Opacity(
                  opacity: 0.06,
                  child: Image.asset(
                    'assets/images/islamic_pattern.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 64,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.shield_moon,
                      color: Colors.white,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sawti',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Votre voix, notre engagement',
                    style: TextStyle(
                      color: _SawtiColors.gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// PROFILE AVATAR SECTION — avatar, camera badge, name, email, edit button
// ==========================================================
class _ProfileAvatarSection extends StatelessWidget {
  final dynamic user;

  const _ProfileAvatarSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: _SawtiColors.greenLight,
                child: Text(
                  user.firstName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    color: _SawtiColors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                // TODO: wire this up to your existing avatar-upload logic
                // (kept as a no-op here since no upload logic was provided).
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _SawtiColors.gold,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          "${user.firstName} ${user.lastName}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _SawtiColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.email_outlined, size: 15, color: _SawtiColors.textGrey),
            const SizedBox(width: 6),
            Text(
              user.email,
              style: const TextStyle(fontSize: 14, color: _SawtiColors.textGrey),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 42,
          child: ElevatedButton.icon(
            // TODO: wire this up to your existing "edit profile" navigation/logic
            onPressed: () {},
            icon: const Icon(Icons.edit, size: 16, color: Colors.white),
            label: const Text('Modifier le profil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _SawtiColors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// MENU CARD — rounded white card with menu rows
// ==========================================================
class _ProfileMenuCard extends StatelessWidget {
  final dynamic user;
  final AppLocalizations l;

  const _ProfileMenuCard({required this.user, required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _MenuTile(
            icon: Icons.person_outline,
            title: 'Informations personnelles',
            onTap: () => _showPersonalInfoSheet(context, user, l),
          ),
          const _MenuDivider(),
          _MenuTile(
            icon: Icons.lock_outline,
            title: 'Changer le mot de passe',
            // TODO: wire this up to your existing change-password flow
            onTap: () {},
          ),
          const _MenuDivider(),
          _MenuTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            // TODO: wire this up to your existing notifications settings screen
            onTap: () {},
          ),
          const _MenuDivider(),
          _MenuTile(
            icon: Icons.language,
            title: 'Langue',
            // TODO: replace with the app's actual current locale/label
            trailingText: 'Français',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  /// Preserves the original behaviour of displaying prenom / nom / email /
  /// telephone / role — just relocated into a details sheet instead of
  /// always-visible list tiles, to match the new design.
  void _showPersonalInfoSheet(
      BuildContext context,
      dynamic user,
      AppLocalizations l,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: _SawtiColors.green),
                  title: Text(l.text("prenom")),
                  subtitle: Text(user.firstName),
                ),
                ListTile(
                  leading: const Icon(Icons.badge, color: _SawtiColors.green),
                  title: Text(l.text("nom")),
                  subtitle: Text(user.lastName),
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: _SawtiColors.green),
                  title: Text(l.text("email")),
                  subtitle: Text(user.email),
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: _SawtiColors.green),
                  title: Text(l.text("telephone")),
                  subtitle: Text(user.phone),
                ),
                ListTile(
                  leading: const Icon(Icons.security, color: _SawtiColors.green),
                  title: Text(l.text("role")),
                  subtitle: Text(user.role),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 68,
      endIndent: 20,
      color: Colors.grey.shade200,
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: _SawtiColors.greenLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: _SawtiColors.green, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _SawtiColors.textDark,
                  ),
                ),
              ),
              if (trailingText != null) ...[
                Text(
                  trailingText!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _SawtiColors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              const Icon(Icons.chevron_right, color: _SawtiColors.textGrey, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// LOGOUT BUTTON — outlined red, rounded
// ==========================================================
class _LogoutButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _LogoutButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.logout, color: Colors.red),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}