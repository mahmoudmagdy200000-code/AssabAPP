import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/card_label_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../branch_manager_requests/presentation/widgets/branch_manager_requests_empty_widget.dart';
import '../../../shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import '../../../shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/see_details_button_widget.dart';
import '../../data/models/reassigned_shift_item_model.dart';
import '../cubits/accept_reassigned_shift/accept_reassigned_shift_cubit.dart';
import '../cubits/get_reassignments/get_reassignments_cubit.dart';
import '../cubits/get_reassignments/get_reassignments_state.dart';

class CashierRequestReassignmentsView extends StatefulWidget {
  const CashierRequestReassignmentsView({super.key});

  @override
  State<CashierRequestReassignmentsView> createState() =>
      _CashierRequestReassignmentsViewState();
}

class _CashierRequestReassignmentsViewState
    extends State<CashierRequestReassignmentsView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _getReassignedShifts();

    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenToScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _listenToScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400.r) {
      if (context.read<GetReassignedShiftsCubit>().paginator.hasMore) {
        _getReassignedShifts(loadMore: true);
      }
    }
  }

  void _getReassignedShifts({bool loadMore = false}) {
    context.read<GetReassignedShiftsCubit>().getReassignedShifts(
      loadMore: loadMore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      bottom: 0,
      child: BlocBuilder<GetReassignedShiftsCubit, GetReassignedShiftsState>(
        builder: (context, state) {
          final orders = <ReassignedShiftItemModel>[];

          if (state is GetReassignedShiftsLoading) {
            return const AppLoadingWidget();
          } else if (state is GetReassignedShiftsFailure) {
            return AppFailureWidget(
              failure: state.failure,
              onRetry: _getReassignedShifts,
              withBorder: false,
            );
          } else if (state is GetReassignedShiftsSuccess) {
            orders.addAll(state.shifts);

            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'count_reassignments',
              value: orders.length.toString(),
              isValid: true,
            );
          }

          if (orders.isEmpty) {
            return BranchManagerRequestsEmptyWidget(
              onRefresh: _getReassignedShifts,
              message: context.tr.noReassignedShifts,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _getReassignedShifts(),
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: orders.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(20.r),
                  margin: EdgeInsets.only(bottom: 8.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.h,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate(orders[index].shiftDate),
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          CardLabelWidget(
                            title: context.tr.reassigned_to_u,
                            textColor: AppColors.dark2Yellow,
                          ),
                        ],
                      ),

                      CustomDivider(color: context.customColor.border),

                      _buildRowItem(
                        context: context,
                        asset: AppAssets.personSvg,
                        title: context.tr.reassigned_from,
                        value:
                            orders[index].reassignedFrom ?? context.tr.no_name,
                        isCurrancy: true,
                      ),
                      _buildRowItem(
                        context: context,
                        asset: AppAssets.personSvg,
                        title: context.tr.reassigned_by,
                        value: orders[index].reassignedBy ?? context.tr.no_name,
                        isCurrancy: true,
                      ),

                      CustomDivider(color: context.customColor.border),

                      buildShiftCardRowWidget(
                        context: context,
                        firstTitleSvgAsset: AppAssets.cash,
                        title: context.tr.cash_given,
                        firstValueSvgAsset: AppAssets.saudiRiyal,
                        value: orders[index].cashGiven.toString(),

                        secondTitle: context.tr.variance,
                        secondValue: orders[index].variance.toString(),
                        secondValueSvgAsset: AppAssets.saudiRiyal,
                        hasTwoRows: true,
                      ),

                      CustomDivider(color: context.customColor.border),

                      _buildRowItem(
                        context: context,
                        asset: AppAssets.clockSvg,
                        title: context.tr.startTime,
                        value: orders[index].startTime.toString(),
                      ),
                      _buildRowItem(
                        context: context,
                        asset: AppAssets.clockSvg,
                        title: context.tr.end_time,
                        value: orders[index].endTime.toString(),
                      ),

                      _buildRowItem(
                        context: context,
                        asset: AppAssets.personSvg,
                        title: context.tr.next_cashier,
                        value: orders[index].nextCashier ?? context.tr.no_name,
                      ),

                      Row(
                        spacing: 12.w,
                        children: [
                          BlocConsumer<
                            AcceptReassignedShiftCubit,
                            AcceptReassignedShiftState
                          >(
                            listener: (context, state) {
                              if (state.success) {
                                _getReassignedShifts(loadMore: false);
                              }

                              final isError =
                                  state.errorShiftId == orders[index].id;

                              if (state.failure != null && isError) {
                                AppDialog.showErrorDialog(
                                  context: context,
                                  failure: state.failure!,
                                );
                              }
                            },
                            builder: (context, state) {
                              final isLoading =
                                  state.loadingShiftId == orders[index].id;

                              if (isLoading) {
                                return const Expanded(
                                  child: AppButtonLoading(),
                                );
                              }
                              return Expanded(
                                child: CustomTextButton(
                                  text: context.tr.acceptShift,
                                  onTap: () {
                                    context
                                        .read<AcceptReassignedShiftCubit>()
                                        .acceptReassignedShift(
                                          shiftId: orders[index].id,
                                        );
                                  },
                                  backgroundColor: AppColors.primaryLight,
                                  textColor: AppColors.lightBackground,
                                  padding: EdgeInsets.symmetric(vertical: 15.r),
                                ),
                              );
                            },
                          ),

                          // Expanded(
                          //   child: CustomTextButton(
                          //     text: context.tr.seeDetails,
                          //     onTap: () {
                          //
                          //       NavigationService.I.pushNamed(
                          //         AppRouteName.shiftDetailsScreen,
                          //         arguments: {
                          //           'shiftId': orders[index].id,
                          //           'isNavigatedFromCashier': false,
                          //         },
                          //       );
                          //     },
                          //     backgroundColor: AppColors.lightBackground,
                          //     textColor: context.customColor.text1,
                          //     padding: EdgeInsets.symmetric(vertical: 15.r),
                          //   ),
                          // ),
                          Expanded(
                            child: SeeDetailsButtonWidget(
                              shiftId: orders[index].id,
                              isCashier: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRowItem({
    required BuildContext context,
    required String asset,
    required String title,
    required String value,
    bool isCurrancy = false,
  }) {
    return Row(
      children: [
        AppSvg(
          assetName: asset,
          width: 18.w,
          colorFilter: ColorFilter.mode(
            context.customColor.text3,
            BlendMode.srcIn,
          ),
        ),
        8.horizontalSpace,
        Flexible(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        8.horizontalSpace,
        if (isCurrancy) const SaudiRiyalSvgWidget(),
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
