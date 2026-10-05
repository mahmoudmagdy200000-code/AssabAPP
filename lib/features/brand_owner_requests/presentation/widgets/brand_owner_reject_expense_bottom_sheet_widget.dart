import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_text_button.dart';
import '../cubits/branch_owner_approve_reject_cubit.dart';

class BrandOwnerRejectExpenseBottomSheetWidget extends StatefulWidget {
  final String id;
  final void Function()? onSuccess;

  const BrandOwnerRejectExpenseBottomSheetWidget({
    super.key,
    required this.id,
    this.onSuccess,
  });

  @override
  State<BrandOwnerRejectExpenseBottomSheetWidget> createState() =>
      _BrandOwnerRejectExpenseBottomSheetWidgetState();
}

class _BrandOwnerRejectExpenseBottomSheetWidgetState
    extends State<BrandOwnerRejectExpenseBottomSheetWidget> {
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();

    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

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
                    context.tr.rejectExpenseRequest,
                    style: AppStyles.s20W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    context.tr.rejectExpenseRequestDesc,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  20.verticalSpace,
                  ContainerCustomTextField(
                    label: context.tr.reasonForRejection,
                    child: CustomTextField(
                      hintText: context.tr.rejectExpenseReasonHint,
                      controller: _reasonController,
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.cancel,
                    onTap: () {
                      NavigationService.I.pop();
                    },
                    padding: EdgeInsets.symmetric(vertical: 16.r),
                    textColor: context.customColor.text1,
                    borderRadius: 20.r,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.reject,
                    onTap: () {
                      NavigationService.I.pop();

                      context
                          .read<BranchOwnerApproveRejectCubit>()
                          .rejectExpense(
                            expenseId: widget.id,
                            reason: _reasonController.text,
                            onSuccess: () {
                              widget.onSuccess?.call();
                            },
                          );
                    },
                    padding: EdgeInsets.symmetric(vertical: 16.r),
                    textColor: context.customColor.reversedTextColor,
                    borderRadius: 20.r,
                    backgroundColor: context.customColor.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
