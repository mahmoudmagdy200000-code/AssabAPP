import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/supplier_requests/presentation/widgets/supplier_item_preview_widget.dart';
import 'package:flutter/material.dart';

import '../../shared/models/order_track_response.dart';

class OrderConfirmationDetailsTrackView extends StatelessWidget {
  final OrderTrackResponseOrderConfirmationStage stage;

  const OrderConfirmationDetailsTrackView({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.receiveOrderSummary,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    context
                        .tr
                        .reviewDetailsAboutThisOrdersCompletionConfirmation,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  12.verticalSpace,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.all(10.r),
                    child: Text(
                      context.tr.completedOnDateTime(
                        DateFormatter.formatDateMDY(
                              DateTime.tryParse(
                                stage.receiptDetails.dateTime ?? '',
                              ),
                            ) ??
                            '',
                        DateFormatter.formatTimeHM(
                              DateTime.tryParse(
                                stage.receiptDetails.dateTime ?? '',
                              ),
                            ) ??
                            '',
                      ),
                      textAlign: TextAlign.center,
                      style: AppStyles.s13W500.copyWith(
                        color: context.customColor.text4,
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.inspectionSummary,
                          style: AppStyles.s16W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.reversedTextColor,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.r,
                            vertical: 12.r,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr.receiptSummary,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text6,
                                ),
                              ),
                              5.verticalSpace,
                              _buildRowWidget(
                                context: context,
                                title: context.tr.countItemsReceived(
                                  stage
                                      .receiptDetails
                                      .inspectionSummary
                                      .numberOfItems,
                                ),
                              ),
                              10.verticalSpace,
                              _buildRowWidget(
                                context: context,
                                title: context.tr.countQuantityVariance(
                                  stage
                                      .receiptDetails
                                      .inspectionSummary
                                      .quantityVariance,
                                ),
                              ),
                              10.verticalSpace,
                              _buildRowWidget(
                                context: context,
                                title: context.tr.totalValue,
                                value: stage
                                    .receiptDetails
                                    .inspectionSummary
                                    .totalAmount
                                    .toStringAsFixed(2),
                              ),
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.reversedTextColor,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.r,
                            vertical: 12.r,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    context.tr.deliveryDetails,
                                    style: AppStyles.s14W500.copyWith(
                                      color: context.customColor.text6,
                                    ),
                                  ),
                                  4.horizontalSpace,
                                  Icon(
                                    Icons.error_outline,
                                    size: 16.r,
                                    color: context.customColor.text3,
                                  ),
                                ],
                              ),
                              5.verticalSpace,
                              _buildRowWidget(
                                context: context,
                                title: context.tr.driver,
                                value: stage
                                    .receiptDetails
                                    .inspectionSummary
                                    .driverName,
                              ),
                              10.verticalSpace,
                              _buildRowWidget(
                                context: context,
                                title: context.tr.contactNumber,
                                value: '-',
                              ),
                              10.verticalSpace,
                              _buildRowWidget(
                                context: context,
                                title: context.tr.vehicle,
                                value: stage
                                    .receiptDetails
                                    .inspectionSummary
                                    .vehicleNumber,
                              ),
                              10.verticalSpace,
                              _buildRowWidget(
                                context: context,
                                title: context.tr.arrivalTime,
                                value:
                                    '${DateFormatter.formatDateMDY(DateTime.tryParse(stage.receiptDetails.inspectionSummary.arrivalTime))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(stage.receiptDetails.inspectionSummary.arrivalTime))}',
                              ),
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.goodsInspectionCountTitle(
                                stage.receiptDetails.goodsInspections.length,
                              ),
                              style: AppStyles.s16W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            10.verticalSpace,
                            ListView.builder(
                              itemCount:
                                  stage.receiptDetails.goodsInspections.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return _buildItemCard(
                                  context,
                                  stage.receiptDetails.goodsInspections[index],
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  12.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.document,
                          style: AppStyles.s16W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        12.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.reversedTextColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.r,
                            vertical: 12.r,
                          ),
                          child: _buildRowWidget(
                            context: context,
                            title: context.tr.type,
                            value:
                                stage.receiptDetails.documentType?.typeLabel(
                                  context,
                                ) ??
                                '',
                          ),
                        ),
                        10.verticalSpace,
                        _buildOptionalNoteWidget(context, note: 'stage'),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.financialSummary,
                          style: AppStyles.s16W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        10.verticalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: context.customColor.reversedTextColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.r,
                                vertical: 12.r,
                              ),
                              child: Column(
                                children: [
                                  _buildRowWidget(
                                    context: context,
                                    title: context.tr.supplier,
                                    value: stage
                                        .receiptDetails
                                        .financialSummary
                                        .supplierName,
                                  ),
                                  10.verticalSpace,
                                  _buildRowWidget(
                                    context: context,
                                    title: context.tr.order,
                                    value: stage
                                        .receiptDetails
                                        .financialSummary
                                        .invoiceNumber,
                                  ),
                                  10.verticalSpace,
                                  _buildRowWidget(
                                    context: context,
                                    title: context.tr.value,
                                    value: stage
                                        .receiptDetails
                                        .financialSummary
                                        .totalAmount
                                        .toStringAsFixed(2),
                                  ),
                                ],
                              ),
                            ),
                            10.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                color: context.customColor.reversedTextColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.r,
                                vertical: 12.r,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr.financialDetails,
                                    style: AppStyles.s14W500.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  _buildRowWidget(
                                    context: context,
                                    title: context.tr.amountBeforeTax,
                                    value: stage
                                        .receiptDetails
                                        .financialSummary
                                        .amountBeforeTax
                                        .toStringAsFixed(2),
                                  ),
                                  10.verticalSpace,
                                  _buildRowWidget(
                                    context: context,
                                    title: context.tr.vat15Percent,
                                    value:
                                        (stage
                                                    .receiptDetails
                                                    .financialSummary
                                                    .totalAmount -
                                                stage
                                                    .receiptDetails
                                                    .financialSummary
                                                    .amountBeforeTax)
                                            .toStringAsFixed(2),
                                  ),
                                  10.verticalSpace,
                                  _buildRowWidget(
                                    context: context,
                                    title: context.tr.totalAmount,
                                    value: stage
                                        .receiptDetails
                                        .financialSummary
                                        .totalAmount
                                        .toStringAsFixed(2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    OrderTrackResponseGoodsInspection item,
  ) {
    final unitText = item.unit;

    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      margin: EdgeInsets.only(bottom: 10.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SupplierItemPreviewWidget(
            itemName: item.itemName,
            itemImageUrl: item.itemLogo,
          ),
          5.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.qtyOrdered,
            value: '${item.quantityOrdered} $unitText',
          ),
          10.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.qtyReceived,
            value: '${item.quantityReceived} $unitText',
          ),
          10.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.quality,
            value: item.quality.getString(context),
          ),
          10.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.temperature,
            value: '${item.temperature}°C',
          ),
          10.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.expirationDate,
            value:
                DateFormatter.formatDateMDY(
                  DateTime.tryParse(item.expirationDate),
                ) ??
                item.expirationDate,
          ),
          if (item.itemImage != null) ...[
            12.verticalSpace,
            AppNetworkImage(
              image: item.itemImage?.url ?? '',
              borderRadius: BorderRadius.circular(20.r),
            ),
          ],
          if (item.additionalNote != null &&
              item.additionalNote!.isNotEmpty) ...[
            8.verticalSpace,
            _buildAdditionalNoteWidget(context, item.additionalNote),
          ],
        ],
      ),
    );
  }

  Widget _buildRowWidget({
    required BuildContext context,
    required String title,
    String? value,
    Widget? customValue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        5.horizontalSpace,
        Expanded(
          child:
              customValue ??
              Text(
                value ?? '',
                textAlign: TextAlign.end,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildAdditionalNoteWidget(BuildContext context, String? note) {
    if (note == null || note.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        Text(
          context.tr.additionalNote,
          style: AppStyles.s14W600.copyWith(color: context.customColor.text3),
        ),
        4.verticalSpace,
        Text(
          note,
          style: AppStyles.s14W400.copyWith(color: context.customColor.text1),
        ),
        10.verticalSpace,
      ],
    );
  }

  Widget _buildOptionalNoteWidget(BuildContext context, {String? note}) {
    if (note == null || note.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        Text(
          context.tr.additionalNote,
          style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
        ),
        8.verticalSpace,
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.customColor.reversedTextColor,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
          child: Text(
            note,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
      ],
    );
  }
}
