import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:assab/features/custody/presentation/widgets/custody_app_bar.dart';
import 'package:assab/features/brand_owner_requests/presentation/cubits/branch_owner_approve_reject_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/brand_owner_requests_custody_sales_transfers_cubit.dart';
import '../cubits/brand_owner_requests_custody_sales_transfers_state.dart';
import '../../data/repositories/brand_owner_requests_repository.dart';
import 'brand_owner_sales_transfer_details_screen_approval_view.dart';
import 'brand_owner_sales_transfer_details_screen_details_view.dart';

class BrandOwnerSalesTransferDetailsScreen extends StatefulWidget {
  final String requestId;
  final UserTypeStrategy userTypeStrategy;
  final VoidCallback? onListRefresh;

  const BrandOwnerSalesTransferDetailsScreen({
    super.key,
    required this.requestId,
    required this.userTypeStrategy,
    this.onListRefresh,
  });

  @override
  State<BrandOwnerSalesTransferDetailsScreen> createState() =>
      _BrandOwnerSalesTransferDetailsScreenState();
}

class _BrandOwnerSalesTransferDetailsScreenState
    extends State<BrandOwnerSalesTransferDetailsScreen> {
  late final PagingCubit _pagingCubit;
  late final BrandOwnerRequestsCustodySalesTransfersCubit _cubit;

  @override
  void initState() {
    super.initState();

    _pagingCubit = PagingCubit(totalSteps: 3);
    _cubit = BrandOwnerRequestsCustodySalesTransfersCubit(
      getIt<BrandOwnerRequestsRepository>(),
    )..getBrandOwnerSalesTransferDetailsScreen(requestId: widget.requestId);
  }

  @override
  void dispose() {
    _pagingCubit.close();
    _cubit.close();
    super.dispose();
  }

  void _refetchDetails() {
    _cubit.getBrandOwnerSalesTransferDetailsScreen(requestId: widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _pagingCubit),
        BlocProvider.value(value: _cubit),
        BlocProvider(
          create: (context) => getIt<BranchOwnerApproveRejectCubit>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: context.customColor.text2,
        body:
            BlocBuilder<
              BrandOwnerRequestsCustodySalesTransfersCubit,
              BrandOwnerRequestsCustodySalesTransfersState
            >(
              builder: (context, state) {
                if (state is BrandOwnerRequestsCustodySalesTransfersLoading) {
                  return const AppLoadingWidget();
                }

                if (state is BrandOwnerRequestsCustodySalesTransfersFailure) {
                  return AppFailureWidget(
                    failure: state.failure,
                    onRetry: () => context
                        .read<BrandOwnerRequestsCustodySalesTransfersCubit>()
                        .getBrandOwnerSalesTransferDetailsScreen(
                          requestId: widget.requestId,
                        ),
                    withBorder: false,
                  );
                }

                final details = state is BrandOwnerSalesTransferDetailsSuccess
                    ? state.details
                    : null;

                if (details == null) {
                  return const AppLoadingWidget();
                }

                final tabs = [
                  context.tr.details,
                  context.tr.timelines,
                  context.tr.approval,
                ];

                return Column(
                  children: [
                    10.verticalSpace,
                    CustodyAppBar(
                      title: context.tr.cashSalesTransfer,
                      subtitle: context.tr.viewDetailsTimelinesAndStatuses,
                      titleStyle: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                      iconColor: context.customColor.text1,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.r),
                            topRight: Radius.circular(24.r),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 16.r,
                          horizontal: 20.r,
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: context.customColor.text2,
                                borderRadius: BorderRadius.circular(1000.r),
                              ),
                              padding: EdgeInsets.all(6.r),
                              child: Row(
                                children: List.generate(3, (index) {
                                  return Expanded(
                                    child:
                                        BlocSelector<
                                          PagingCubit,
                                          PagingState,
                                          bool
                                        >(
                                          selector: (state) =>
                                              state.currentIndex == index,
                                          builder: (context, isSelected) {
                                            return CustomTextButton(
                                              text: tabs[index],
                                              onTap: () {
                                                context
                                                    .read<PagingCubit>()
                                                    .goToStep(index);
                                              },
                                              textColor:
                                                  context.customColor.text1,
                                              borderRadius: 1000.r,
                                              borderColor: Colors.transparent,
                                              backgroundColor: isSelected
                                                  ? context
                                                        .customColor
                                                        .reversedTextColor
                                                  : Colors.transparent,
                                            );
                                          },
                                        ),
                                  );
                                }),
                              ),
                            ),
                            12.verticalSpace,
                            Expanded(
                              child: BlocSelector<PagingCubit, PagingState, int>(
                                selector: (state) => state.currentIndex,
                                builder: (context, selectedIndex) {
                                  return IndexedStack(
                                    index: selectedIndex,
                                    children: [
                                      BrandOwnerSalesTransferDetailsScreenDetailsView(
                                        details: details,
                                        userTypeStrategy:
                                            widget.userTypeStrategy,
                                        onListRefresh: widget.onListRefresh,
                                        onApproveRejectSuccess: _refetchDetails,
                                      ),
                                      TimeLinesView(
                                        timelines: details.timelines.timelines,
                                      ),
                                      BrandOwnerSalesTransferDetailsScreenApprovalView(
                                        approvers: details.approvers,
                                      ),
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
                );
              },
            ),
      ),
    );
  }
}
