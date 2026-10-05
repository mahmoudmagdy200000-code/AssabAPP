import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/data_management/date_management/date_management_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../../core/widgets/app_logout_button.dart';
import '../../../branch_manager_expenses/presentation/cubit/branch_manager_expenses/branch_manager_expenses_cubit.dart';
import '../../../branch_manager_expenses/presentation/screens/branch_manager_expenses_screen.dart';
import '../../../branch_manager_requests/presentation/cubit/get_handovers/get_handovers_cubit.dart';
import '../../../branch_manager_requests/presentation/cubit/get_variances/get_variances_cubit.dart';
import '../../../branch_manager_settings/presentation/screens/branch_manager_settings.dart';
import '../../../cashier_home/presentation/screens/cashier_home_screen.dart';
import '../../../cashier_my_shifts/presentation/screens/cashier_my_shifts_screen.dart';
import '../../../cashier_requests/presentation/cubits/get_reassignments/get_reassignments_cubit.dart';
import '../../../cashier_requests/presentation/screens/cashier_requests.dart';
import '../widgets/cashier_bottom_nav_bar.dart';

class CashierMainScreen extends StatelessWidget {
  const CashierMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.watch<PagingCubit>().state.currentIndex,
        children: [
          const CashierHomeScreen(),
          BlocProvider(
            create: (context) => PagingCubit(totalSteps: 2),
            child: const CashierMyShiftsScreen(),
          ),
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
              BlocProvider(create: (context) => getIt<GetVariancesCubit>()),
              BlocProvider(create: (context) => getIt<GetHandoversCubit>()),
              BlocProvider(
                create: (context) => getIt<GetReassignedShiftsCubit>(),
              ),
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {
                    'count_variance',
                    'count_handover',
                    'count_reassignments',
                  },
                ),
              ),
            ],
            child: const CashierRequests(),
          ),
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<DateManagementCubit>()),
              BlocProvider(
                create: (context) => getIt<BranchManagerExpensesCubit>(),
              ),
            ],
            child: const BranchManagerExpensesScreen(),
          ),
          BranchManagerSettings(userType: CashierUserStrategy()),
        ],
      ),
      bottomNavigationBar: const CashierBottomNavBar(),
    );
  }
}
