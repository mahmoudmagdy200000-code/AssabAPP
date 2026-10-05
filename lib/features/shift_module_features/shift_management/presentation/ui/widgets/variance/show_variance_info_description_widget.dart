import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/variance/variance_info_sheet_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';

class ShowVarianceInfoDescriptionWidget extends StatelessWidget {
  const ShowVarianceInfoDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: context.customColor.border),
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 11.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 16.r,
              color: context.theme.primaryColor,
            ),
            8.horizontalSpace,
            Text(
              context.tr.moreInfoAboutVarianceType,
              style: AppStyles.s12W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        AppBottomSheet.showModal(
          context,
          (context) => const VarianceInfoSheetWidget(),
          isScrollControlled: true,
        );
      },
    );
  }
}
