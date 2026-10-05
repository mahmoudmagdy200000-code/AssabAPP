import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/purchase_suppliers_response.dart';

class DirectSupplierSummaryViewRequestSummarySection extends StatelessWidget {
  final String totalAmount;
  final PurchaseSuppliersDataSupplier supplier;

  const DirectSupplierSummaryViewRequestSummarySection({
    super.key,
    required this.totalAmount,
    required this.supplier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.requestSummary,
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
            child: Row(
              children: [
                ProfileImageWidget(image: supplier.image),
                12.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.name,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    4.verticalSpace,
                    supplier.status.buildStatusWidget(context),
                  ],
                ),
              ],
            ),
          ),
          8.verticalSpace,
          _buildRequestSummaryRow(context, context.tr.orderNo, '#1236'),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRequestSummaryRow(
            context,
            context.tr.type,
            context.tr.orderViaSupplier,
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRequestSummaryRow(context, context.tr.from, supplier.name),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRequestSummaryRow(
            context,
            context.tr.totalAmount,
            totalAmount,
            showRiyalSymbol: true,
          ),
          8.verticalSpace,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.tr.message,
                        style: AppStyles.s14W600.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    AppSvgButton(
                      assetName: AppAssets.edit,
                      onTap: () {},
                      withBorder: false,
                    ),
                  ],
                ),
                2.verticalSpace,
                Text(
                  'Please confirm within 24  hours',
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool showRiyalSymbol = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        if (showRiyalSymbol) const SaudiRiyalSvgWidget(),
        2.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
