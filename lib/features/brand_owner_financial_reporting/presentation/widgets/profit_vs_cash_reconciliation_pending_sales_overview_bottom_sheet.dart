import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../domain/entities/profit_vs_cash_reconciliation_entity.dart';

class ProfitVsCashReconciliationPendingSalesOverviewBottomSheet
    extends StatelessWidget {
  final PendingSalesEntity data;

  const ProfitVsCashReconciliationPendingSalesOverviewBottomSheet({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final items = data.items;

    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).pendingSalesOverview,
              style: AppStyles.s16W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            5.verticalSpace,
            Text(
              S.of(context).trackAndManageOutstandingSalesForYourStore,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            10.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: context.customColor.text2,
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.all(8.r),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isLast = index == items.length - 1;
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    padding: EdgeInsets.all(10.r),
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 10.r),
                    child: Wrap(
                      runSpacing: 10.r,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.start,
                      children: [
                        AppNetworkImage(
                          image: item.image,
                          width: 40.r,
                          height: 40.r,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        10.horizontalSpace,
                        Text(
                          item.name,
                          style: AppStyles.s13W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        10.horizontalSpace,
                        15.horizontalSpace,
                        const SaudiRiyalSvgWidget(),
                        3.horizontalSpace,
                        Text(
                          item.amount.toStringAsFixed(0),
                          style: AppStyles.s13W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        15.horizontalSpace,
                        Text(
                          item.type,
                          style: AppStyles.s13W400.copyWith(
                            color: context.customColor.text4,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            10.verticalSpace,
            Row(
              children: [
                AppSvg(
                  assetName: AppAssets.search,
                  width: 20.r,
                  colorFilter: ColorFilter.mode(
                    context.customColor.text1,
                    BlendMode.srcIn,
                  ),
                ),
                5.horizontalSpace,
                Flexible(
                  child: Text(
                    S.of(context).reasonForPendingSales,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            ContainerCustomTextField(
              borderColor: Colors.transparent,
              child: Text(
                data.reason,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
            10.verticalSpace,
            Text(
              S.of(context).totalPendingAmounts,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text3,
              ),
            ),
            5.verticalSpace,
            ContainerCustomTextField(
              borderColor: Colors.transparent,
              child: Column(
                children: [
                  Text(
                    S.of(context).totalPending,
                    style: AppStyles.s12W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  5.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SaudiRiyalSvgWidget(),
                      5.horizontalSpace,
                      Text(
                        data.total.toStringAsFixed(0),
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
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
    );
  }
}
