import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/rejected_widget.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_get_cancellation_reason/supplier_get_cancellation_reason_state.dart';
import 'package:assab/features/supplier_requests/presentation/widgets/supplier_item_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/supplier_orders_response.dart';
import '../cubit/supplier_get_cancellation_reason/supplier_get_cancellation_reason_cubit.dart';

class SupplierRequestsCancelationsDetailsBottomSheet extends StatefulWidget {
  final SupplierOrderItem item;
  final String orderId;

  const SupplierRequestsCancelationsDetailsBottomSheet({
    super.key,
    required this.item,
    required this.orderId,
  });

  @override
  State<SupplierRequestsCancelationsDetailsBottomSheet> createState() =>
      _SupplierRequestsCancelationsDetailsBottomSheetState();
}

class _SupplierRequestsCancelationsDetailsBottomSheetState
    extends State<SupplierRequestsCancelationsDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
    _getCancellationDetails();
  }

  void _getCancellationDetails() {
    context
        .read<SupplierGetCancellationReasonCubit>()
        .getSupplierCancellationReason(
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
            SupplierItemPreviewWidget(itemName: widget.item.productName),
            14.verticalSpace,
            const CustomDivider(),
            14.verticalSpace,
            BlocBuilder<
              SupplierGetCancellationReasonCubit,
              SupplierGetCancellationReasonState
            >(
              builder: (context, state) {
                if (state is SupplierGetCancellationReasonLoading) {
                  return const AppLoadingWidget();
                } else if (state is SupplierGetCancellationReasonFailure) {
                  return AppFailureWidget(
                    failure: state.failure,
                    onRetry: _getCancellationDetails,
                  );
                } else if (state is SupplierGetCancellationReasonSuccess) {
                  return RejectedWidget(reason: state.cancelReason);
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
