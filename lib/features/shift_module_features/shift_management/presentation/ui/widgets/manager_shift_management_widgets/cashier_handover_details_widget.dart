import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/enums/shift_status/shift_handover_status.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../../data/mapper/shift/shift_details/handover_status_ui_mapper.dart';
import '../../../../domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import '../cashier_shifts_management_widgets/cashier_info_container_widget.dart';
import '../cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';

class CashierHandoverDetails extends StatefulWidget {
  const CashierHandoverDetails({
    super.key,
    required this.handover,
    required this.managerName,
  });

  final HandoverDetailsEntity handover;
  final String managerName;

  @override
  State<CashierHandoverDetails> createState() => _CashierHandoverDetailsState();
}

class _CashierHandoverDetailsState extends State<CashierHandoverDetails> {
  @override
  void initState() {
    super.initState();
    context.read<ManagerShiftCubit>().getCashierHandoverDetails(
      widget.handover.handoverId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w, vertical: 20.h),
      child: BlocBuilder<ManagerShiftCubit, ManagerShiftState>(
        builder: (context, state) {
          if (state is CashierHandoverDetailsLoading) {
            return const AppLoadingWidget();
          } else if (state is CashierHandoverDetailsLoadingFailure) {
            return AppFailureWidget(failure: state.failure);
          } else if (state is CashierHandoverDetailsLoaded) {
            final handoverDetails = state.handoverDetails;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      CashierInfoContainerWidget(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: context.customColor.border,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  context.tr.totalSales,
                                  style: AppStyles.s13W500,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppSvg(
                                      assetName: AppAssets.saudiRiyal,
                                      width: 24.w,
                                      height: 24.h,
                                    ),

                                    Text(
                                      handoverDetails.totalSales.toString(),
                                      style: AppStyles.s16W500,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Text(
                            context.tr.salesBreakDown,
                            style: AppStyles.s13W600,
                          ),

                          const CustomDivider(),
                          buildShiftCardRowWidget(
                            context: context,
                            title: context.tr.cashCollected,
                            firstTitleSvgAsset: AppAssets.cash,
                            firstValueSvgAsset: AppAssets.saudiRiyal,
                            hasSpaceBetweenTitleAndValue: true,
                            value: handoverDetails.cashCollected.toString(),
                          ),
                          const CustomDivider(),

                          buildShiftCardRowWidget(
                            context: context,
                            title: context.tr.cardPayment,
                            firstTitleSvgAsset: AppAssets.cash,
                            firstValueSvgAsset: AppAssets.saudiRiyal,
                            hasSpaceBetweenTitleAndValue: true,
                            value: handoverDetails.cardPayments.toString(),
                          ),
                          const CustomDivider(),

                          buildShiftCardRowWidget(
                            context: context,
                            title: context.tr.deliveryApps,
                            firstTitleSvgAsset: AppAssets.cash,
                            firstValueSvgAsset: AppAssets.saudiRiyal,
                            hasSpaceBetweenTitleAndValue: true,
                            value: handoverDetails.deliveryAppPayments
                                .toString(),
                          ),
                        ],
                      ),

                      20.verticalSpace,

                      CashierInfoContainerWidget(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.tr.handover,
                                style: AppStyles.s13W600,
                              ),

                              Container(
                                color: Colors.white,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(3.w),
                                child: Text(
                                  handoverDetails.handoverStatus.label,
                                  style: AppStyles.s12W500.copyWith(
                                    color: handoverDetails
                                        .handoverStatus
                                        .textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          buildShiftCardRowWidget(
                            context: context,
                            title: context.tr.cashHandoverAmount,
                            firstTitleSvgAsset: AppAssets.cash,
                            firstValueSvgAsset: AppAssets.saudiRiyal,
                            hasSpaceBetweenTitleAndValue: true,
                            value: handoverDetails.handoverAmount.toString(),
                          ),

                          const CustomDivider(),
                          buildShiftCardRowWidget(
                            context: context,
                            title: context.tr.handoverFrom,
                            firstTitleSvgAsset: AppAssets.cash,
                            firstValueSvgAsset: AppAssets.saudiRiyal,
                            hasSpaceBetweenTitleAndValue: true,
                            value: handoverDetails.handoverFrom,
                          ),

                          const CustomDivider(),
                          buildShiftCardRowWidget(
                            context: context,
                            title: context.tr.handoverTo,
                            firstTitleSvgAsset: AppAssets.cash,
                            firstValueSvgAsset: AppAssets.saudiRiyal,
                            hasSpaceBetweenTitleAndValue: true,
                            value: handoverDetails.handoverTo,
                          ),

                          const CustomDivider(),
                          buildShiftCardRowWidget(
                            context: context,
                            title: context.tr.handoverDate,
                            firstTitleSvgAsset: AppAssets.calendar,
                            hasSpaceBetweenTitleAndValue: true,
                            value: handoverDetails.handoverDate,
                          ),

                          const CustomDivider(),
                          buildShiftCardRowWidget(
                            context: context,
                            title: context.tr.handoverTime,
                            firstTitleSvgAsset: AppAssets.clockSvg,
                            hasSpaceBetweenTitleAndValue: true,
                            value: handoverDetails.handoverTime,
                          ),

                          2.verticalSpace,
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: handoverDetails.handoverStatus.cardColor,
                            ),
                            child: Text(
                              handoverDetails.handoverStatus
                                  .managerPovHandoverDetailsText(
                                    handoverDetails.handoverFrom,
                                    handoverDetails.handoverDate,
                                  ),
                              textAlign: TextAlign.center,
                              style: AppStyles.s13W500.copyWith(
                                color: handoverDetails.handoverStatus.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      20.verticalSpace,

                      if (handoverDetails.handoverStatus ==
                              HandoverStatus.rejected &&
                          handoverDetails.correctionDetails != null)
                        Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.customColor.border,
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: AppColors.primaryLight,
                                    size: 20.w,
                                  ),
                                  10.horizontalSpace,

                                  Text(
                                    context.tr.yourComment,
                                    style: AppStyles.s14W600,
                                  ),
                                ],
                              ),

                              10.verticalSpace,

                              Text(
                                handoverDetails
                                        .correctionDetails
                                        ?.managerComment ??
                                    context.tr.emptyComment,
                                style: AppStyles.s14W500,
                              ),
                              10.verticalSpace,

                              Text(
                                handoverDetails
                                        .correctionDetails
                                        ?.formattedRequestedAtDate ??
                                    '00-00-0000',
                                style: AppStyles.s13W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ),
                            ],
                          ),
                        ),

                      20.verticalSpace,
                    ],
                  ),
                ),

                handoverDetails.handoverStatus
                    .managerPovHandoverDetailsActionButtons(
                      context: context,
                      handover: widget.handover,
                      managerName: widget.managerName,
                      isEnabled:
                          handoverDetails.correctionDetails?.canCashierEdit ??
                          true,
                    ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
