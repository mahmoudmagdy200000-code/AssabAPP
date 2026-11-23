import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../branch_manager_expenses/domain/strategies/expense_category.dart';
import '../../../branch_manager_expenses/presentation/cubit/branch_manager_expenses_history/branch_manager_expenses_history_cubit.dart';
import '../../../custody/presentation/cubit/custody_get_requets/custody_get_requets_cubit.dart';
import '../cubits/brand_owner_requests_custody_sales_transfers_cubit.dart';
import '../widgets/brand_owner_request_app_bar.dart';
import '../widgets/brand_owner_request_top_section.dart';
import 'brand_owner_requests_custody_requests_view.dart';
import 'brand_owner_requests_custody_sales_transfers_view.dart';
import 'brand_owner_requests_expenses_view.dart';

class BrandOwnerRequestsScreen extends StatefulWidget {
  final bool isActiveTab;

  const BrandOwnerRequestsScreen({super.key, this.isActiveTab = true});

  @override
  State<BrandOwnerRequestsScreen> createState() =>
      _BrandOwnerRequestsScreenState();
}

class _BrandOwnerRequestsScreenState extends State<BrandOwnerRequestsScreen> {
  late final BranchManagerExpensesHistoryCubit _expensesCubit;
  late final CustodyGetRequetsCubit _custodyRequestsCubit;
  late final BrandOwnerRequestsCustodySalesTransfersCubit _salesTransfersCubit;

  @override
  void initState() {
    super.initState();
    _expensesCubit = getIt<BranchManagerExpensesHistoryCubit>();
    _custodyRequestsCubit = getIt<CustodyGetRequetsCubit>();
    _salesTransfersCubit = getIt<BrandOwnerRequestsCustodySalesTransfersCubit>();

    if (widget.isActiveTab) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.isActiveTab) {
          _refreshSubTab(context.read<PagingCubit>().state.currentIndex);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant BrandOwnerRequestsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActiveTab && widget.isActiveTab) {
      _refreshSubTab(context.read<PagingCubit>().state.currentIndex);
    }
  }

  @override
  void dispose() {
    _expensesCubit.close();
    _custodyRequestsCubit.close();
    _salesTransfersCubit.close();
    super.dispose();
  }

  void _refreshSubTab(int subTabIndex) {
    switch (subTabIndex) {
      case 0:
        _expensesCubit.loadExpenses(type: const AllExpense());
      case 1:
        _custodyRequestsCubit.getCustodyRequests();
      case 2:
        _salesTransfersCubit.getBrandOwnerRequestsCustodySalesTransfersView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _expensesCubit),
        BlocProvider.value(value: _custodyRequestsCubit),
        BlocProvider.value(value: _salesTransfersCubit),
      ],
      child: BlocListener<PagingCubit, PagingState>(
        listenWhen: (previous, current) =>
            previous.currentIndex != current.currentIndex,
        listener: (context, state) {
          if (widget.isActiveTab) {
            _refreshSubTab(state.currentIndex);
          }
        },
        child: Scaffold(
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
                              children: const [
                                BrandOwnerRequestsExpensesView(),
                                BrandOwnerRequestsCustodyRequestsView(),
                                BrandOwnerRequestsCustodySalesTransfersView(),
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
        ),
      ),
    );
  }
}
