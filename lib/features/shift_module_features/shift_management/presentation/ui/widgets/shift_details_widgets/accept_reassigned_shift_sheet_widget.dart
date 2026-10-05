import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/shift_details/shift_details_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/reassigned_shift_accepted_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../../core/utils/app_dialog.dart';
import '../../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../../core/widgets/app_button_loading.dart';
import '../../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../../../../cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/card_label_widget.dart';
import '../../../../../../cashier_requests/presentation/cubits/accept_reassigned_shift/accept_reassigned_shift_cubit.dart';
import '../../../../data/mapper/shift/shift_mapper.dart';
import '../cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';

class AcceptReassignedShiftSheetWidget extends StatefulWidget {
  const AcceptReassignedShiftSheetWidget({
    super.key,
    required this.shiftId,
    required this.cashGiven,
    required this.variance,
    required this.startTime,
    required this.endTime,
    required this.nextCashierName,
    required this.reassignedFrom,
    required this.reassignedBy,
    required this.shiftDate,
  });

  final String cashGiven;
  final String variance;
  final String shiftId;
  final String startTime;
  final String endTime;
  final String nextCashierName;
  final String reassignedFrom;
  final String reassignedBy;
  final String shiftDate;

  @override
  State<AcceptReassignedShiftSheetWidget> createState() =>
      _AcceptReassignedShiftSheetWidgetState();
}

class _AcceptReassignedShiftSheetWidgetState
    extends State<AcceptReassignedShiftSheetWidget> {
  @override
  void initState() {
    super.initState();
    managerCommentController = TextEditingController();
  }

  @override
  void dispose() {
    managerCommentController.dispose();
    super.dispose();
  }

  late final TextEditingController managerCommentController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: double.maxFinite,
        // height: 350.h,
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr.reviewShitReassignment, style: AppStyles.s17W500),

              5.verticalSpace,

              Text(
                context.tr.youReassignedToThisShift,
                style: AppStyles.s15W500.copyWith(
                  color: context.customColor.text3,
                ),
              ),

              7.verticalSpace,

              Row(
                children: [
                  Container(
                    width: 5.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      context
                          .tr
                          .theShiftIsScheduledForTodayAndMayAlreadyBeActive,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                ],
              ),

              10.verticalSpace,
              const CustomDivider(),
              15.verticalSpace,

              Container(
                margin: EdgeInsetsDirectional.only(bottom: 10.h),
                child: Container(
                  padding: EdgeInsetsGeometry.all(15.w),
                  width: 340.w,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.h,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate(widget.shiftDate),
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
                        value: widget.reassignedFrom ?? context.tr.no_name,
                      ),
                      _buildRowItem(
                        context: context,
                        asset: AppAssets.personSvg,
                        title: context.tr.reassigned_by,
                        value: widget.reassignedBy ?? context.tr.no_name,
                      ),

                      CustomDivider(color: context.customColor.border),

                      buildShiftCardRowWidget(
                        context: context,
                        firstTitleSvgAsset: AppAssets.cash,
                        title: context.tr.cash_given,
                        firstValueSvgAsset: AppAssets.saudiRiyal,
                        value: widget.cashGiven.toString(),

                        secondTitle: context.tr.variance,
                        secondValue: widget.variance.toString(),
                        secondValueSvgAsset: AppAssets.saudiRiyal,
                        hasTwoRows: true,
                      ),

                      CustomDivider(color: context.customColor.border),

                      _buildRowItem(
                        context: context,
                        asset: AppAssets.clockSvg,
                        title: context.tr.startTime,
                        value: widget.startTime,
                      ),
                      _buildRowItem(
                        context: context,
                        asset: AppAssets.clockSvg,
                        title: context.tr.end_time,
                        value: widget.endTime,
                      ),

                      _buildRowItem(
                        context: context,
                        asset: AppAssets.personSvg,
                        title: context.tr.next_cashier,
                        value: widget.nextCashierName ?? context.tr.no_name,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 70.h),
                child:
                    BlocConsumer<
                      AcceptReassignedShiftCubit,
                      AcceptReassignedShiftState
                    >(
                      listener: (context, state) {
                        if (state.success) {
                          NavigationService.I.pop(context);

                          AppBottomSheet.showModal(
                            context,
                            (context) =>
                                const ReassignedShiftAcceptedSheetWidget(),
                          );

                          context.read<ShiftDetailsCubit>().getShiftDetails();
                        } else if (state.failure != null) {
                          AppDialog.showErrorDialog(
                            context: context,
                            failure: state.failure!,
                          );
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state.loadingShiftId != null;

                        if (isLoading) {
                          return const AppButtonLoading();
                        }

                        return AppButton(
                          onClick: () {
                            context
                                .read<AcceptReassignedShiftCubit>()
                                .acceptReassignedShift(shiftId: widget.shiftId);
                          },
                          text: context.tr.confirmApproval,
                          borderRadius: BorderRadius.circular(10.r),
                          enabled: true,
                          background: AppColors.primaryLight,
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowItem({
    required BuildContext context,
    required String asset,
    required String title,
    required String value,
    bool isCurrency = false,
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
        if (isCurrency) const SaudiRiyalSvgWidget(),
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
