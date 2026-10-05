import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class BrandOwnerFinancialReportingShareReportAsMailBottomSheet
    extends StatefulWidget {
  final void Function(String email) onSendReport;

  const BrandOwnerFinancialReportingShareReportAsMailBottomSheet({
    super.key,
    required this.onSendReport,
  });

  @override
  State<BrandOwnerFinancialReportingShareReportAsMailBottomSheet>
  createState() =>
      _BrandOwnerFinancialReportingShareReportAsMailBottomSheetState();
}

class _BrandOwnerFinancialReportingShareReportAsMailBottomSheetState
    extends State<BrandOwnerFinancialReportingShareReportAsMailBottomSheet> {
  late final TextEditingController _emailController;
  bool _isEnable = false;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _emailController.addListener(_validButton);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validButton);
    _emailController.dispose();
    super.dispose();
  }

  void _validButton() {
    final email = _emailController.text.trim();

    final isValidEmail = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    ).hasMatch(email);

    setState(() {
      _isEnable = isValidEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAssetImage(
              image: AppAssets.darkLogo,
              width: 70.r,
              borderRadius: BorderRadius.zero,
            ),
            0.verticalSpace,
            Text(
              S.of(context).shareReport,
              style: AppStyles.s20W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            5.verticalSpace,
            Text(
              S.of(context).enterAnEmailAddressAndWellSendThisSmartBranch,
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            5.verticalSpace,
            const CustomDivider(),
            25.verticalSpace,
            ContainerCustomTextField(
              padding: EdgeInsets.all(15.r),
              borderRadius: BorderRadius.circular(18.r),
              child: CustomTextField(
                controller: _emailController,
                hintText: 'Johndoe@gmail.com',
              ),
            ),
            10.verticalSpace,
            AppButton(
              onClick: () {
                widget.onSendReport(_emailController.text.trim());
              },
              text: S.of(context).sendReportToEmail,
              padding: EdgeInsets.symmetric(vertical: 14.r),
              icon: AppSvg(
                assetName: AppAssets.email,
                width: 16.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              enabled: _isEnable,
            ),
          ],
        ),
      ),
    );
  }
}
