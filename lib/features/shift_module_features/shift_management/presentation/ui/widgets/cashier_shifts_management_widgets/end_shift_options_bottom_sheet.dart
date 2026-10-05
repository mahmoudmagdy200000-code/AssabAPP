import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/in_progress_shift_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/di/dependency_injection.dart';
import '../../../../../../../core/enums/shift_status/end_shift_options.dart';
import '../../../../../../../core/routing/app_route_name.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../logic/shifts/shift_details/handover_option/end_shift_option_cubit.dart';
import '../shift_details_widgets/shift_progress_indicator_widget.dart';

class EndShiftOptionsBottomSheet extends StatelessWidget {
  final bool hasEnded;
  final ShiftEntity? shift;
  final String? shiftId;
  final bool isCashierUserType;
  final bool isOpenedFromShiftDetailsScreen;
  final Function() onSuccessEndedOrReassigned;

  const EndShiftOptionsBottomSheet({
    super.key,
    required this.hasEnded,
    this.shift,
    this.shiftId,
    this.isCashierUserType = false,
    required this.onSuccessEndedOrReassigned,
    this.isOpenedFromShiftDetailsScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EndShiftOptionCubit>(),
      child: BlocBuilder<EndShiftOptionCubit, EndShiftOptionState>(
        builder: (context, state) {
          return Container(
            height: 550.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr.end_shift, style: AppStyles.s18W600),
                10.verticalSpace,
                Text(
                  context.tr.endShiftOptionDesc,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text4,
                  ),
                ),

                EndShiftOptionWidget(
                  isSelected:
                      state.selectedOption == EndShiftOption.withoutHandover,
                  assetName: AppAssets.noShiftsFoundSvg,
                  title: context.tr.endShiftOnly,
                  desc: context.tr.endShiftOnlyDesc,
                  onTap: () {
                    context.read<EndShiftOptionCubit>().selectWithoutHandover();
                  },
                ),
                15.verticalSpace,
                EndShiftOptionWidget(
                  isSelected:
                      state.selectedOption == EndShiftOption.withHandover,
                  assetName: AppAssets.endShiftWithHandover,
                  title: context.tr.endShiftAndHandover,
                  desc: context.tr.endShiftAndHandoverDesc,
                  onTap: () {
                    context.read<EndShiftOptionCubit>().selectWithHandover();
                  },
                ),

                const Spacer(),

                AppButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                  enabled: state.selectedOption != null,
                  isTransparent: state.selectedOption == null,
                  onClick: () async {
                    if (hasEnded) {
                      late final Object? result; // bool
                      if (state.selectedOption ==
                          EndShiftOption.withoutHandover) {
                        // NavigationService.I.pop();

                        NavigationService.I.pop();
                        result = await NavigationService.I.pushNamed(
                          AppRouteName.endShiftScreen,
                          arguments: {
                            'shiftId': isCashierUserType ? shiftId : shift!.id,
                            'isNavigatedFromCashier': isCashierUserType,
                            'isOpenedFromShiftDetailsScreen':
                                isOpenedFromShiftDetailsScreen,
                          },
                        );
                      } else {
                        NavigationService.I.pop();
                        result = await NavigationService.I.pushNamed(
                          AppRouteName.endShiftWithHandoverScreen,
                          arguments: {
                            'shiftId': isCashierUserType ? shiftId : shift!.id,
                            'isNavigatedFromCashier': isCashierUserType,
                            'isOpenedFromShiftDetailsScreen':
                                isOpenedFromShiftDetailsScreen,
                          },
                        );
                      }

                      if (result == true) {
                        await Future.delayed(
                          const Duration(milliseconds: 1500),
                        );
                        onSuccessEndedOrReassigned();
                      }
                    } else {
                      NavigationService.I.pop();

                      await AppBottomSheet.showModal(context, isScrollControlled: true, (
                        context,
                      ) {
                        return Container(
                          height: 550.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 20.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr.endShiftEarly,
                                style: AppStyles.s18W600,
                              ),
                              10.verticalSpace,
                              Text(
                                context.tr.endShiftEarlyDesc,
                                style: AppStyles.s14W400.copyWith(
                                  color: context.customColor.text4,
                                ),
                              ),

                              10.verticalSpace,
                              RichText(
                                text: TextSpan(
                                  style: AppStyles.s14W400.copyWith(
                                    color: context.customColor.text4,
                                  ),
                                  children: [
                                    TextSpan(text: context.tr.youCanEither),

                                    TextSpan(
                                      text: context.tr.reassignToAnother,
                                      style: AppStyles.s14W600,
                                    ),

                                    TextSpan(text: context.tr.orEndItNow),
                                  ],
                                ),
                              ),

                              10.verticalSpace,
                              SizedBox(
                                height: 70.h,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 5.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.yellow,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                    ),
                                    8.horizontalSpace,

                                    SizedBox(
                                      width: 260.w,
                                      child: Text(
                                        context
                                            .tr
                                            .ifYouChooseToEndTheShiftWillBeCompleted,
                                        style: AppStyles.s14W400.copyWith(
                                          color: context.customColor.text4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              15.verticalSpace,

                              ShiftProgressIndicator(
                                startTime:
                                    shift?.shiftTimeDetails.startTime ??
                                    '00:00',
                                endTime:
                                    shift?.shiftTimeDetails.endTime ?? '00:00',
                                actualStart: shift?.actualStartTime,
                                actualEnd: shift?.actualEndTime,
                              ),

                              const Spacer(),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 150.w,
                                    child: AppButton(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 15.h,
                                      ),
                                      enabled: true,
                                      isTransparent: true,
                                      textColor: AppColors.red,
                                      onClick: () async {
                                        late final Object? result;
                                        if (state.selectedOption ==
                                            EndShiftOption.withoutHandover) {
                                          NavigationService.I.pop();
                                          result = await NavigationService.I.pushNamed(
                                            AppRouteName.endShiftScreen,
                                            arguments: {
                                              'shiftId': isCashierUserType
                                                  ? shiftId
                                                  : shift!.id,
                                              'isNavigatedFromCashier':
                                                  isCashierUserType,
                                              'isOpenedFromShiftDetailsScreen':
                                                  isOpenedFromShiftDetailsScreen,
                                            },
                                          );

                                          // NavigationService.I.pop(result);
                                        } else {
                                          NavigationService.I.pop();
                                          result = await NavigationService.I.pushNamed(
                                            AppRouteName
                                                .endShiftWithHandoverScreen,
                                            arguments: {
                                              'shiftId': isCashierUserType
                                                  ? shiftId
                                                  : shift!.id,
                                              'isNavigatedFromCashier':
                                                  isCashierUserType,
                                              'isOpenedFromShiftDetailsScreen':
                                                  isOpenedFromShiftDetailsScreen,
                                            },
                                          );

                                          // NavigationService.I.pop(result);
                                        }

                                        if (result == true) {
                                          await Future.delayed(
                                            const Duration(milliseconds: 1500),
                                          );

                                          onSuccessEndedOrReassigned();
                                        }
                                      },
                                      text: context.tr.end_shift,
                                    ),
                                  ),

                                  // 10.horizontalSpace,
                                  SizedBox(
                                    width: 150.w,
                                    child: AppButton(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 15.h,
                                      ),
                                      enabled: true,

                                      onClick: () async {
                                        late final Object? result;

                                        if (state.selectedOption ==
                                            EndShiftOption.withoutHandover) {
                                          NavigationService.I.pop();
                                          result = await NavigationService.I.pushNamed(
                                            AppRouteName
                                                .reassignShiftWithoutHandoverScreen,
                                            arguments: {
                                              'shift': shift,
                                              'previousCashier': shift!.cashier,
                                              'nextCashier': shift!.nextCashier,
                                              'isOpenedFromShiftDetailsScreen':
                                                  isOpenedFromShiftDetailsScreen,
                                            },
                                          );

                                          // NavigationService.I.pop(result);
                                        } else {
                                          NavigationService.I.pop();
                                          result = await NavigationService.I.pushNamed(
                                            AppRouteName
                                                .reassignShiftWithHandoverScreen,
                                            arguments: {
                                              'shift': shift,
                                              'previousCashier': shift!.cashier,
                                              'nextCashier': shift!.nextCashier,
                                              'isOpenedFromShiftDetailsScreen':
                                                  isOpenedFromShiftDetailsScreen,
                                            },
                                          );

                                          // NavigationService.I.pop(result);
                                        }

                                        if (result == true) {
                                          await Future.delayed(
                                            const Duration(milliseconds: 1500),
                                          );
                                          onSuccessEndedOrReassigned();
                                        }
                                      },
                                      text: context.tr.reassign_shift,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                    }
                  },
                  text: state.selectedOption != null
                      ? state.selectedOption == EndShiftOption.withoutHandover
                            ? context.tr.endShiftOnly
                            : context.tr.endShiftAndHandover
                      : context.tr.procced,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
