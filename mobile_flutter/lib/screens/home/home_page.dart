import 'package:flutter/material.dart';
import '../claims/my_claims_page.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_page.dart';
import 'dashboard_page.dart';
// تأكد من استيراد صفحة إنشاء الشكوى هنا
import '../claims/create_claim_page.dart';
import '../../core/localization/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const DashboardPage(),
    const MyClaimsPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    final l = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l.text("home"),
          ),
          NavigationDestination(
            icon: const Icon(Icons.assignment_outlined),
            selectedIcon: const Icon(Icons.assignment),
            label: l.text("claims"),
          ),
          NavigationDestination(
            icon: const Icon(Icons.notifications_outlined),
            selectedIcon: const Icon(Icons.notifications),
            label: l.text("notifications"),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l.text("profile"),
          ),
        ],
      ),

      // تفعيل وتوسيط الزر فقط عندما نكون في صفحة الشكاوى (index == 1)
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
        onPressed: () {
          print("FAB from HomePage Clicked!");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateClaimPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,

      // لإعطاء مظهر متناسق مدمج مع شريط التنقل السفلي (اختياري)
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}