import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/manager_approve_button_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/manager_handover_request_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../../../core/di/dependency_injection.dart';
import '../../../../logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import '../../../../logic/shifts/shift_details/shift_details_cubit.dart';
import 'manager_comment_widget.dart';

class HandoverRejectionReasonBottomSheetWidget extends StatefulWidget {
  const HandoverRejectionReasonBottomSheetWidget({
    super.key,
    required this.shiftId,
    required this.cashierName,
    required this.handoverAt,
    required this.branchName,
    this.openedFromModalSheet = false,
    this.cashGiven,
    this.variance,
  });

  final String shiftId;
  final bool openedFromModalSheet;
  final String cashierName;
  final String handoverAt;
  final String branchName;
  final num? cashGiven;
  final num? variance;

  @override
  State<HandoverRejectionReasonBottomSheetWidget> createState() =>
      _HandoverRejectionReasonBottomSheetWidgetState();
}

class _HandoverRejectionReasonBottomSheetWidgetState
    extends State<HandoverRejectionReasonBottomSheetWidget> {
  @override
  void initState() {
    context.read<ShiftDetailsCubit>().getHandoverRejectionDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      // height: 350.h,
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w, vertical: 10.h),
      child: BlocBuilder<ShiftDetailsCubit, ShiftDetailsState>(
        builder: (context, state) {
          if (state is HandoverDetailsLoading) {
            return const Center(child: AppLoadingWidget());
          } else if (state is HandoverDetailsFailure) {
            return Center(child: AppFailureWidget(failure: state.failure));
          } else if (state is HandoverDetailsLoaded) {
            final handoverStatusDetails = state.handoverStatusDetails;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr.handoverDetails, style: AppStyles.s17W500),

                10.verticalSpace,
                Text(
                  context.tr.hereIsWhyThisHandoverWasRejected,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text4,
                  ),
                ),

                10.verticalSpace,
                const CustomDivider(),
                15.verticalSpace,

                if (handoverStatusDetails.correctionDetails != null) ...[
                  ManagerCommentWidget(
                    cashierName:
                        handoverStatusDetails.correctionDetails?.requestedBy ??
                        'NA',
                    handoverAt:
                        handoverStatusDetails
                            .correctionDetails
                            ?.formattedRequestedAtDate ??
                        'MMM dd, yyyy - 00-00 aa',
                    subtitle: context.tr.managersCommentCorrectionRequest,
                    alignedWithNameAndSubtitle: true,
                    messageContent:
                        handoverStatusDetails
                            .correctionDetails
                            ?.managerComment ??
                        'NA',
                  ),

                  15.verticalSpace,
                ],

                ManagerCommentWidget(
                  cashierName:
                      handoverStatusDetails.rejectionReviewedBy ??
                      context.tr.no_name,
                  handoverAt: widget.handoverAt,
                  subtitle: widget.branchName,
                  messageTitle: context.tr.reasonForRejection,
                  messageContent:
                      handoverStatusDetails.rejectionDetails?.rejectionReason ??
                      'NA',
                ),

                60.verticalSpace,

                BlocProvider(
                  create: (context) => getIt<ApproveAndRejectHandoverCubit>(),
                  child: Column(
                    children: [
                      ManagerEditHandoverButton(
                        cashierShiftId: widget.shiftId,
                        cashierName: widget.cashierName,
                        managerName: context.tr.manager,
                        successFunction: () {
                          context.read<ShiftDetailsCubit>().getShiftDetails();
                        },
                        openedFromModalSheet: true,
                        isEnabled: true, // widget.canRequestCorrection,
                      ),

                      20.verticalSpace,
                      ManagerApproveButtonWidget(
                        cashierShiftId: widget.shiftId,
                        cashierName: widget.cashierName,
                        cashFrom: widget.cashierName,
                        cashGiven: widget.cashGiven,
                        variance: widget.variance,
                        managerName: context.tr.manager,
                        successFunction: () {
                          context.read<ShiftDetailsCubit>().getShiftDetails();
                        },
                        isTheCurrentStatusRejected: true,
                        openedFromModalSheet: true,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.expand();
        },
      ),
    );
  }
}
