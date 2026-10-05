import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../../domain/entity/cashier_entity.dart';
import '../../../logic/choose_employee/choose_employee_cubit.dart';

class SelectedResponsibleEmployeeWidget extends StatelessWidget {
  final CashierEntity cashier;
  final int index;
  final int length;
  final bool removeIcon;
  final double? varianceAmount;
  const SelectedResponsibleEmployeeWidget({
    super.key,
    required this.cashier,
    required this.index,
    required this.length,
    this.varianceAmount,
    this.removeIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          key: ValueKey('responsible_employee_${cashier.name}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSvg(assetName: AppAssets.noProfile, width: 40.w),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cashier.name,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    cashier.branch.name,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  4.verticalSpace,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: context.customColor.border),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      children: [
                        varianceAmount != null
                            ? Expanded(
                                child: Text(
                                  varianceAmount.toString(),
                                  style: AppStyles.s14W400.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              )
                            : Expanded(
                                child:
                                    BlocSelector<
                                      ValidationCubit,
                                      ValidationState,
                                      String
                                    >(
                                      selector: (state) =>
                                          state.fieldsValue[cashier.id
                                              .toString()] ??
                                          '',
                                      builder: (context, state) {
                                        return Text(
                                          state,
                                          style: AppStyles.s14W400.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        );
                                      },
                                    ),
                              ),
                        10.horizontalSpace,
                        const SaudiRiyalSvgWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (removeIcon)
              AppGestureDetectorButton(
                child: AppSvg(assetName: AppAssets.trashSvg, width: 16.w),
                onTap: () {
                  context.read<ChooseEmployeeCubit>().removeEmployee(cashier);
                  context.read<ValidationCubit>().removeDynamicFields({
                    cashier.id.toString(),
                  });
                },
              ),
          ],
        ),
        if (index != length - 1) 15.verticalSpace,
      ],
    );
  }
}
