import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/dashboard_provider.dart';

import '../../widgets/app_loading.dart';
import '../../widgets/app_error.dart';
import '../../widgets/app_empty.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';

import '../../widgets/business/stat_card.dart';
import '../../widgets/business/claim_card.dart';

import '../../widgets/app_app_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends State<DashboardPage> {

  @override
  void initState() {

    super.initState();

    Future.microtask(() {

      context
          .read<DashboardProvider>()
          .loadDashboard();

    });

  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final provider =
    context.watch<DashboardProvider>();

    if (provider.isLoading) {
      return const AppLoading();
    }

    if (provider.error != null) {

      return AppError(

        message: provider.error!,

        onRetry: () {

          provider.loadDashboard();

        },

      );

    }

    final dashboard =
        provider.dashboard;

    if (dashboard == null) {
      return AppEmpty(
        message: l.text("no_data"),
      );
    }

    return Scaffold(

      appBar: AppAppBar(
        title: l.text("home"),
        automaticallyImplyLeading: false,
      ),

      body: RefreshIndicator(

        onRefresh:
        provider.loadDashboard,

        child: ListView(

          padding:
          const EdgeInsets.all(16),

          children: [

            const SizedBox(height: 10),

            Text(


              l.text("hello"),


              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,

            ),

            const SizedBox(height: 6),

            Text(

              l.text("welcome_message"),


              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,

            ),

            const SizedBox(height: 30),

            Text(

              l.text("your_statistics"),

              style: TextStyle(

                fontSize: 18,

                fontWeight:
                FontWeight.bold,

              ),

            ),

            const SizedBox(height: 16),

            Row(

              children: [

                StatCard(

                  title: l.text("claims"),

                  value: dashboard
                      .totalClaims
                      .toString(),

                  icon:
                  Icons.assignment,

                  color: AppColors.primary,

                ),

                StatCard(

                  title: l.text("in_progress"),

                  value: dashboard
                      .inProgressClaims
                      .toString(),

                  icon:
                  Icons.pending,

                  color:
                  AppColors.warning,

                ),

              ],

            ),

            Row(

              children: [

                StatCard(

                  title: l.text("resolved"),

                  value: dashboard
                      .resolvedClaims
                      .toString(),

                  icon:
                  Icons.check_circle,

                  color:
                  AppColors.success,

                ),

                StatCard(

                  title: l.text("notifications"),

                  value: dashboard
                      .unreadNotifications
                      .toString(),

                  icon:
                  Icons.notifications,

                  color:
                  AppColors.error,

                ),

              ],

            ),

            const SizedBox(height: 30),

            Text(

              l.text("recent_claims"),

              style: TextStyle(

                fontSize: 18,

                fontWeight:
                FontWeight.bold,

              ),

            ),

            const SizedBox(height: 16),

            if (dashboard
                .recentClaims
                .isEmpty)

              AppEmpty(
                message: l.text("no_claims"),
              )

            else

              ...dashboard
                  .recentClaims
                  .map(

                    (claim) => ClaimCard(

                  claim: claim,

                  onTap: () {

                    // ClaimDetailsPage

                  },

                ),

              ),

          ],

        ),

      ),

    );

  }

}