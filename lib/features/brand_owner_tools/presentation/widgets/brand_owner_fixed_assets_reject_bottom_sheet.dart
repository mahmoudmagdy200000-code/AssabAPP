import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_text_button.dart';

class BrandOwnerFixedAssetsRejectBottomSheet extends StatefulWidget {
  final void Function(String reason) onReject;

  const BrandOwnerFixedAssetsRejectBottomSheet({
    super.key,
    required this.onReject,
  });

  @override
  State<BrandOwnerFixedAssetsRejectBottomSheet> createState() =>
      _BrandOwnerFixedAssetsRejectBottomSheetState();
}

class _BrandOwnerFixedAssetsRejectBottomSheetState
    extends State<BrandOwnerFixedAssetsRejectBottomSheet> {
  late final TextEditingController _reasonController;

  bool _enableRejectButton = false;

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
    setState(() {
      _enableRejectButton = _reasonController.text.trim().isNotEmpty;
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
                    Icon(
                      Icons.close,
                      size: 30.r,
                      color: context.customColor.error,
                    ),
                    10.verticalSpace,
                    Text(
                      'Reject Asset',
                      style: AppStyles.s20W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      'This asset will be excluded from the approval list.\nA note is recommended to explain the reason for rejection.',
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    20.verticalSpace,
                    ContainerCustomTextField(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.r,
                        vertical: 10.r,
                      ),
                      label: 'Reason for rejection',
                      child: CustomTextField(
                        controller: _reasonController,
                        hintText:
                            'Please provide a message or guidance on what needs to be done or enhanced.',
                        maxLines: 5,
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
                    text: context.tr.reject,
                    onClick: () {
                      widget.onReject(_reasonController.text);
                      NavigationService.I.pop();
                    },
                    background: _enableRejectButton
                        ? context.customColor.error
                        : context.customColor.text2,
                    enabled: _enableRejectButton,
                    borderRadius: BorderRadius.circular(15.r),
                    padding: EdgeInsets.symmetric(vertical: 14.r),
                    textColor: _enableRejectButton
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
