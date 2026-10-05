import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../branch_manager_expenses/presentation/cubit/branch_manager_expenses_history/branch_manager_expenses_history_cubit.dart';
import '../../../custody/presentation/cubit/custody_get_requets/custody_get_requets_cubit.dart';
import '../widgets/brand_owner_request_app_bar.dart';
import '../widgets/brand_owner_request_top_section.dart';
import 'brand_owner_requests_custody_requests_view.dart';
import 'brand_owner_requests_custody_sales_transfers_view.dart';
import 'brand_owner_requests_expenses_view.dart';

class BrandOwnerRequestsScreen extends StatelessWidget {
  const BrandOwnerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          const BrandOwnerRequestAppBar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                children: [
                  const BrandOwnerRequestTopSection(),
                  8.verticalSpace,
                  Expanded(
                    child: BlocSelector<PagingCubit, PagingState, int>(
                      selector: (state) => state.currentIndex,
                      builder: (context, state) {
                        return IndexedStack(
                          index: state,
                          children: [
                            MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) =>
                                      getIt<
                                        BranchManagerExpensesHistoryCubit
                                      >(),
                                ),
                              ],
                              child: const BrandOwnerRequestsExpensesView(),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  getIt<CustodyGetRequetsCubit>(),
                              child:
                                  const BrandOwnerRequestsCustodyRequestsView(),
                            ),
                            const BrandOwnerRequestsCustodySalesTransfersView(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
