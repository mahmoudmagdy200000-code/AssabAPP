import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/search/search_state.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../data/models/inventory_employee_response.dart';
import '../cubit/get_inventory_employee/get_inventory_employee_cubit.dart';
import '../cubit/get_inventory_employee/get_inventory_employee_state.dart';

class InventoryEmployeeListBottomSheetWidget extends StatelessWidget {
  const InventoryEmployeeListBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<GetInventoryEmployeeCubit>()..getInventoryEmployees(),
      child: BlocProvider(
        create: (context) => SearchCubit<InventoryEmployee>(),
        child: Scaffold(
          body: AppPaddingWidget(
            child: BlocConsumer<GetInventoryEmployeeCubit, GetInventoryEmployeeState>(
              listener: (context, state) {
                if (state is GetInventoryEmployeeSuccess) {
                  context.read<SearchCubit<InventoryEmployee>>().setData(
                    state.employees,
                  );
                }
              },
              builder: (context, state) {
                if (state is GetInventoryEmployeeLoading) {
                  return const AppLoadingWidget();
                } else if (state is GetInventoryEmployeeFailure) {
                  return AppFailureWidget(
                    failure: state.failure,
                    onRetry: () {
                      context
                          .read<GetInventoryEmployeeCubit>()
                          .getInventoryEmployees();
                    },
                    withBorder: false,
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.employeesList,
                            style: AppStyles.s20W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          10.verticalSpace,
                          Text(
                            context.tr.assignEmployeeToInventory,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          10.verticalSpace,
                          ContainerCustomTextField(
                            backgroundColor: Colors.transparent,
                            child: Row(
                              children: [
                                const AppSvg(assetName: AppAssets.search),
                                8.horizontalSpace,
                                Expanded(
                                  child: CustomTextField(
                                    hintText: context.tr.searchEmployeesByName,
                                    onChanged: (value) {
                                      context
                                          .read<
                                            SearchCubit<InventoryEmployee>
                                          >()
                                          .search(
                                            value,
                                            (employee, query) => employee.name
                                                .toLowerCase()
                                                .contains(query.toLowerCase()),
                                          );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          10.verticalSpace,
                          Expanded(
                            child:
                                BlocBuilder<
                                  SearchCubit<InventoryEmployee>,
                                  SearchState<InventoryEmployee>
                                >(
                                  builder: (context, searchState) {
                                    final employees =
                                        searchState
                                            is SearchSuccess<InventoryEmployee>
                                        ? searchState.results
                                        : <InventoryEmployee>[];

                                    if (employees.isEmpty &&
                                        state is GetInventoryEmployeeSuccess) {
                                      return Center(
                                        child: Text(
                                          context.tr.noEmployeesFound,
                                          style: AppStyles.s14W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                      );
                                    }

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: employees.length,
                                      itemBuilder: (context, index) {
                                        final employee = employees[index];
                                        return AppGestureDetectorButton(
                                          onTap: () {
                                            context
                                                .read<ChooseItemCubit>()
                                                .selectTempItem(index);

                                            context
                                                .read<ValidationCubit>()
                                                .validateFieldAndStoreValue(
                                                  fieldName: 'isSelected',
                                                  value: index.toString(),
                                                  isValid: true,
                                                );
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  ProfileImageWidget(
                                                    width: 30.r,
                                                    height: 30.r,
                                                    image: employee.image,
                                                  ),
                                                  12.horizontalSpace,
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          employee.name,
                                                          style: AppStyles
                                                              .s14W500
                                                              .copyWith(
                                                                color: context
                                                                    .customColor
                                                                    .text1,
                                                              ),
                                                        ),
                                                        2.verticalSpace,
                                                        Text(
                                                          employee.email ?? '-',
                                                          style: AppStyles
                                                              .s12W400
                                                              .copyWith(
                                                                color: context
                                                                    .customColor
                                                                    .text3,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  5.horizontalSpace,
                                                  BlocSelector<
                                                    ChooseItemCubit,
                                                    ChooseItemState,
                                                    bool
                                                  >(
                                                    selector: (chooseState) =>
                                                        chooseState
                                                            .tempSelectedIndex ==
                                                        index,
                                                    builder:
                                                        (context, isSelected) {
                                                          return SelectionCircule(
                                                            isSelected:
                                                                isSelected,
                                                          );
                                                        },
                                                  ),
                                                ],
                                              ),
                                              if (index != employees.length - 1)
                                                20.verticalSpace,
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                          ),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    BlocSelector<ValidationCubit, ValidationState, bool>(
                      selector: (state) =>
                          state.fieldsValidity['isSelected'] ?? false,
                      builder: (context, state) {
                        return AppButton(
                          onClick: () {
                            final selectedIndex = context
                                .read<ChooseItemCubit>()
                                .state
                                .tempSelectedIndex;
                            if (selectedIndex != null) {
                              final searchState = context
                                  .read<SearchCubit<InventoryEmployee>>()
                                  .state;
                              if (searchState
                                      is SearchSuccess<InventoryEmployee> &&
                                  selectedIndex < searchState.results.length) {
                                final selectedEmployee =
                                    searchState.results[selectedIndex];

                                context
                                    .read<ChooseItemCubit>()
                                    .confirmTempSelection();

                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreValue(
                                      fieldName: 'employeeId',
                                      value: selectedEmployee.id,
                                      isValid: true,
                                    );

                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreValue(
                                      fieldName: 'employeeName',
                                      value: selectedEmployee.name,
                                      isValid: true,
                                    );

                                NavigationService.I.pop();
                              }
                            }
                          },
                          enabled: state,
                          text: context.tr.confirmSelection,
                          borderRadius: BorderRadius.circular(20.r),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
