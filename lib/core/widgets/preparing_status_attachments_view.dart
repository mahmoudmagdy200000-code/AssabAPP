import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/network_file_preview_widget.dart';
import 'package:flutter/material.dart';

import 'custom_divider.dart';
import 'saudi_riyal_svg_widget.dart';
import '../../shared/models/order_track_response.dart';
import '../../features/purchase/presentation/widgets/purchase_item_image.dart';

class PreparingStatusAttachmentsView extends StatelessWidget {
  final OrderTrackResponsePreparingStage stage;

  const PreparingStatusAttachmentsView({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${context.tr.attachments} (${stage.items.length})',
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            5.verticalSpace,
            Text(
              context.tr.viewAllAttachedQualityCertificates,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            15.verticalSpace,
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: stage.items.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.all(16.r),
                    margin: EdgeInsets.only(bottom: 12.r),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            PurchaseItemImage(
                              bgColor: context.customColor.reversedTextColor,
                              image: stage.items[index].itemLogo,
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: Text(
                                stage.items[index].itemName,
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
                          value:
                              '${stage.items[index].requestedQuantity} ${stage.items[index].unit}',
                        ),
                        8.verticalSpace,
                        _buildDiv(context),
                        8.verticalSpace,
                        _buildDetailRow(
                          context,
                          context.tr.status,
                          customValueWidget: stage.items[index].status
                              .buildStatus(context),
                        ),
                        8.verticalSpace,
                        _buildDiv(context),
                        8.verticalSpace,
                        _buildDetailRow(
                          context,
                          context.tr.quality,
                          value: 'Quality',
                        ),
                        8.verticalSpace,
                        NetworkFilePreviewWidget(
                          attachmentModel:
                              stage.items[index].qualityCertificate,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String title, {
    String? value,
    bool showCurrencySymbol = false,
    Widget? customValueWidget,
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
        customValueWidget ??
            Text(
              value ?? '',
              style: AppStyles.s13W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
      ],
    );
  }

  Widget _buildDiv(BuildContext context) {
    return CustomDivider(color: context.customColor.border);
  }
}
