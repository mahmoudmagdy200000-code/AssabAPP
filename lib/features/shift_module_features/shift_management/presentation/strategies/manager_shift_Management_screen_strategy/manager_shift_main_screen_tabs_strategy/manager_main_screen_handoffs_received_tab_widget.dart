import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import '../../../ui/widgets/shift_details_widgets/shift_details_container_widget.dart';
import '../manager_shift_handover_card_strategy/manager_shift_handover_card_strategy_factory.dart';
import '../manager_shift_handover_card_strategy/manager_shift_handover_widget_strategy.dart';
import 'manager_main_screen_tab_strategy.dart';

class ManagerMainScreenHandoffsReceivedTabWidget
    extends ManagerMainScreenTabStrategy {
  final CurrentShiftEntity managerShift;

  ManagerMainScreenHandoffsReceivedTabWidget({required this.managerShift});

  @override
  Widget buildTabContent(BuildContext context) {
    ManagerShiftHandoverCardStrategy? strategy;
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocProvider(
            create: (context) => getIt<ApproveAndRejectHandoverCubit>(),
            child: ListView.builder(
              itemCount: managerShift.handover.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                strategy =
                    ManagerShiftHandoverWidgetStrategyFactory.getStrategy(
                      handoverStatus:
                          managerShift.handover[index].handoverStatus,
                      handover: managerShift.handover[index],
                      managerName: context
                          .read<ManagerShiftCubit>()
                          .managerShift
                          .shift
                          .shiftDetails
                          .managerName,
                    );
                return strategy!.buildTabContent(context);
              },
            ),
          ),

          20.verticalSpace,
          ShiftDetailsContainerWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr.openingBalance, style: AppStyles.s14W600),

                12.verticalSpace,

                buildShiftCardRowWidget(
                  context: context,
                  title: context.tr.pettyCash,
                  value: managerShift.shift.finalHandover.pettyCash.toString(),
                  hasSpaceBetweenTitleAndValue: true,
                  firstTitleSvgAsset: AppAssets.cash,
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                ),
                12.verticalSpace,

                buildShiftCardRowWidget(
                  context: context,
                  title: context.tr.lastDeposit,
                  value: managerShift.shift.finalHandover.lastDeposit
                      .toString(),
                  hasSpaceBetweenTitleAndValue: true,
                  firstTitleSvgAsset: AppAssets.clockSvg,
                ),
                12.verticalSpace,

                const CustomDivider(),

                12.verticalSpace,

                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: context.customColor.border,
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Go To Petty Cash'),

                      5.horizontalSpace,
                      AppSvg(
                        assetName:
                            Directionality.of(context) == TextDirection.ltr
                            ? AppAssets.arrowRight
                            : AppAssets.arrowLeft,
                        colorFilter: const ColorFilter.mode(
                          AppColors.sBlack,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
