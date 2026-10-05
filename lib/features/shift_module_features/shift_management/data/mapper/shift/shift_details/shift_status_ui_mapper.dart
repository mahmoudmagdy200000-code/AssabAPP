import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/reassignment_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/helpers/shared_preferences_helper.dart';
import '../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../cashier_my_shifts/presentation/formatter/cashier_shift_time_formatter.dart';
import '../../../../../../cashier_requests/presentation/cubits/accept_reassigned_shift/accept_reassigned_shift_cubit.dart';
import '../../../../domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import '../../../../domain/entity/shift/shift_cashier_entity.dart';
import '../../../../presentation/logic/shifts/shift_details/shift_details_cubit.dart';
import '../../../../presentation/ui/widgets/cashier_shifts_management_widgets/end_shift_options_bottom_sheet.dart';
import '../../../../presentation/ui/widgets/shift_details_widgets/accept_reassigned_shift_sheet_widget.dart';

extension ShiftStatusUiMapper on ShiftStatusType {
  String label(BuildContext context, {bool isReassignedToMe = false}) {
    switch (this) {
      case ShiftStatusType.pending:
        return context.tr.not_started;
      case ShiftStatusType.completed:
        return context.tr.completed_name;
      case ShiftStatusType.inProgress:
        return context.tr.in_progress_name;
      case ShiftStatusType.reassigned:
        if (isReassignedToMe) {
          return context.tr.reassigned_to_u;
        }
        return context.tr.shiftReassigned;
      default:
        return '';
    }
  }

  Color cardColor(BuildContext context) {
    switch (this) {
      case ShiftStatusType.pending:
        return AppColors.lightGray;
      default:
        return AppColors.lightBackground;
    }
  }

  Color textColor(BuildContext context) {
    switch (this) {
      case ShiftStatusType.pending:
        return context.customColor.text1;
      case ShiftStatusType.completed:
        return AppColors.darkGreen;
      case ShiftStatusType.inProgress:
        return AppColors.cyan;
      case ShiftStatusType.reassigned:
        return AppColors.dark2Yellow;
      default:
        return context.theme.scaffoldBackgroundColor;
    }
  }

