import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/get_handovers/get_handovers_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/manager_shift_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/data_management/date_management/date_management_cubit.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../branch_manager_expenses/presentation/cubit/branch_manager_expenses/branch_manager_expenses_cubit.dart';
import '../../../branch_manager_expenses/presentation/screens/branch_manager_expenses_screen.dart';
import '../../../branch_manager_home/presentation/screens/branch_manager_home.dart';
import '../../../branch_manager_requests/presentation/cubit/get_orders/get_orders_cubit.dart';
import '../../../branch_manager_requests/presentation/cubit/get_variances/get_variances_cubit.dart';
import '../../../branch_manager_requests/presentation/screens/branch_manager_requests.dart';
import '../../../branch_manager_settings/presentation/screens/branch_manager_settings.dart';
import '../widgets/branch_manager_bottom_nav_bar.dart';

class BranchManagerMainScreen extends StatelessWidget {
  const BranchManagerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.watch<PagingCubit>().state.currentIndex,
        children: [
          const BranchManagerHome(),

          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 4)),
              BlocProvider(create: (context) => getIt<ManagerShiftCubit>()),
            ],
            child: const ManagerShiftManagementScreen(),
          ),

          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
              BlocProvider(create: (context) => getIt<GetOrdersCubit>()),
              BlocProvider(create: (context) => getIt<GetVariancesCubit>()),
              BlocProvider(create: (context) => getIt<GetHandoversCubit>()),
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {
                    'count_order',
                    'count_variance',
                    'count_handover',
                  },
                ),
              ),
            ],
            child: const BranchManagerRequests(),
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
          BranchManagerSettings(userType: BranchManagerUserStrategy()),
        ],
      ),
      bottomNavigationBar: const BranchManagerBottomNavBar(),
    );
  }
}
