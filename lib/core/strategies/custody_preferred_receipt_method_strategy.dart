import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../enums/custody_preferred_receipt_method.dart';
import '../widgets/app_svg.dart';

abstract class CustodyPreferredReceiptMethodStrategy {
  static CustodyPreferredReceiptMethodStrategy getStrategy(
    CustodyPreferredReceiptMethod receiptMethod,
  ) {
    switch (receiptMethod) {
      case CustodyPreferredReceiptMethod.bankTransfer:
        return BankTransferPreferredReceiptMethodStrategy();
      case CustodyPreferredReceiptMethod.cashHandover:
        return CashHandoverPreferredReceiptMethodStrategy();
    }
  }

  Widget buildTopDetailsWidgetBrandOwner(BuildContext context);

  Widget buildPaymentSummaryDetailsWidgetBrandOwner(BuildContext context);
}

Widget _buildRow(
  BuildContext context,
  String assetName,
  String title,
  String value, {
  bool isCurrency = false,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppSvg(
              assetName: assetName,
              width: 15.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text3,
                BlendMode.srcIn,
              ),
            ),
            5.horizontalSpace,
            Flexible(
              child: Text(
                title,
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ),
          ],
        ),
      ),
      5.horizontalSpace,
      Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isCurrency) const SaudiRiyalSvgWidget(),
            Flexible(
              child: Text(
                value,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text1,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class BankTransferPreferredReceiptMethodStrategy
    extends CustodyPreferredReceiptMethodStrategy {
  @override
  Widget buildTopDetailsWidgetBrandOwner(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.customColor.text2,
          ),
          padding: EdgeInsets.all(16.r),
          child: AppSvg(
            assetName: AppAssets.bankSvg,
            width: 15.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
        ),
        10.verticalSpace,
        Text(
          'Bank Transfer Details',
          style: AppStyles.s20W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }

  @override
  Widget buildPaymentSummaryDetailsWidgetBrandOwner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: AppStyles.s20W500.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context,
            AppAssets.cash,
            context.tr.amount,
            '250',
            isCurrency: true,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context,
            AppAssets.bankSvg,
            context.tr.paymentMethod,
            'Bank Transfer',
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context,
            AppAssets.receipt,
            context.tr.purposeOfTransfer,
            'Cash Handover to increase branch’s custody balance',
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(context, AppAssets.personSvg, 'Action By', '250'),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context,
            AppAssets.calendar,
            context.tr.transferDate,
            'June 11, 2025',
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context,
            AppAssets.timer,
            context.tr.transferTime,
            '11:31 AM',
          ),
        ],
      ),
    );
  }
}

class CashHandoverPreferredReceiptMethodStrategy
    extends CustodyPreferredReceiptMethodStrategy {
  @override
  Widget buildTopDetailsWidgetBrandOwner(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.customColor.text2,
          ),
          padding: EdgeInsets.all(16.r),
          child: AppSvg(
            assetName: AppAssets.cashHandoverSvg,
            width: 15.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
        ),
        10.verticalSpace,
        Text(
          'Cash Handover Details',
          style: AppStyles.s20W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }

  @override
  Widget buildPaymentSummaryDetailsWidgetBrandOwner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: AppStyles.s20W500.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context,
            AppAssets.cash,
            context.tr.amount,
            '250',
            isCurrency: true,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context,
            AppAssets.cashHandoverSvg,
            context.tr.paymentMethod,
            'Cash Handover',
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(context, AppAssets.personSvg, 'Action By', '250'),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context,
            AppAssets.calendar,
            context.tr.handoverDate,
            'June 11, 2025',
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context,
            AppAssets.timer,
            context.tr.handoverTime,
            '11:31 AM',
          ),
        ],
      ),
    );
  }
}
