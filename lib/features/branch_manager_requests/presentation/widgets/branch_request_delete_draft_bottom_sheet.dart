import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../purchase/presentation/cubit/delete_order_draft/delete_order_draft_cubit.dart';
import '../../../purchase/presentation/cubit/delete_order_draft/delete_order_draft_state.dart';

class BranchRequestDeleteDraftBottomSheet extends StatelessWidget {
  final String id;

  const BranchRequestDeleteDraftBottomSheet({super.key, required this.id});

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
                    context.tr.deleteOrderRequestDraft,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    context.tr.thisActionIsPermanentAndCannotBeUndone,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  Text(
                    context.tr.areYouSureYouWantToDeleteThisDraft,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  16.verticalSpace,
                ],
              ),
            ),
            20.verticalSpace,
            BlocConsumer<DeleteOrderDraftCubit, DeleteOrderDraftState>(
              listener: (context, state) {
                if (state is DeleteOrderDraftSuccess) {
                  NavigationService.I.popToFirst();
                } else if (state is DeleteOrderDraftFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is DeleteOrderDraftLoading) {
                  return const AppButtonLoading();
                }

                return CustomTextButton(
                  text: context.tr.delete,
                  onTap: () {
                    context.read<DeleteOrderDraftCubit>().deleteDraft(id: id);
                  },
                  borderColor: Colors.transparent,
                  backgroundColor: context.customColor.error,
                  textColor: context.customColor.reversedTextColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
