import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/approve_or_reject_responsibility/approve_or_reject_responsibility_cubit.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/responsibility_approved_sheet_widget.dart';
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
import '../cubit/get_responsibility_details/get_responsibility_details_cubit.dart';
import 'cashier_variance_responsibility_amount_widget.dart';

class ApproveResponsibilitySheetWidget extends StatefulWidget {
  const ApproveResponsibilitySheetWidget({
    super.key,
    required this.shiftId,
    required this.successFunction,
  });

  final String shiftId;
  final Function() successFunction;

  @override
  State<ApproveResponsibilitySheetWidget> createState() =>
      _ApproveResponsibilitySheetWidgetState();
}

class _ApproveResponsibilitySheetWidgetState
    extends State<ApproveResponsibilitySheetWidget> {
  @override
  void initState() {
    context.read<GetResponsibilityDetailsCubit>().getResponsibilityDetails(
      widget.shiftId,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              Text(context.tr.approveResponsibility, style: AppStyles.s17W500),

              5.verticalSpace,

              Text(
                context.tr.youAreConfirmingYourInvolvementInTheVariance,
                style: AppStyles.s15W500.copyWith(
                  color: context.customColor.text3,
                ),
              ),

              10.verticalSpace,
              const CustomDivider(),
              15.verticalSpace,

              BlocBuilder<
                GetResponsibilityDetailsCubit,
                GetResponsibilityDetailsState
              >(
                builder: (context, state) {
                  if (state is GetResponsibilityDetailsLoading) {
                    return const AppLoadingWidget();
                  }
                  if (state is GetResponsibilityDetailsFailure) {
                    return AppFailureWidget(
                      failure: state.failure,
                      onRetry: () {
                        context
                            .read<GetResponsibilityDetailsCubit>()
                            .getResponsibilityDetails(widget.shiftId);
                      },
                    );
                  }
                  if (state is GetResponsibilityDetailsSuccess) {
                    final cashier = state.responsibilityDetails;
                    return CashierVarianceResponsibilityAmountWidget(
                      cashier: cashier,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              Padding(
                padding: EdgeInsets.only(top: 70.h),
                child:
                    BlocConsumer<
                      ApproveOrRejectResponsibilityCubit,
                      ApproveOrRejectResponsibilityState
                    >(
                      listener: (context, state) {
                        if (state is ApproveOrRejectResponsibilitySuccess) {
                          NavigationService.I.pop(context);
                          NavigationService.I.pop(context);

                          AppBottomSheet.showModal(
                            context,
                            (context) => ResponsibilityApprovedSheetWidget(
                              shiftId: widget.shiftId,
                            ),
                          );

                          widget.successFunction();
                        } else if (state
                            is ApproveOrRejectResponsibilityFailed) {
                          AppDialog.showErrorDialog(
                            context: context,
                            failure: state.failure,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is ApproveOrRejectResponsibilityLoading) {
                          return const AppButtonLoading();
                        }

                        return AppButton(
                          onClick: () {
                            context
                                .read<ApproveOrRejectResponsibilityCubit>()
                                .approveResponsibility(shiftId: widget.shiftId);
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
