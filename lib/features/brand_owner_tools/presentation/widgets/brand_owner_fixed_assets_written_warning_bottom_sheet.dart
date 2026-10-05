import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_text_button.dart';

class BrandOwnerFixedAssetsWrittenWarningBottomSheet extends StatefulWidget {
  final void Function(String reason) onWarning;
  final String senderName;

  const BrandOwnerFixedAssetsWrittenWarningBottomSheet({
    super.key,
    required this.onWarning,
    required this.senderName,
  });

  @override
  State<BrandOwnerFixedAssetsWrittenWarningBottomSheet> createState() =>
      _BrandOwnerFixedAssetsWrittenWarningBottomSheetState();
}

class _BrandOwnerFixedAssetsWrittenWarningBottomSheetState
    extends State<BrandOwnerFixedAssetsWrittenWarningBottomSheet> {
  late final TextEditingController _reasonController;

  bool _enableReason = false;

  @override
  void initState() {
    super.initState();

    _reasonController = TextEditingController();
    _reasonController.addListener(_listenToReasonChanges);
  }

  @override
  void dispose() {
    _reasonController.removeListener(_listenToReasonChanges);
    _reasonController.dispose();
    super.dispose();
  }

  void _listenToReasonChanges() {
    _reasonController.addListener(() {
      setState(() {
        _enableReason = _reasonController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Written Warning',
                      style: AppStyles.s20W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      'You’re about to approve this discrepancy.\nYou can update the note below before finalizing your decision.',
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    20.verticalSpace,
                    ContainerCustomTextField(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.r,
                        vertical: 10.r,
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                      backgroundColor: Colors.transparent,
                      child: Row(
                        children: [
                          const ProfileImageWidget(),
                          10.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Branch Manager: ${widget.senderName}',
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                                Text(
                                  'Responsible for discrepancy',
                                  style: AppStyles.s12W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    const CustomDivider(),
                    20.verticalSpace,
                    ContainerCustomTextField(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.r,
                        vertical: 10.r,
                      ),
                      label: 'Warning Message',
                      borderRadius: BorderRadius.circular(10.r),
                      child: CustomTextField(
                        controller: _reasonController,
                        keyboardType: TextInputType.multiline,
                        hintText:
                            'Please provide a message or guidance on what needs to be done or enhanced.',
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            Row(
              spacing: 10.w,
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.cancel,
                    onTap: () {
                      NavigationService.I.pop();
                    },
                    backgroundColor: Colors.transparent,
                    borderRadius: 15.r,
                    padding: EdgeInsets.symmetric(vertical: 14.r),
                    textColor: context.customColor.text1,
                  ),
                ),
                Expanded(
                  child: AppButton(
                    text: 'Apply Decision',
                    onClick: () {
                      widget.onWarning(_reasonController.text);
                      NavigationService.I.pop();
                    },
                    background: _enableReason
                        ? context.customColor.error
                        : context.customColor.text2,
                    enabled: _enableReason,
                    borderRadius: BorderRadius.circular(15.r),
                    padding: EdgeInsets.symmetric(vertical: 14.r),
                    textColor: _enableReason
                        ? context.customColor.reversedTextColor
                        : context.customColor.text3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
