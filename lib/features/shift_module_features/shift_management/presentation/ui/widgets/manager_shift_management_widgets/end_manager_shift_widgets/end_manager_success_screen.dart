import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/end_shift_response_entites/manager_shift_end_data_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../../core/widgets/app_button.dart';
import 'end_manager_shift_bottom_modal_sheet_widget.dart';

class EndAndUpdateManagerSuccessScreen extends StatefulWidget {
  const EndAndUpdateManagerSuccessScreen({
    super.key,
    required this.title,
    required this.subTitle,
    required this.managerShift,
  });

  final ManagerShiftEndDataEntity? managerShift;
  final String title;
  final String subTitle;
  @override
  State<EndAndUpdateManagerSuccessScreen> createState() =>
      _EndAndUpdateManagerSuccessScreenState();
}

class _EndAndUpdateManagerSuccessScreenState
    extends State<EndAndUpdateManagerSuccessScreen> {
  @override
  void initState() {
    context.read<ManagerShiftCubit>().getCurrentShift();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            150.verticalSpace,
            Text(widget.title, style: AppStyles.s18W500),

            20.verticalSpace,

            Text(
              widget.subTitle,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text4,
              ),
              textAlign: TextAlign.center,
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
                NavigationService.I.replaceWith(
                  MaterialPageRoute(
                    builder: (context) => EndManagerShiftBottomModalSheetWidget(
                      managerShift: widget.managerShift!,
                    ),
                  ),
                );
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
