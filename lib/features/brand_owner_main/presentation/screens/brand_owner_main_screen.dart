import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../branch_manager_settings/presentation/screens/branch_manager_settings.dart';
import '../../../brand_owner_home/presentation/cubit/brand_owner_home/brand_owner_home_cubit.dart';
import '../../../brand_owner_home/presentation/screens/brand_owner_home_screen.dart';
import '../../../brand_owner_reports_and_analytics/presentation/screens/brand_owner_reports_and_analytics_screen.dart';
import '../../../brand_owner_reports_and_analytics/presentation/cubit/brand_owner_reports_and_analytics_cubit.dart';
import '../../../brand_owner_requests/presentation/screens/brand_owner_requests_screen.dart';
import '../../../brand_owner_tools/presentation/screens/brand_owner_tools_screen.dart';
import '../widgets/brand_owner_bottom_nav_bar.dart';
import '../../../../core/di/dependency_injection.dart';

class BrandOwnerMainScreen extends StatelessWidget {
  const BrandOwnerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.watch<PagingCubit>().state.currentIndex,
        children: [
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    getIt<BrandOwnerHomeCubit>()..loadDashboard(),
              ),
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {'branchId', 'month', 'year'},
                ),
              ),
            ],
            child: const BrandOwnerHomeScreen(),
          ),
          const BrandOwnerToolsScreen(),
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
              BlocProvider(
                create: (context) => ValidationCubit(requiredFields: {}),
              ),
            ],
            child: const BrandOwnerRequestsScreen(),
          ),
          BlocProvider(
            create: (context) =>
                getIt<BrandOwnerReportsAndAnalyticsCubit>()
                  ..loadReportsAndAnalytics(),
            child: const BrandOwnerReportsAndAnalyticsScreen(),
          ),
          BranchManagerSettings(userType: BrandOwnerUserStrategy()),
        ],
      ),
      bottomNavigationBar: const BrandOwnerBottomNavBar(),
    );
  }
}
