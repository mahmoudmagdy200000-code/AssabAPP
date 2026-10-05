import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../presentation/cubit/get_monthly_completed_products/get_monthly_completed_products_cubit.dart';
import '../../presentation/cubit/get_monthly_completed_products/get_monthly_completed_products_state.dart';
import '../../presentation/cubit/get_monthly_details/get_monthly_details_cubit.dart';
import '../../presentation/cubit/submit_monthly_inventory/submit_monthly_inventory_cubit.dart';
import '../../presentation/screens/monthly_inventory_summary_screen.dart';

abstract class InventoryUserType {
  void pop();

  Widget buildButtonSection({required String sessionId}) {
    return const SizedBox.shrink();
  }
}

class InventoryUserTypeBranchManager extends InventoryUserType {
  @override
  void pop() {
    NavigationService.I.popUntil(
      (p1) => p1.settings.name == AppRouteName.inventoryScreen,
    );
  }

  @override
  Widget buildButtonSection({required String sessionId}) {
    return BlocSelector<
      GetMonthlyCompletedProductsCubit,
      GetMonthlyCompletedProductsState,
      bool
    >(
      selector: (state) {
        if (state is GetMonthlyCompletedProductsSuccess) {
          return state.response.completed == state.response.total;
        }

        return false;
      },
      builder: (context, state) {
        if (!state) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            20.verticalSpace,
            AppButton(
              onClick: () {
                NavigationService.I.push(
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              getIt<GetMonthlyDetailsCubit>()
                                ..getMonthlyDetails(id: sessionId),
                        ),
                        BlocProvider(
                          create: (context) =>
                              getIt<SubmitMonthlyInventoryCubit>(),
                        ),
                      ],
                      child: MonthlyInventorySummaryScreen(id: sessionId),
                    ),
                  ),
                );
              },
              enabled: true,
              text: context.tr.reviewInventory,
              borderRadius: BorderRadius.circular(18.r),
            ),
          ],
        );
      },
    );
  }
}

class InventoryUserTypeEmployee extends InventoryUserType {
  @override
  void pop() {
    NavigationService.I.popUntil(
      (p1) => p1.settings.name == AppRouteName.cashierNewAssignmentsScreen,
    );
  }
}
