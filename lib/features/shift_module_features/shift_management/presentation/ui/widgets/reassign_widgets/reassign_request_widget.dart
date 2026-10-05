import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_asset_image.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../core/widgets/app_scaffold.dart';

class ReassignRequestWidget extends StatefulWidget {
  const ReassignRequestWidget({
    super.key,
    required this.shift,
    this.isOpenedFromShiftDetailsScreen = false,
  });

  final bool isOpenedFromShiftDetailsScreen;
  final ShiftEntity shift;
  @override
  State<ReassignRequestWidget> createState() => _ReassignRequestWidgetState();
}

class _ReassignRequestWidgetState extends State<ReassignRequestWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      left: 15.w,
      right: 15.w,
      child: AppScaffold(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              70.verticalSpace,

              AppAssetImage(
                image: AppAssets.shiftReassignedPng,
                width: 220.w,
                height: 160.h,
              ),

              20.verticalSpace,

              Text(context.tr.shiftReassigned, style: AppStyles.s17W500),

              10.verticalSpace,

              SizedBox(
                width: 350.w,
                child: Text(
                  context.tr.shiftReassignedDesc,
                  style: AppStyles.s13W400,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              AppButton(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                borderRadius: BorderRadius.circular(25.r),
                onClick: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                enabled: true,
                text: context.tr.goToDashBoard,
              ),
              15.verticalSpace,

              AppButton(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                borderRadius: BorderRadius.circular(25.r),
                isTransparent: true,
                onClick: () {
                  if (widget.isOpenedFromShiftDetailsScreen) {
                    NavigationService.I.pop();
                  } else {
                    NavigationService.I.replaceWithNamed(
                      AppRouteName.shiftDetailsScreen,
                      arguments: {
                        'shiftId': widget.shift.id,
                        'isNavigatedFromCashier': false,
                      },
                    );
                  }
                },
                enabled: true,
                text: context.tr.seeDetails,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