  Widget shiftDetailsAppButton(
    BuildContext context, {
    ShiftEntity? shift,
    required String shiftId,
    bool hasStarted = false,
    ReassignmentEntity? reassignmentEntity,
    ShiftCashierEntity? cashierEntity,
    bool isCashier = false,
  }) {
    switch (this) {
      case ShiftStatusType.pending:
        return AppButton(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          borderRadius: BorderRadius.circular(25.r),
          // isTransparent: true,
          textColor: context.customColor.text2,
          enabled: isCashier ? false : true,
          background: AppColors.primaryLight,
          onClick: () async {
            final result = await NavigationService.I.pushNamed(
              AppRouteName.reassignShiftWithoutHandoverScreen,
              arguments: {
                'shift': shift,
                'previousCashier': shift!.cashier,
                'nextCashier': shift.nextCashier,
                'isOpenedFromShiftDetailsScreen': true,
              },
            );

            if (result == true) {
              context.read<ShiftDetailsCubit>().getShiftDetails();
            }
          },
          text: isCashier ? context.tr.start_shift : context.tr.reassign_shift,
        );

      case ShiftStatusType.completed:
        return AppButton(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          borderRadius: BorderRadius.circular(25.r),
          textColor: context.customColor.text2,
          enabled: false,
          onClick: () {},
          text: context.tr.shiftCompleted,
        );

      case ShiftStatusType.inProgress:
        return AppButton(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          borderRadius: BorderRadius.circular(25.r),
          background: shift!.hasEnded ? AppColors.lightGreen : AppColors.red,
          onClick: () {
            AppBottomSheet.showModal(
              context,
              isScrollControlled: true,
              (sheetContext) => EndShiftOptionsBottomSheet(
                hasEnded: isCashier ? true : shift.hasEnded,
                shift: shift,
                isOpenedFromShiftDetailsScreen: true,
                onSuccessEndedOrReassigned: () {
                  context.read<ShiftDetailsCubit>().getShiftDetails();
                },
              ),
            );
          },
          enabled: isCashier ? shift.hasEnded : true,
          text: context.tr.end_shift,
        );

      case ShiftStatusType.reassigned:
        if (isCashier) {
          if ((shift?.reassignment?.reassignedTo?.id !=
                  getIt<SharedPreferencesHelper>().getString('u_id')) &&
              (shift?.reassignment?.reassignedFrom?.id ==
                  getIt<SharedPreferencesHelper>().getString('u_id'))) {
            // reassigned from me to Another Person
            if (shift?.isMidReassign ?? false) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: AppColors.darkOrange.withAlpha(10),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.darkOrange,
                      size: 20.w,
                    ),
                    10.horizontalSpace,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.shiftReassigned,
                          textAlign: TextAlign.center,
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),

                        Text(
                          context.tr
                              .uCantContinueThisShiftBecauseItHasBeenReassignedToAnother(
                                shift?.reassignedBy ?? context.tr.no_name,
                              ),
                          textAlign: TextAlign.center,
                          style: AppStyles.s13W400.copyWith(
                            color: context.customColor.text4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: AppColors.darkOrange.withAlpha(10),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.darkOrange,
                    size: 20.w,
                  ),
                  10.horizontalSpace,

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.uCantTakeThisShift,
                        textAlign: TextAlign.center,
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),

                      Text(
                        context.tr.itIsBeenReassignedByTheBranchManager(
                          shift?.reassignedBy ?? context.tr.no_name,
                        ),
                        textAlign: TextAlign.center,
                        style: AppStyles.s13W400.copyWith(
                          color: context.customColor.text4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          if ((shift?.isShiftReassignedToMe ?? false)) {
            // the Shift Is Reassigned to me
            return Column(
              children: [
                if (shift?.actualStartTime?.isNotEmpty ?? false)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkOrange.withAlpha(10),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.darkOrange,
                          size: 20.w,
                        ),
                        10.horizontalSpace,

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.inProgress,
                              textAlign: TextAlign.center,
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),

                            Text(
                              context.tr.reassignedToYouWhileShiftIsActive,
                              textAlign: TextAlign.center,
                              style: AppStyles.s13W400.copyWith(
                                color: context.customColor.text4,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                15.verticalSpace,
                AppButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                  borderRadius: BorderRadius.circular(25.r),
                  onClick: () {
                    final cubit = context.read<ShiftDetailsCubit>();

                    AppBottomSheet.showModal(context, (context) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) =>
                                getIt<AcceptReassignedShiftCubit>(),
                          ),
                          BlocProvider.value(value: cubit),
                        ],
                        child: AcceptReassignedShiftSheetWidget(
                          shiftId: shift!.id,
                          shiftDate: shift.shiftDate,
                          reassignedFrom: shift.cashier.name,
                          startTime: CashierShiftTimeFormatter.format(
                            shift.shiftTimeDetails.endTime,
                          ),
                          endTime: CashierShiftTimeFormatter.format(
                            shift.shiftTimeDetails.endTime,
                          ),
                          nextCashierName:
                              shift.nextCashier?.name ?? context.tr.no_name,
                          reassignedBy:
                              reassignmentEntity?.reassignedBy?.name ??
                              context.tr.no_name,
                          cashGiven: (shift.cashGiven ?? 0).toString(),
                          variance: (shift.variance ?? 0).toString(),
                        ),
                      );
                    }, isScrollControlled: true);
                  },
                  enabled: true,
                  text: context.tr.accept,
                ),
              ],
            );
          }
        }

        return Container(
          // the shift is reassigned from a person to another person and I'm not one of them ---- or I'm the manager
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: AppColors.darkOrange.withAlpha(10),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.darkOrange,
                size: 20.w,
              ),
              10.horizontalSpace,

              Expanded(
                child: Text(
                  reassignmentEntity?.reassignedBy?.id == cashierEntity!.id
                      ? context.tr.reassigned_by_u
                      : context.tr.reassigned_by_another_cashier(
                          reassignmentEntity?.reassignedBy?.name ??
                              context.tr.no_name,
                        ),
                  textAlign: TextAlign.center,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text4,
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return AppButton(onClick: () {}, text: 'see_details');
    }
  }

  Widget managerShiftCardButton(
    BuildContext context, {
    bool hasEnded = false,
    required CurrentShiftEntity currentManagerShift,
  }) {
    switch (this) {
      case ShiftStatusType.pending:
        return AppButton(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          borderRadius: BorderRadius.circular(25.r),
          textColor: context.customColor.text2,
          enabled: true,
          background: AppColors.primaryLight,
          onClick: () async {
            await context.read<ManagerShiftCubit>().startManagerShift();
          },
          text: context.tr.start_shift,
        );

      case ShiftStatusType.completed:
        return AppButton(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          borderRadius: BorderRadius.circular(25.r),
          textColor: context.customColor.text2,
          enabled: false,
          onClick: () {},
          text: context.tr.shiftCompleted,
        );

      case ShiftStatusType.inProgress:
        return AppButton(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          borderRadius: BorderRadius.circular(25.r),
          isTransparent: !hasEnded,
          textColor: AppColors.lightBackground,
          enabled: hasEnded,
          background: hasEnded ? AppColors.lightGreen : AppColors.red,
          onClick: () {
            NavigationService.I.pushNamed(
              AppRouteName.endManagerShiftScreen,
              arguments: {
                'handovers': currentManagerShift.handover,
                'managerName':
                    currentManagerShift.shift.shiftDetails.managerName,
                'managerCubit': context.read<ManagerShiftCubit>(),
              },
            );
          },
          text: context.tr.end_shift,
        );

      default:
        return AppButton(onClick: () {}, text: 'see_details');
    }
  }
}
