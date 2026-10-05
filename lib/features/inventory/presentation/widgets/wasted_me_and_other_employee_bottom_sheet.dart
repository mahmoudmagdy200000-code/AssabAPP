import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_back_button.dart';
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

import '../../../../core/styles/app_styles.dart';
import '../../data/models/inventory_employee_response.dart';
import '../../data/models/wasted_damage_items_response.dart';
import '../../domain/strategies/cause_of_damage_strategy.dart';
import '../cubit/get_inventory_employee/get_inventory_employee_cubit.dart';
import '../cubit/get_inventory_employee/get_inventory_employee_state.dart';

class WastedMeAndOtherEmployeeBottomSheet extends StatefulWidget {
  final String? itemId;
  final WastedDamageItemData? item;

  const WastedMeAndOtherEmployeeBottomSheet({
    super.key,
    this.itemId,
    this.item,
  });

  @override
  State<WastedMeAndOtherEmployeeBottomSheet> createState() =>
      _WastedMeAndOtherEmployeeBottomSheetState();
}

class _WastedMeAndOtherEmployeeBottomSheetState
    extends State<WastedMeAndOtherEmployeeBottomSheet> {
  String _key(String base) =>
      widget.itemId != null ? '${base}_${widget.itemId}' : base;

  @override
  void initState() {
    super.initState();
    selectedIndicesNotifier.addListener(_updateCanConfirm);
    branchManagerController.addListener(_updateCanConfirm);
    _getEmployees();
  }

  void _getEmployees() {
    context.read<GetInventoryEmployeeCubit>().getInventoryEmployees();
  }

  void _loadExistingSelections(List<InventoryEmployee> employees) {
    final validationState = context.read<ValidationCubit>().state;
    final selectedEmployees =
        validationState.getTypedValue<List<InventoryEmployee>>(
          _key('selectedEmployees'),
        ) ??
        [];
    final quantities =
        validationState.getTypedValue<List<String>>(
          _key('employeeQuantities'),
        ) ??
        [];

    if (selectedEmployees.isNotEmpty && quantities.isNotEmpty) {
      // Set branch manager quantity and selected indices after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        branchManagerController.text = quantities[0];
        // Set selected employees (skip branch manager)
        for (int i = 1; i < selectedEmployees.length; i++) {
          final employee = selectedEmployees[i];
          final index = employees.indexWhere(
            (e) => e.id == employee.id || e.name == employee.name,
          );
          if (index != -1) {
            selectedIndicesNotifier.value = Set.from(
              selectedIndicesNotifier.value,
            )..add(index);
            quantityControllers[index] = TextEditingController(
              text: quantities[i],
            );
          }
        }
      });
    }
  }

  ValueNotifier<Set<int>> selectedIndicesNotifier = ValueNotifier<Set<int>>({});
  final ValueNotifier<bool> _canConfirm = ValueNotifier<bool>(false);
  Map<int, TextEditingController> quantityControllers = {};
  TextEditingController branchManagerController = TextEditingController(
    text: '0',
  );
  bool _loadedExisting = false;

  void _updateCanConfirm() {
    final indices = selectedIndicesNotifier.value;
    if (indices.isEmpty) {
      _canConfirm.value = false;
      return;
    }
    final branchQty = branchManagerController.text.trim();
    if (branchQty.isEmpty || branchQty == '0') {
      _canConfirm.value = false;
      return;
    }
    for (final index in indices) {
      final qty = quantityControllers[index]?.text.trim() ?? '';
      if (qty.isEmpty || qty == '0') {
        _canConfirm.value = false;
        return;
      }
    }
    _canConfirm.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBackButton(
                        isTransparent: true,
                        iconColor: context.customColor.text1,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.meAndOrOtherEmployees,
                              style: AppStyles.s16W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              context
                                  .tr
                                  .chooseTheEmployeeSResponsibleAndSpecifyThePortionEachPersonIsAccountableFor,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).sliverBoxAdapter,
                  10.verticalSpace.sliverBoxAdapter,
                  Row(
                    children: [
                      AppSvg(assetName: AppAssets.search, width: 18.r),
                      10.horizontalSpace,
                      Expanded(
                        child: CustomTextField(
                          hintText: context.tr.searchForEmployeeByName,
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ).sliverBoxAdapter,
                  10.verticalSpace.sliverBoxAdapter,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: context.theme.primaryColor),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.r,
                      vertical: 12.r,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProfileImageWidget(),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${context.tr.me} (${getIt<SharedPreferencesHelper>().getString('u_name')})',
                              ),
                              // 4.verticalSpace,
                              // Text(
                              //   context.tr.storeBranchName,
                              //   style: AppStyles.s12W400.copyWith(
                              //     color: context.customColor.text3,
                              //   ),
                              // ),
                              4.verticalSpace,
                              ContainerCustomTextField(
                                backgroundColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(15.r),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.r,
                                  vertical: 10.r,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: branchManagerController,
                                        hintText: context.tr.qty,
                                      ),
                                    ),
                                    5.horizontalSpace,
                                    Text(
                                      '/${widget.item?.itemUnit}',
                                      style: AppStyles.s14W400.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    AppSvg(
                                      assetName: AppAssets.edit,
                                      width: 14.r,
                                      colorFilter: ColorFilter.mode(
                                        context.theme.primaryColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        14.horizontalSpace,
                        const SelectionCircule(isSelected: true),
                      ],
                    ),
                  ).sliverBoxAdapter,
                  8.verticalSpace.sliverBoxAdapter,
                  BlocBuilder<
                    GetInventoryEmployeeCubit,
                    GetInventoryEmployeeState
                  >(
                    builder: (context, state) {
                      final List<InventoryEmployee> employees = [];

                      if (state is GetInventoryEmployeeLoading) {
                        return const SliverFillRemaining(
                          child: AppLoadingWidget(),
                        );
                      } else if (state is GetInventoryEmployeeFailure) {
                        return SliverFillRemaining(
                          child: AppFailureWidget(
                            failure: state.failure,
                            onRetry: _getEmployees,
                            withBorder: false,
                          ),
                        );
                      } else if (state is GetInventoryEmployeeSuccess) {
                        employees.addAll(state.employees);
                        if (!_loadedExisting) {
                          _loadExistingSelections(employees);
                          _loadedExisting = true;
                        }
                      }

                      if (employees.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Text(
                              context.tr.noOtherEmployeesFound,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverList.builder(
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];

                          return AppGestureDetectorButton(
                            onTap: () {
                              final current = selectedIndicesNotifier.value;
                              if (current.contains(index)) {
                                selectedIndicesNotifier.value = Set.from(
                                  current,
                                )..remove(index);
                                quantityControllers.remove(index)?.dispose();
                              } else {
                                selectedIndicesNotifier.value = Set.from(
                                  current,
                                )..add(index);
                                final ctrl = TextEditingController(text: '0');
                                ctrl.addListener(_updateCanConfirm);
                                quantityControllers[index] = ctrl;
                              }
                            },
                            child: ValueListenableBuilder<Set<int>>(
                              valueListenable: selectedIndicesNotifier,
                              builder: (context, selectedIndices, child) {
                                final isSelected = selectedIndices.contains(
                                  index,
                                );
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: !isSelected
                                        ? null
                                        : Border.all(
                                            color: context.theme.primaryColor,
                                          ),
                                  ),
                                  padding: !isSelected
                                      ? null
                                      : EdgeInsets.symmetric(
                                          horizontal: 12.r,
                                          vertical: 12.r,
                                        ),
                                  margin: EdgeInsets.only(bottom: 20.r),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ProfileImageWidget(image: employee.image),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(employee.name),
                                            // 4.verticalSpace,
                                            // Text(
                                            //   context.tr.storeBranchName,
                                            //   style: AppStyles.s12W400.copyWith(
                                            //     color:
                                            //         context.customColor.text3,
                                            //   ),
                                            // ),
                                            if (isSelected)
                                              Column(
                                                children: [
                                                  4.verticalSpace,
                                                  ContainerCustomTextField(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15.r,
                                                        ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 16.r,
                                                          vertical: 10.r,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: CustomTextField(
                                                            controller:
                                                                quantityControllers[index],
                                                            hintText:
                                                                context.tr.qty,
                                                          ),
                                                        ),
                                                        5.horizontalSpace,
                                                        Text(
                                                          '/${widget.item?.itemUnit}',
                                                          style: AppStyles
                                                              .s14W400
                                                              .copyWith(
                                                                color: context
                                                                    .customColor
                                                                    .text3,
                                                              ),
                                                        ),
                                                        12.horizontalSpace,
                                                        AppSvg(
                                                          assetName:
                                                              AppAssets.edit,
                                                          width: 14.r,
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                context
                                                                    .theme
                                                                    .primaryColor,
                                                                BlendMode.srcIn,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                      14.horizontalSpace,
                                      SelectionCircule(isSelected: isSelected),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            ValueListenableBuilder<bool>(
              valueListenable: _canConfirm,
              builder: (context, canConfirm, child) {
                return BlocBuilder<
                  GetInventoryEmployeeCubit,
                  GetInventoryEmployeeState
                >(
                  builder: (context, state) {
                    final selectedIndices = selectedIndicesNotifier.value;
                    return AppButton(
                      onClick: () {
                        if (!canConfirm) return;
                        List<InventoryEmployee> selectedEmployees = [];
                        List<String> quantities = [];

                        // Add branch manager
                        selectedEmployees.add(
                          InventoryEmployee(
                            id:
                                getIt<SharedPreferencesHelper>().getString(
                                  'u_id',
                                ) ??
                                '',
                            name:
                                '${context.tr.me} (${getIt<SharedPreferencesHelper>().getString('u_name')})',
                          ),
                        );
                        quantities.add(branchManagerController.text);

                        // Add selected employees
                        if (state is GetInventoryEmployeeSuccess) {
                          for (final index in selectedIndices) {
                            selectedEmployees.add(state.employees[index]);
                            quantities.add(quantityControllers[index]!.text);
                          }
                        }

                        final validationCubit = context.read<ValidationCubit>();

                        validationCubit.validateFieldAndStoreTypedValue<
                          List<InventoryEmployee>
                        >(
                          fieldName: _key('selectedEmployees'),
                          value: selectedEmployees,
                        );

                        validationCubit
                            .validateFieldAndStoreTypedValue<List<String>>(
                              fieldName: _key('employeeQuantities'),
                              value: quantities,
                            );
                        validationCubit.validateFieldAndStoreTypedValue<
                          CauseOfDamageStrategy
                        >(
                          fieldName: _key('causeOfDamageType'),
                          value: MeAndOrOtherEmployeesStrategy(),
                          isValid: true,
                        );

                        NavigationService.I.pop();
                      },
                      enabled: canConfirm,
                      text: canConfirm
                          ? context.tr.confirmSelections
                          : context.tr.youNeedToSelectAtLeastTwoPeople,
                      borderRadius: BorderRadius.circular(18.r),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in quantityControllers.values) {
      controller.dispose();
    }
    branchManagerController.dispose();
    selectedIndicesNotifier.dispose();
    _canConfirm.dispose();
    super.dispose();
  }
}
