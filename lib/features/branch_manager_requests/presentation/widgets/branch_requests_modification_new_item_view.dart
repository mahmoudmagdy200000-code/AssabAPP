import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/branch_order_modification_response.dart';

class BranchRequestsModificationNewItemView extends StatelessWidget {
  final BranchOrderModificationNewItemResponse modification;

  const BranchRequestsModificationNewItemView({
    super.key,
    required this.modification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.modificationDetails,
                style: AppStyles.s20W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              8.verticalSpace,
              Text(
                context.tr.compareOriginalVsProposal,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              18.verticalSpace,
              modification.status.buildModificationDetailsStatus(
                context,
                modification.cancellation?.toCancelReasonResponse(),
              ),
              13.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppSvg(assetName: AppAssets.edit),
                  5.horizontalSpace,
                  Text(
                    '${context.tr.modifiedOn}: ${DateFormatter.formatDateMDY(DateTime.tryParse(modification.modifiedAt))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(modification.modifiedAt))}',
                    textAlign: TextAlign.center,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
              22.verticalSpace,
              Text(
                context.tr.originalOrder,
                style: AppStyles.s16W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              12.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    Row(
                      children: [
                        PurchaseItemImage(
                          bgColor: context.customColor.reversedTextColor,
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Text(
                            modification.originalOrder.itemName,
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    _buildDiv(context),
                    8.verticalSpace,
                    _buildDetailRow(
                      context,
                      context.tr.requestedQty,
                      modification.originalOrder.requestedQty.toString(),
                    ),
                    8.verticalSpace,
                    _buildDiv(context),
                    8.verticalSpace,
                    _buildDetailRow(
                      context,
                      context.tr.quality,
                      modification.originalOrder.quality.getString(context),
                    ),
                    8.verticalSpace,
                    _buildDiv(context),
                    8.verticalSpace,
                    _buildDetailRow(
                      context,
                      context.tr.price,
                      modification.originalOrder.price.toStringAsFixed(2),
                      showCurrencySymbol: true,
                    ),
                    8.verticalSpace,
                    _buildDiv(context),
                    8.verticalSpace,
                    _buildDetailRow(
                      context,
                      context.tr.totalAmount,
                      modification.originalOrder.totalPrice.toStringAsFixed(2),
                      showCurrencySymbol: true,
                    ),
                  ],
                ),
              ),
              12.verticalSpace,
              Text(
                context.tr.suppliersProposal,
                style: AppStyles.s16W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              12.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
                child: Row(
                  children: [
                    Text(
                      context.tr.type,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    5.horizontalSpace,
                    Expanded(
                      child: Text(
                        context.tr.proposeAlternativeProduct,
                        textAlign: TextAlign.end,
                        style: AppStyles.s14W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    Row(
                      children: [
                        PurchaseItemImage(
                          bgColor: context.customColor.reversedTextColor,
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Text(
                            modification.supplierProposal.itemName,
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    _buildDiv(context),
                    8.verticalSpace,
                    _buildDetailRow(
                      context,
                      context.tr.requestedQty,
                      modification.supplierProposal.proposedQty.toString(),
                    ),
                    8.verticalSpace,
                    _buildDiv(context),
                    8.verticalSpace,
                    _buildDetailRow(
                      context,
                      context.tr.quality,
                      modification.supplierProposal.quality.getString(context),
                    ),
                    8.verticalSpace,
                    _buildDiv(context),
                    8.verticalSpace,
                    _buildDetailRow(
                      context,
                      context.tr.price,
                      modification.supplierProposal.price.toStringAsFixed(2),
                      showCurrencySymbol: true,
                    ),
                    8.verticalSpace,
                    _buildDiv(context),
                    8.verticalSpace,
                    _buildDetailRow(
                      context,
                      context.tr.totalAmount,
                      modification.supplierProposal.totalPrice.toStringAsFixed(
                        2,
                      ),
                      showCurrencySymbol: true,
                    ),
                  ],
                ),
              ),
              12.verticalSpace,
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.modificationNotes,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    3.verticalSpace,
                    Text(
                      modification.modificationNotes,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String title,
    String value, {
    bool showCurrencySymbol = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        if (showCurrencySymbol) const SaudiRiyalSvgWidget(),
        2.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }

  Widget _buildDiv(BuildContext context) {
    return CustomDivider(color: context.customColor.border);
  }
}
