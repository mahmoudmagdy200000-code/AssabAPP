import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:assab/features/inventory/presentation/cubit/get_inventory_employee/get_inventory_employee_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../data/models/inventory_employee_response.dart';
import '../cubit/get_inventory_employee/get_inventory_employee_state.dart';

class MonthlyAvailbleStaffListBottomSheetWidget extends StatefulWidget {
  const MonthlyAvailbleStaffListBottomSheetWidget({super.key});

  @override
  State<MonthlyAvailbleStaffListBottomSheetWidget> createState() =>
      _MonthlyAvailbleStaffListBottomSheetWidgetState();
}

class _MonthlyAvailbleStaffListBottomSheetWidgetState
    extends State<MonthlyAvailbleStaffListBottomSheetWidget> {
  @override
  void initState() {
    super.initState();

    _getEmployees();
  }

  void _getEmployees() {
    context.read<GetInventoryEmployeeCubit>().getInventoryEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSvg(
              assetName: AppAssets.team,
              width: 16.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
            Text(
              context.tr.availableStaffList,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            Text(
              context.tr.addStaffToThisMonthsTeam,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            15.verticalSpace,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.all(4.r),
                child:
                    BlocBuilder<
                      GetInventoryEmployeeCubit,
                      GetInventoryEmployeeState
                    >(
                      builder: (context, state) {
                        final List<InventoryEmployee> employees = [];

                        if (state is GetInventoryEmployeeLoading) {
                          return const AppLoadingWidget();
                        } else if (state is GetInventoryEmployeeFailure) {
                          return AppFailureWidget(
                            failure: state.failure,
                            onRetry: _getEmployees,
                            withBorder: false,
                          );
                        } else if (state is GetInventoryEmployeeSuccess) {
                          employees.addAll(state.employees);
                        }

                        return ListView.builder(
                          itemCount: employees.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return AppGestureDetectorButton(
                              onTap: () {
                                context.read<ChooseItemCubit>().selectItem(
                                  index,
                                );

                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreValue(
                                      fieldName: 'staffName',
                                      value: employees[index].name,
                                      isValid: true,
                                    );

                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreValue(
                                      fieldName: 'staffId',
                                      value: employees[index].id,
                                      isValid: true,
                                    );

                                NavigationService.I.pop();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.customColor.reversedTextColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                padding: EdgeInsets.all(12.r),
                                margin: EdgeInsets.only(bottom: 4.r),
                                child: Row(
                                  children: [
                                    ProfileImageWidget(
                                      image: employees[index].image,
                                    ),
                                    10.horizontalSpace,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            employees[index].name,
                                            style: AppStyles.s14W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              AppSvg(
                                                assetName: AppAssets.crownSvg,
                                                width: 16.r,
                                              ),
                                              5.horizontalSpace,
                                              Text(
                                                '',
                                                style: AppStyles.s12W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text3,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    BlocSelector<
                                      ChooseItemCubit,
                                      ChooseItemState,
                                      bool
                                    >(
                                      selector: (state) =>
                                          state.selectedIndex == index,
                                      builder: (context, state) {
                                        return SelectionCircule(
                                          isSelected: state,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
