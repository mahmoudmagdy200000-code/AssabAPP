import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_svg.dart';
import '../../../../domain/entity/shift/shift_entity.dart';

class ShiftsEmptyWidget extends StatelessWidget {
  final ShiftStatus status;
  final ShiftEntity? nextShift;
  const ShiftsEmptyWidget({super.key, required this.status, this.nextShift});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          50.verticalSpace,
          AppSvg(assetName: status.icon, height: 100.h),

          25.verticalSpace,

          Text(status.title, style: AppStyles.s16W600),

          10.verticalSpace,

          Text(
            status.desc,
            style: AppStyles.s16W400.copyWith(color: context.customColor.text3),
          ),

          // there is no more (next Shift) from the Back-End
          // const Spacer(),
          // if (status.type == ShiftStatusType.inProgress && nextShift != null)
          //   AppPaddingWidget(
          //     top: 0,
          //     bottom: 10.h,
          //     left: 10.w,
          //     right: 10.w,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           nextShift!.timeDifferenceMessage,
          //           style: AppStyles.s14W400,
          //         ),
          //         10.verticalSpace,
          //
          //         ShiftCardFactory.getStrategy(
          //           nextShift!.status,
          //           status
          //         ).buildCard(context, nextShift!),
          //         10.verticalSpace,
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
}
