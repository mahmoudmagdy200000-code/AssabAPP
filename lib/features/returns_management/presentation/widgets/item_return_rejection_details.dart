import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/rejected_widget.dart';
import 'package:assab/features/returns_management/presentation/widgets/item_return_status_widget.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_response.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_padding_widget.dart';

class ItemReturnRejectionDetails extends StatelessWidget {
  final CancelReasonResponse? cancelReason;

  const ItemReturnRejectionDetails({super.key, required this.cancelReason});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.suppliersRejectionReason,
            style: AppStyles.s20W600.copyWith(color: context.customColor.text1),
          ),
          12.verticalSpace,
          ItemReturnStatusWidget(
            status: context.tr.rejectedBySupplier,
            subtitle: context.tr.returnRejected,
            description:
                context.tr.theSupplierHasDeclinedThisReturnRequestYouCanFollow,
            textColor: context.customColor.error,
            borderColor: context.customColor.error,
            widget: RejectedWidget(reason: cancelReason),
          ),
        ],
      ),
    );
  }
}
