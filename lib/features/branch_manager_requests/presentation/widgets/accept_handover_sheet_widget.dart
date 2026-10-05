import 'package:assab/core/services/navigation/navigation_service.dart';
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
import '../../../../core/constants/app_assets.dart';
import '../../../shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import '../../../shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import 'handover_accepted_sheet_widget.dart';

class AcceptHandoverSheetWidget extends StatefulWidget {
  const AcceptHandoverSheetWidget({
    super.key,
    required this.shiftId,
    required this.successFunction,
    required this.cashGiven,
    required this.variance,
    required this.cashFrom,
  });

  final String cashGiven;
  final String variance;
  final String cashFrom;
  final String shiftId;
  final Function() successFunction;

  @override
  State<AcceptHandoverSheetWidget> createState() =>
      _AcceptHandoverSheetWidgetModalSheetWidgetState();
}

class _AcceptHandoverSheetWidgetModalSheetWidgetState
    extends State<AcceptHandoverSheetWidget> {
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
              Text(context.tr.acceptHandover, style: AppStyles.s17W500),

              5.verticalSpace,

              RichText(
                text: TextSpan(
                  style: AppStyles.s15W500.copyWith(
                    color: context.customColor.text3,
                  ),
                  children: [
                    TextSpan(
                      text: context.tr.youAreConfirmingReceiptOfThisHandover,
                    ),
                    TextSpan(
                      text: context.tr.openingBalanceTitle,
                      style: AppStyles.s15W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),

                    TextSpan(text: context.tr.forTheShiftYouAreAboutToStart),
                  ],
                ),
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
                    children: [
                      Text(
                        context.tr.openingBalanceTitle,
                        style: AppStyles.s15W600,
                      ),

                      12.verticalSpace,

                      buildShiftCardRowWidget(
                        context: context,
                        firstTitleSvgAsset: AppAssets.cash,
                        title: context.tr.cashGiven,
                        value: widget.cashGiven,
                        firstValueSvgAsset: AppAssets.saudiRiyal,
                        hasSpaceBetweenTitleAndValue: true,
                      ),

                      12.verticalSpace,
                      buildShiftCardRowWidget(
                        context: context,
                        firstTitleSvgAsset: AppAssets.personSvg,
                        title: context.tr.variance_v,
                        value: widget.variance,
                        firstValueSvgAsset: AppAssets.saudiRiyal,
                        hasSpaceBetweenTitleAndValue: true,
                      ),

                      12.verticalSpace,

                      buildShiftCardRowWidget(
                        context: context,
                        firstTitleSvgAsset: AppAssets.personSvg,
                        title: context.tr.cashFrom,
                        value: widget.cashFrom,
                        hasSpaceBetweenTitleAndValue: true,
                      ),

                      12.verticalSpace,
                    ],
                  ),
                ),
              ),

              //
              // LabelTextField(
              //   text: context.tr.managerComment,
              //   style:  AppStyles.s14W400,
              //   isLabelOptional: true,
              //   isLabelRequired: false,
              // ),
              //
              // 5.verticalSpace,
              // Container(
              //   height: 130.h,
              //   decoration: BoxDecoration(
              //     color: AppColors.lightBackground,
              //     borderRadius: BorderRadius.circular(20.r),
              //     border: Border.all(
              //         color: context.customColor.border,
              //         width: 1.w
              //     ),
              //   ),
              //   padding: EdgeInsets.symmetric(
              //     vertical: 18.r,
              //     horizontal: 16.r,
              //   ),
              //   child: CustomTextField(
              //     hintText: context.tr.whyAreUApprovingTheRequest,
              //     controller: managerCommentController,
              //     maxLines: 5,
              //     isEnabled: true,
              //   ),),
              Padding(
                padding: EdgeInsets.only(top: 70.h),
                child:
                    BlocConsumer<
                      ApproveAndRejectHandoverCubit,
                      ApproveAndRejectHandoverState
                    >(
                      listener: (context, state) {
                        if (state is HandoverActionSuccess) {
                          NavigationService.I.pop(context);

                          AppBottomSheet.showModal(
                            context,
                            (context) => HandoverAcceptedSheetWidget(
                              shiftId: widget.shiftId,
                            ),
                          );

                          widget.successFunction();
                        } else if (state is HandoverActionFailure) {
                          AppDialog.showErrorDialog(
                            context: context,
                            failure: state.failure,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is HandoverActionLoading) {
                          return const AppButtonLoading();
                        }

                        return AppButton(
                          onClick: () {
                            context
                                .read<ApproveAndRejectHandoverCubit>()
                                .approveHandover(
                                  shiftId: widget.shiftId,
                                  managerComment: managerCommentController.text,
                                );
                          },
                          text: context.tr.approveHandover,
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
}
