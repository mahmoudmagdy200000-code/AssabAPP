import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/utils/currency_normalizer.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
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
import '../../../shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/reject_handover_widgets/reject_handover_modal_sheet_widget.dart';
import 'handover_accepted_sheet_widget.dart';

class AcceptHandoverSheetWidget extends StatefulWidget {
  const AcceptHandoverSheetWidget({
    super.key,
    required this.shiftId,
    required this.successFunction,
    required this.cashGiven,
    required this.variance,
    required this.cashFrom,
    this.actorRole,
  });

  final String cashGiven;
  final String variance;
  final String cashFrom;
  final String shiftId;
  final Function() successFunction;
  final UserType? actorRole;

  @override
  State<AcceptHandoverSheetWidget> createState() =>
      _AcceptHandoverSheetWidgetModalSheetWidgetState();
}

class _AcceptHandoverSheetWidgetModalSheetWidgetState
    extends State<AcceptHandoverSheetWidget> {
  late final TextEditingController managerCommentController;
  late final TextEditingController confirmedAmountController;

  @override
  void initState() {
    super.initState();
    managerCommentController = TextEditingController();
    confirmedAmountController = TextEditingController();
  }

  @override
  void dispose() {
    managerCommentController.dispose();
    confirmedAmountController.dispose();
    super.dispose();
  }

  double? get _expectedAmount {
    return CurrencyNormalizer.parseSarAmount(widget.cashGiven);
  }

  double? get _confirmedAmount {
    return CurrencyNormalizer.parseSarAmount(confirmedAmountController.text);
  }

  bool get _hasAmountMismatch {
    final confirmed = _confirmedAmount;
    final expected = _expectedAmount;
    if (confirmed == null || expected == null) return false;
    return !CurrencyNormalizer.areAmountsEqual(confirmed, expected);
  }

  bool get _canConfirm {
    final confirmed = _confirmedAmount;
    final expected = _expectedAmount;
    if (confirmed == null || expected == null) return false;
    return CurrencyNormalizer.areAmountsEqual(confirmed, expected);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: double.maxFinite,
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
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: context.tr.openingBalanceTitle,
                      style: AppStyles.s15W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    TextSpan(
                      text: (widget.actorRole == UserType.branchManager ||
                              UserTypeService.selectedUserType ==
                                  UserType.branchManager)
                          ? ' as the responsible manager for custody verification.'
                          : context.tr.forTheShiftYouAreAboutToStart,
                    ),
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

              10.verticalSpace,

              LabelTextField(
                text: context.tr.amount,
                style: AppStyles.s14W400,
                isLabelRequired: true,
              ),

              5.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 4.r,
                  horizontal: 16.r,
                ),
                child: CustomTextField(
                  hintText: '0.00',
                  controller: confirmedAmountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  isEnabled: true,
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),

              if (_hasAmountMismatch) ...[
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.red.withValues(alpha: 0.5),
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.red,
                            size: 20.r,
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: Text(
                              'CASH-09: Receipt Amount Mismatch',
                              style: AppStyles.s14W600.copyWith(
                                color: AppColors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      6.verticalSpace,
                      Text(
                        'Counted physical cash (${CurrencyNormalizer.formatSar(_confirmedAmount!)} SAR) does not match reported handover (${widget.cashGiven} SAR). Under CASH-09, confirmation is blocked. You must reject this handover to request recounting and correction.',
                        style: AppStyles.s12W400.copyWith(
                          color: AppColors.red,
                        ),
                      ),
                      12.verticalSpace,
                      AppButton(
                        onClick: () {
                          final countedStr = CurrencyNormalizer.formatSar(_confirmedAmount!);
                          final reportedStr = widget.cashGiven;
                          final mismatchComment =
                              'CASH-09: Counted physical cash ($countedStr SAR) does not match reported handover ($reportedStr SAR). Recounting and correction required.';

                          NavigationService.I.pop();

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final currentContext = NavigationService.I.context;
                            if (currentContext != null && currentContext.mounted) {
                              AppBottomSheet.showModal(
                                currentContext,
                                (sheetContext) => BlocProvider(
                                  create: (_) =>
                                      getIt<ApproveAndRejectHandoverCubit>(),
                                  child: RejectHandoverModalSheetWidget(
                                    shiftId: widget.shiftId,
                                    successFunction: widget.successFunction,
                                    openedFromModalSheet: false,
                                    initialComment: mismatchComment,
                                  ),
                                ),
                                isScrollControlled: true,
                              );
                            }
                          });
                        },
                        text: 'Reject & Request Recount',
                        borderRadius: BorderRadius.circular(8.r),
                        background: AppColors.red,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        isFlexible: true,
                        enabled: true,
                      ),
                    ],
                  ),
                ),
              ],

              15.verticalSpace,

              LabelTextField(
                text: context.tr.managerComment,
                style: AppStyles.s14W400,
                isLabelOptional: true,
                isLabelRequired: false,
              ),

              5.verticalSpace,
              Container(
                height: 100.h,
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 8.r,
                  horizontal: 16.r,
                ),
                child: CustomTextField(
                  hintText: context.tr.whyAreUApprovingTheRequest,
                  controller: managerCommentController,
                  maxLines: 3,
                  isEnabled: true,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 25.h),
                child:
                    BlocConsumer<
                      ApproveAndRejectHandoverCubit,
                      ApproveAndRejectHandoverState
                    >(
                      listener: (context, state) {
                        if (state is HandoverActionSuccess) {
                          NavigationService.I.pop();

                          AppBottomSheet.showModal(
                            NavigationService.I.context ?? context,
                            (context) => HandoverAcceptedSheetWidget(
                              shiftId: widget.shiftId,
                              isManager: (widget.actorRole == UserType.branchManager ||
                                  UserTypeService.selectedUserType ==
                                      UserType.branchManager),
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
                            if (!_canConfirm) return;
                            context
                                .read<ApproveAndRejectHandoverCubit>()
                                .confirmHandoverReceipt(
                                  shiftId: widget.shiftId,
                                  confirmedAmount:
                                      confirmedAmountController.text.trim(),
                                  expectedAmount: _expectedAmount,
                                  actorRole: widget.actorRole ??
                                      UserType.branchManager,
                                  comment:
                                      managerCommentController.text.isNotEmpty
                                          ? managerCommentController.text
                                          : null,
                                );
                          },
                          text: context.tr.approveHandover,
                          borderRadius: BorderRadius.circular(10.r),
                          enabled: _canConfirm,
                          background: _canConfirm
                              ? AppColors.primaryLight
                              : AppColors.lightGray,
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
