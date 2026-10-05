import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../generated/l10n.dart';
import 'brand_owner_financial_reporting_share_report_as_mail_bottom_sheet.dart';

class BrandOwnerFinancialReportingExportsButtons extends StatelessWidget {
  final VoidCallback pdf;
  final VoidCallback? excel;
  final void Function(String email) email;
  final bool showExcel;
  final bool showText;

  const BrandOwnerFinancialReportingExportsButtons({
    super.key,
    required this.pdf,
    this.excel,
    required this.email,
    this.showExcel = true,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showText) ...[
          Text(
            S.of(context).exportLevel2ReportAs,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
          5.verticalSpace,
        ],
        Row(
          children: [
            Expanded(
              child: ButtonTextIcon(
                onTap: () {
                  pdf();
                },
                label: 'PDF',
                icon: AppSvg(assetName: AppAssets.pdfSvg, width: 23.r),
                backgroundColor: context.customColor.text2,
                borderRadius: BorderRadius.circular(12.r),
                isFlexible: true,
                padding: EdgeInsets.all(12.r),
              ),
            ),
            if (showExcel) ...[
              12.horizontalSpace,
              Expanded(
                child: ButtonTextIcon(
                  onTap: () {
                    excel?.call();
                  },
                  label: 'EXCEL',
                  icon: AppSvg(assetName: AppAssets.excelSvg, width: 23.r),
                  backgroundColor: context.customColor.text2,
                  borderRadius: BorderRadius.circular(12.r),
                  isFlexible: true,
                  padding: EdgeInsets.all(12.r),
                ),
              ),
            ],
            12.horizontalSpace,
            Expanded(
              child: ButtonTextIcon(
                onTap: () {
                  AppBottomSheet.customPageRoute(
                    context,
                    (context) =>
                        BrandOwnerFinancialReportingShareReportAsMailBottomSheet(
                          onSendReport: (email) {
                            this.email(email);
                          },
                        ),
                  );
                },
                label: S.of(context).viaEmail,
                icon: AppSvg(assetName: AppAssets.email, width: 16.r),
                backgroundColor: context.customColor.reversedTextColor,
                borderColor: context.theme.primaryColor,
                textColor: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(12.r),
                isFlexible: true,
                padding: EdgeInsets.all(12.r),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
