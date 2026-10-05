import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/network_file_preview_widget.dart';
import 'package:assab/features/supplier_requests/presentation/widgets/supplier_item_preview_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/return_goods_details_response.dart';

class ItemReturnDetailsDetailsView extends StatelessWidget {
  final ReturnGoodsDetailsResponse returnDetails;

  const ItemReturnDetailsDetailsView({super.key, required this.returnDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              returnDetails.data.status
                  .buildStatusDetailsWidget(context, returnDetails.data)
                  .sliverBoxAdapter,
              10.verticalSpace.sliverBoxAdapter,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.returnRequestSummary,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    10.verticalSpace,
                    const CustomDivider(),
                    10.verticalSpace,
                    _buildRowWidget(
                      context: context,
                      title: context.tr.supplier,
                      value: returnDetails.data.supplier.name,
                    ),
                    10.verticalSpace,
                    const CustomDivider(),
                    10.verticalSpace,
                    _buildRowWidget(
                      context: context,
                      title: context.tr.relatedOrder,
                      value: '#${returnDetails.data.purchaseOrder.orderNumber}',
                    ),
                    10.verticalSpace,
                    const CustomDivider(),
                    10.verticalSpace,
                    _buildRowWidget(
                      context: context,
                      title: context.tr.totalReturnValue,
                      value: returnDetails.data.totalReturnAmount.toString(),
                      showCurrencyIcon: true,
                    ),
                    10.verticalSpace,
                    const CustomDivider(),
                    10.verticalSpace,
                    _buildRowWidget(
                      context: context,
                      title: context.tr.returnDate,
                      value:
                          DateFormatter.formatDateMDY(
                            returnDetails.data.returnDate,
                          ) ??
                          '',
                    ),
                    10.verticalSpace,
                    const CustomDivider(),
                    10.verticalSpace,
                    _buildRowWidget(
                      context: context,
                      title: context.tr.returnNumber,
                      value: returnDetails.data.returnNumber,
                    ),
                    if (returnDetails.data.additionalNotes != null) ...[
                      10.verticalSpace,
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: context.customColor.border),
                        ),
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.additionalNote,
                              style: AppStyles.s14W600.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              returnDetails.data.additionalNotes ?? '',
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ).sliverBoxAdapter,
              12.verticalSpace.sliverBoxAdapter,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.requiredAction,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.tr.cashRefund,
                            textAlign: TextAlign.center,
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (returnDetails.data.additionalNotes != null) ...[
                      20.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.additionalNote,
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          10.verticalSpace,
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                            ),
                            padding: EdgeInsets.all(16.r),
                            child: Text(
                              returnDetails.data.additionalNotes ?? '',
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ).sliverBoxAdapter,
              12.verticalSpace.sliverBoxAdapter,
              Text(
                context.tr.itemsCount(returnDetails.data.items.length),
                style: AppStyles.s14W600.copyWith(
                  color: context.customColor.text1,
                ),
              ).sliverBoxAdapter,
              8.verticalSpace.sliverBoxAdapter,
              SliverList.builder(
                itemCount: returnDetails.data.items.length,
                itemBuilder: (context, index) {
                  final item = returnDetails.data.items[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 12.r,
                    ),
                    margin: EdgeInsets.only(bottom: 4.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SupplierItemPreviewWidget(itemName: item.itemName),
                        CustomDivider(color: context.customColor.border),
                        10.verticalSpace,
                        _buildRowWidget(
                          context: context,
                          title: context.tr.returnQuantity,
                          value: item.returnQuantity.toString(),
                        ),
                        10.verticalSpace,
                        CustomDivider(color: context.customColor.border),
                        10.verticalSpace,
                        _buildRowWidget(
                          context: context,
                          title: context.tr.reasonQuality,
                          value: item.qualityReason,
                        ),
                        10.verticalSpace,
                        CustomDivider(color: context.customColor.border),
                        10.verticalSpace,
                        _buildRowWidget(
                          context: context,
                          title: context.tr.value,
                          value: item.unitPrice.toString(),
                          showCurrencyIcon: true,
                        ),
                        10.verticalSpace,
                        CustomDivider(color: context.customColor.border),
                        10.verticalSpace,
                        Text(
                          context.tr.attachedEvidences,
                          style: AppStyles.s12W500.copyWith(
                            color: context.customColor.text4,
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.reversedTextColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.r,
                            vertical: 12.r,
                          ),
                          child: ListView.builder(
                            itemCount: item.files.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  NetworkFilePreviewWidget(
                                    attachmentModel: item.files[index],
                                    withBorder: false,
                                  ),
                                  if (index < 1) ...[
                                    6.verticalSpace,
                                    const CustomDivider(),
                                    6.verticalSpace,
                                  ],
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        returnDetails.data.status.buildButtonsSection(
          context,
          returnDetails.data.id,
        ),
      ],
    );
  }

  Widget _buildRowWidget({
    required BuildContext context,
    required String title,
    required String value,
    bool showCurrencyIcon = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (showCurrencyIcon) const SaudiRiyalSvgWidget(),
            Text(
              value,
              textAlign: TextAlign.end,
              style: AppStyles.s13W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
