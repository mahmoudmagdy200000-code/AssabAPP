import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../cubit/accept_escalate_return_rejection/accept_escalate_return_rejection_cubit.dart';
import '../cubit/accept_escalate_return_rejection/accept_escalate_return_rejection_state.dart';
import 'approve_rejecte_success_bottom_sheet_widget.dart';

class AcceptRejectionReturnItemBottomSheetWidgte extends StatelessWidget {
  final String returnId;

  const AcceptRejectionReturnItemBottomSheetWidgte({
    super.key,
    required this.returnId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.acceptRejectionWithoutEscalation,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    context
                        .tr
                        .youreConfirmingThatThisReturnDoesNotRequireFurtherAction,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  25.verticalSpace,
                  Text(
                    context.tr.theRejectionWillStandAsisAndNoEscalationWillBe,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  Text(
                    context.tr.thisDecisionIsFinalAndCannotBeUndone,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            BlocConsumer<
              AcceptEscalateReturnRejectionCubit,
              AcceptEscalateReturnRejectionState
            >(
              listener: (context, state) {
                if (state is AcceptEscalateReturnRejectionSuccess) {
                  NavigationService.I.pop();
                  NavigationService.I.pop();

                  AppBottomSheet.customPageRoute(
                    context,
                    (context) => const ApproveRejecteSuccessBottomSheetWidget(),
                  );
                } else if (state is AcceptEscalateReturnRejectionFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is AcceptEscalateReturnRejectionLoading) {
                  return const AppButtonLoading();
                }

                return Row(
                  children: [
                    Expanded(
                      child: CustomTextButton(
                        text: context.tr.cancel,
                        onTap: () {
                          NavigationService.I.pop();
                        },
                        padding: EdgeInsets.symmetric(vertical: 18.r),
                        textColor: context.customColor.text1,
                        borderRadius: 1000.r,
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: CustomTextButton(
                        text: context.tr.accept,
                        onTap: () {
                          context
                              .read<AcceptEscalateReturnRejectionCubit>()
                              .acceptReturnRejection(id: returnId);
                        },
                        padding: EdgeInsets.symmetric(vertical: 18.r),
                        backgroundColor: context.theme.primaryColor,
                        textColor: context.customColor.reversedTextColor,
                        borderRadius: 1000.r,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
