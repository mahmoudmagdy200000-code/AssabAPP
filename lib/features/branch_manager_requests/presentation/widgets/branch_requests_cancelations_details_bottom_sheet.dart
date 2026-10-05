import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/rejected_widget.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/branch_get_cancel_reason/branch_get_cancel_reason_state.dart';
import 'package:assab/features/supplier_requests/presentation/widgets/supplier_item_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/direct_supplier_order_details_response.dart';
import '../cubit/branch_get_cancel_reason/branch_get_cancel_reason_cubit.dart';

class BranchRequestsCancelationsDetailsBottomSheet extends StatefulWidget {
  final DirectSupplierOrderDetailsProductDetail item;
  final String orderId;

  const BranchRequestsCancelationsDetailsBottomSheet({
    super.key,
    required this.item,
    required this.orderId,
  });

  @override
  State<BranchRequestsCancelationsDetailsBottomSheet> createState() =>
      _BranchRequestsCancelationsDetailsBottomSheetState();
}

class _BranchRequestsCancelationsDetailsBottomSheetState
    extends State<BranchRequestsCancelationsDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();

    _getCancellationDetails();
  }

  void _getCancellationDetails() {
    context.read<BranchGetCancelReasonCubit>().getCancellationReason(
      orderId: widget.orderId,
      itemId: widget.item.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.cancellationDetails,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            8.verticalSpace,
            Text(
              context
                  .tr
                  .thisItemWasCanceledAsAResultItHasBeenVoidedAndWillNotBeProcessedFurther,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            8.verticalSpace,
            SupplierItemPreviewWidget(itemName: widget.item.itemName),
            14.verticalSpace,
            const CustomDivider(),
            14.verticalSpace,
            BlocBuilder<BranchGetCancelReasonCubit, BranchGetCancelReasonState>(
              builder: (context, state) {
                if (state is BranchGetCancelReasonLoading) {
                  return const AppLoadingWidget();
                } else if (state is BranchGetCancelReasonFailure) {
                  return AppFailureWidget(
                    failure: state.failure,
                    onRetry: _getCancellationDetails,
                  );
                } else if (state is BranchGetCancelReasonSuccess) {
                  return RejectedWidget(reason: state.data);
                }

                return AppLocalFailure(onRetry: _getCancellationDetails);
              },
            ),
          ],
        ),
      ),
    );
  }
}
