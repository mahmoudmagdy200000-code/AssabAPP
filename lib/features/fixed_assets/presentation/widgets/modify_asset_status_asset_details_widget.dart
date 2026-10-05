import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

import '../../data/models/fixed_assets_search_response.dart';

class ModifyAssetStatusAssetDetailsWidget extends StatelessWidget {
  final FixedAssetsSearchItem asset;

  const ModifyAssetStatusAssetDetailsWidget({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.assetDetails,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        16.verticalSpace,
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: context.customColor.reversedTextColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: context.customColor.border),
          ),
          child: Column(
            children: [
              AppNetworkImage(
                image: asset.image,
                height: 150.h,
                borderRadius: BorderRadius.circular(20.r),
              ),
              12.verticalSpace,
              Text(
                '${asset.name} #${asset.code}',
                textAlign: TextAlign.center,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              16.verticalSpace,
              const CustomDivider(),
              16.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.location,
                asset.location.name,
              ),
              12.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.valueText,
                asset.value,
                showCurrency: true,
              ),
              12.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      context.tr.status,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 15.r,
                          color: asset.status.color,
                        ),
                        5.horizontalSpace,
                        Flexible(
                          child: Text(
                            asset.status.label(context),
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              _buildDetailRow(context, context.tr.age, asset.age),
              12.verticalSpace,
              _buildDetailRow(context, context.tr.custody, asset.custody),
              // 12.verticalSpace,
              // _buildDetailRow(context, context.tr.maintenance, '2 months'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? statusColor,
    bool showCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showCurrency) ...[
                const SaudiRiyalSvgWidget(),
                4.horizontalSpace,
              ],
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s14W500.copyWith(
                    color: statusColor ?? context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
