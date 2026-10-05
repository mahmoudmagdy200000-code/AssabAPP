import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/cashier_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../core/widgets/app_svg.dart';
import 'cashier_profile_bottom_sheet.dart';

class CashierShiftsAppBar extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool showInfoButton;
  final bool showBackButton;
  final String? imageUrl;
  final CashierEntity? cashier;

  const CashierShiftsAppBar({
    super.key,
    required this.title,
    required this.subTitle,
    this.showInfoButton = false,
    this.showBackButton = true,
    this.cashier,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          if (showBackButton) const AppBackButton(),
          SizedBox(
            width: showInfoButton ? 200.w : 300.w,
            child: ListTile(
              title: Text(
                title,
                style: AppStyles.s16W600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                subTitle,
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text4,
                ),
              ),
            ),
          ),
          if (showInfoButton) ...[
            const Spacer(),
            AppGestureDetectorButton(
              onTap: () {
                AppBottomSheet.showModal(context, isScrollControlled: true, (
                  context,
                ) {
                  return BlocProvider(
                    create: (context) => ValidationCubit(
                      requiredFields: {'email', 'cashierName'},
                    ),
                    child: CashierProfileBottomSheet(
                      createdByName: cashier!.createdByName ?? 'N/A',
                      formattedCreatedAt:
                          cashier!.formattedCreatedAt ?? '00:00',
                      cashierId: cashier!.id,
                    ),
                  );
                });
              },
              child: Container(
                padding: EdgeInsetsGeometry.all(3.w),
                decoration: BoxDecoration(
                  color: context.theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40.w,
                      height: 30.h,
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl!,
                              errorBuilder: (context, error, stackTrace) {
                                return const AppSvg(
                                  assetName: AppAssets.noProfile,
                                );
                              },
                            )
                          : const AppSvg(assetName: AppAssets.noProfile),
                    ),

                    5.horizontalSpace,

                    Text(context.tr.info, style: AppStyles.s12W400),
                    2.horizontalSpace,
                    Icon(Icons.keyboard_arrow_down, size: 20.r),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
