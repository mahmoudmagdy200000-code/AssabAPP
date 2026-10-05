import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../branch_manager_settings/presentation/screens/branch_manager_settings.dart';
import '../../../supplier_requests/presentation/cubit/supplier_get_requests/supplier_get_requests_cubit.dart';
import '../../../supplier_requests/presentation/screens/supplier_request_screen.dart';
import '../../../supplier_returns/presentation/cubit/supplier_get_returns/supplier_get_returns_cubit.dart';
import '../../../supplier_returns/presentation/screens/supplier_returns_screen.dart';
import '../../../supplier_settings/presentation/screens/supplier_settings.dart';
import '../widgets/supplier_bottom_nav_bar.dart';

class SupplierMainScreen extends StatelessWidget {
  const SupplierMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.watch<PagingCubit>().state.currentIndex,
        children: [
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
              BlocProvider(
                create: (context) => getIt<SupplierGetRequestsCubit>(),
              ),
            ],
            child: const SupplierRequestScreen(),
          ),
          BlocProvider(
            create: (context) => getIt<SupplierGetReturnsCubit>(),
            child: const SupplierReturnsScreen(),
          ),
          BranchManagerSettings(userType: SupplierUserStrategy()),
        ],
      ),
      bottomNavigationBar: const SupplierBottomNavBar(),
    );
  }
}
