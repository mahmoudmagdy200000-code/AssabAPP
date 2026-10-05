import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';

class ReceiveOrderInspectionViewAddNoteSectionNoVariance
    extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const ReceiveOrderInspectionViewAddNoteSectionNoVariance({
    super.key,
    required this.onChanged,
  });

  @override
  State<ReceiveOrderInspectionViewAddNoteSectionNoVariance> createState() =>
      _ReceiveOrderInspectionViewAddNoteSectionNoVarianceState();
}

class _ReceiveOrderInspectionViewAddNoteSectionNoVarianceState
    extends State<ReceiveOrderInspectionViewAddNoteSectionNoVariance> {
  late final ValueNotifier<bool> _isTapped;

  @override
  void initState() {
    super.initState();

    _isTapped = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _isTapped.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () {
        _isTapped.value = !_isTapped.value;
      },
      child: ValueListenableBuilder(
        valueListenable: _isTapped,
        builder: (context, value, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: value
                ? ContainerCustomTextField(
                    label: context.tr.addNote,
                    isLabelOptional: true,
                    isLabelRequired: false,
                    backgroundColor: context.customColor.reversedTextColor,
                    child: CustomTextField(
                      maxLines: 3,
                      hintText:
                          context.tr.describeTheIssueEgVisibleSpoilageUnusable,
                      onChanged: widget.onChanged,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10.r,
                      horizontal: 12.r,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppSvg(assetName: AppAssets.edit, width: 15.r),
                        3.horizontalSpace,
                        Text(
                          context.tr.addNote,
                          style: AppStyles.s12W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        5.horizontalSpace,
                        Text(
                          context.tr.optional,
                          style: AppStyles.s12W500.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
