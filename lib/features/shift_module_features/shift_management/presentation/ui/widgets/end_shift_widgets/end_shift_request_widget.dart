import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../core/routing/app_route_name.dart';
import '../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../core/widgets/app_scaffold.dart';
import '../../arguments/shift_arguments.dart';

class EndShiftRequestWidget extends StatefulWidget {
  const EndShiftRequestWidget({
    super.key,
    required this.withHandOver,
    required this.shiftId,
    this.handoverReceiverName = 'N/A',
    this.shiftArguments,
    required this.isNavigatedFromCashier,
    this.isOpenedFromShiftDetailsScreen = false,
  });

  final bool withHandOver;
  final String shiftId;
  final String handoverReceiverName;
  final ShiftArguments? shiftArguments;
  final bool isNavigatedFromCashier;
  final bool isOpenedFromShiftDetailsScreen;
  @override
  State<EndShiftRequestWidget> createState() => _EndShiftRequestWidgetState();
}

class _EndShiftRequestWidgetState extends State<EndShiftRequestWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.lightBackground,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            150.verticalSpace,

            Text(
              widget.withHandOver
                  ? context.tr.shiftEnded
                  : context.tr.shiftEndedPendingHandover,
              style: AppStyles.s18W500,
            ),

            20.verticalSpace,

            Text(
              widget.withHandOver
                  ? context.tr.shiftEndedDesc(widget.handoverReceiverName)
                  : context.tr.shiftEndedPendingHandoverDesc,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
              textAlign: TextAlign.center,
            ),

            10.verticalSpace,

            const Spacer(),
            widget.withHandOver
                ? AppButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                    borderRadius: BorderRadius.circular(25.r),
                    onClick: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    enabled: true,
                    text: context.tr.goToDashBoard,
                  )
                : AppButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                    borderRadius: BorderRadius.circular(25.r),
                    onClick: () {
                      if (widget.isOpenedFromShiftDetailsScreen) {
                        NavigationService.I.pop();
                      }
                      NavigationService.I.replaceWithNamed(
                        AppRouteName.handoverScreen,
                        arguments: {
                          'shiftArguments': widget.shiftArguments,
                          'isNavigatedFromCashier':
                              widget.isNavigatedFromCashier,
                        },
                      );
                    },
                    enabled: true,
                    text: context.tr.handOffCashNow,
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
                      'shiftId': widget.shiftId,
                      'isNavigatedFromCashier': widget.isNavigatedFromCashier,
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
    );
  }
}
