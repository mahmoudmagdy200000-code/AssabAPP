import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/daily_inventory_type_enum.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/features/inventory/presentation/screens/inventory_success_screen.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/wasted_for_reason_enum.dart';
import '../../../../core/models/media_file_model.dart';
import '../../data/models/create_wast_and_damage_request.dart';
import '../../data/models/inventory_employee_response.dart';
import '../../data/models/wasted_damage_items_response.dart';
import '../../domain/strategies/cause_of_damage_strategy.dart';
import '../../domain/strategies/inventory_user_type.dart';
import '../../domain/strategies/wasted_problem_type_strategy.dart';
import '../cubit/create_waste_damage/create_waste_damage_cubit.dart';
import '../cubit/create_waste_damage/create_waste_damage_state.dart';
import '../cubit/get_wasted_damage_items/get_wasted_damage_items_cubit.dart';
import '../cubit/wasted_selected_items/wasted_selected_items_cubit.dart';
import '../cubit/wasted_selected_items/wasted_selected_items_state.dart';
import '../widgets/wasted_categories_bottom_sheet_widget.dart';
import '../widgets/wasted_regester_productes_item_list_view.dart';

class WastedRegesterProductesScreen extends StatelessWidget {
  final InventoryUserType userType;

  const WastedRegesterProductesScreen({super.key, required this.userType});

  /// Required field keys for a given item.
  static Set<String> _requiredFieldsForItem(String itemId) => {
    'problemType_$itemId',
    'quantity_$itemId',
    'reasonForWaste_$itemId',
  };

  void _addProductBottomSheet(BuildContext context) {
    final selectedItemsCubit = context.read<WastedSelectedItemsCubit>();
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.customPageRoute(
      context,
      (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: selectedItemsCubit),
          BlocProvider.value(value: validationCubit),
          BlocProvider(create: (_) => getIt<GetWastedDamageItemsCubit>()),
        ],
        child: const WastedCategoriesBottomSheetWidget(),
      ),
    );
  }

  /// Register required validation fields for newly added items.
  void _registerNewItemFields(
    ValidationCubit validationCubit,
    List<WastedDamageItemData> items,
  ) {
    for (final item in items) {
      final fields = _requiredFieldsForItem(item.id);
      // Only add fields that aren't already registered.
      final newFields = fields
          .where((f) => !validationCubit.fieldIsExists(f))
          .toSet();
      if (newFields.isNotEmpty) {
        validationCubit.addDynamicFields(newFields);
      }
    }
  }

  /// Remove all validation fields for a removed item.
  static void removeItemFields(ValidationCubit validationCubit, String itemId) {
    final fieldsToRemove = <String>{};
    // Remove known required fields.
    fieldsToRemove.addAll(_requiredFieldsForItem(itemId));
    // Remove any dynamic/optional fields that end with _<itemId>.
    for (final key in validationCubit.state.fieldsValidity.keys) {
      if (key.endsWith('_$itemId')) {
        fieldsToRemove.add(key);
      }
    }
    for (final key in validationCubit.state.fieldsValueTyped.keys) {
      if (key.endsWith('_$itemId')) {
        fieldsToRemove.add(key);
      }
    }
    if (fieldsToRemove.isNotEmpty) {
      validationCubit.removeDynamicFields(fieldsToRemove);
    }
  }

  /// Build the [CreateWastAndDamageRequest] from the current validation state.
  CreateWastAndDamageRequest _buildRequest(BuildContext context) {
    final items = context.read<WastedSelectedItemsCubit>().state.items;
    final validationCubit = context.read<ValidationCubit>();
    final validationState = validationCubit.state;

    final wastItems = items.map((item) {
      final problemType = validationState
          .getTypedValue<WastedProblemTypeStrategy>('problemType_${item.id}');

      final quantity =
          double.tryParse(
            validationState.fieldsValue['quantity_${item.id}'] ?? '',
          ) ??
          0;

      final reason = validationState.getTypedValue<WastedForReasonEnum>(
        'reasonForWaste_${item.id}',
      );

      final justification =
          validationState.fieldsValue['justification_${item.id}'] ?? '';

      // Build responsible employees list.
      // For MeAndOrOtherEmployeesStrategy the first entry is always the
      // branch manager — their quantity goes into myQuantityAccountable and
      // they are NOT added to responsibleEmployees.
      final selectedEmployees =
          validationState.getTypedValue<List<InventoryEmployee>>(
            'selectedEmployees_${item.id}',
          ) ??
          [];
      final employeeQuantities =
          validationState.getTypedValue<List<String>>(
            'employeeQuantities_${item.id}',
          ) ??
          [];

      final causeStrategy = validationState
          .getTypedValue<CauseOfDamageStrategy>('causeOfDamageType_${item.id}');

      final isMeAndOther = causeStrategy is MeAndOrOtherEmployeesStrategy;

      // Branch manager quantity (index 0) when "me and other employees".
      final String? myQuantityAccountable =
          isMeAndOther && employeeQuantities.isNotEmpty
          ? employeeQuantities[0]
          : null;

      // Other employees start at index 1 for MeAndOther, 0 otherwise.
      final int startIndex = isMeAndOther ? 1 : 0;
      final responsibleEmployees = <ResponsibleEmployee>[
        for (int i = startIndex; i < selectedEmployees.length; i++)
          ResponsibleEmployee(
            cashierId: selectedEmployees[i].id,
            quantityAccountable: double.tryParse(
              i < employeeQuantities.length ? employeeQuantities[i] : '0',
            ),
          ),
      ];

      return WastAndDamageItem(
        itemId: item.itemId,
        purchaseOrderItemId: item.purchaseOrderItemId,
        problemType: problemType?.type.name,
        causeOfDamage: causeStrategy?.value,
        quantity: quantity,
        reason: reason?.value,
        justificationText: justification.isNotEmpty ? justification : null,
        photo: validationState
            .getTypedValue<MediaFile>('photo_${item.id}')
            ?.toFile,
        myQuantityAccountable: double.tryParse(myQuantityAccountable ?? '0'),
        responsibleEmployees: responsibleEmployees,
      );
    }).toList();

    return CreateWastAndDamageRequest(
      items: wastItems,
      assignedToType: DailyInventoryTypeEnum.personal.value,
    );
  }

  /// Submit the waste/damage report.
  void _submitReport(BuildContext context) {
    final request = _buildRequest(context);
    context.read<CreateWasteDamageCubit>().createWasteDamageReport(
      request: request,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.wasteAndDamageRegistration,
            subtitle: '',
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  Expanded(
                    child:
                        BlocConsumer<
                          WastedSelectedItemsCubit,
                          WastedSelectedItemsState
                        >(
                          listener: (context, state) {
                            _registerNewItemFields(
                              context.read<ValidationCubit>(),
                              state.items,
                            );
                          },
                          builder: (context, state) {
                            final items = state.items;

                            if (items.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(
                                        color: context.customColor.border,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.r,
                                      vertical: 12.r,
                                    ),
                                    child: Column(
                                      spacing: 8.h,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.tr.addItemsProductsManually,
                                          style: AppStyles.s12W500.copyWith(
                                            color: context.customColor.text4,
                                          ),
                                        ),
                                        ButtonTextIcon(
                                          onTap: () =>
                                              _addProductBottomSheet(context),
                                          label: context
                                              .tr
                                              .searchForProductsAndAdd,
                                          icon: AppSvg(
                                            assetName: AppAssets.box,
                                            width: 14.r,
                                            colorFilter: ColorFilter.mode(
                                              context.theme.primaryColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          spaceBetweenTextAndIcon: 7.w,
                                          textStyle: AppStyles.s12W500.copyWith(
                                            color: context.theme.primaryColor,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8.r,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            1000.r,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        context.tr.searchForProductsAndAdd,
                                        style: AppStyles.s14W400.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr.selectedProductCount(items.length),
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                                10.verticalSpace,
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: context.customColor.text2,
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    padding: EdgeInsets.all(8.r),
                                    child: ListView.builder(
                                      itemCount: items.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        final item = items[index];

                                        return MultiBlocProvider(
                                          key: ValueKey(item.id),
                                          providers: [
                                            BlocProvider(
                                              create: (_) =>
                                                  getIt<ChooseItemCubit>(),
                                            ),
                                            BlocProvider(
                                              create: (_) =>
                                                  getIt<MediaCubit>(),
                                            ),
                                          ],
                                          child:
                                              WastedRegesterProductesItemListView(
                                                item: item,
                                              ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                8.verticalSpace,
                                Row(
                                  children: [
                                    ButtonTextIcon(
                                      onTap: () =>
                                          _addProductBottomSheet(context),
                                      label: context.tr.addAnotherProduct,
                                      icon: Icon(
                                        Icons.add,
                                        size: 16.r,
                                        color: context.theme.primaryColor,
                                      ),
                                      spaceBetweenTextAndIcon: 6.w,
                                      textStyle: AppStyles.s12W500.copyWith(
                                        color: context.theme.primaryColor,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 11.r,
                                        horizontal: 12.r,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        1000.r,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                  ),
                  20.verticalSpace,
                  BlocConsumer<CreateWasteDamageCubit, CreateWasteDamageState>(
                    listener: (context, state) {
                      if (state is CreateWasteDamageSuccess) {
                        NavigationService.I.popToFirst();

                        AppBottomSheet.customPageRoute(
                          context,
                          (context) => InventorySuccessScreen(
                            title: context.tr.reportSaved,
                            desc: context.tr.reportSavedDesc,
                          ),
                        );
                      } else if (state is CreateWasteDamageFailure) {
                        AppDialog.showErrorDialog(
                          context: context,
                          failure: state.failure,
                        );
                      }
                    },
                    builder: (context, createState) {
                      if (createState is CreateWasteDamageLoading) {
                        return AppButtonLoading(
                          background: context.customColor.dark,
                        );
                      }

                      return BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        bool
                      >(
                        selector: (state) =>
                            state.enableButton && state.fieldsValue.isNotEmpty,
                        builder: (context, isValid) {
                          return AppButton(
                            onClick: () => _submitReport(context),
                            text: context.tr.saveReportToDraft,
                            padding: EdgeInsets.symmetric(vertical: 18.r),
                            enabled: isValid,
                            background: context.customColor.dark,
                            borderRadius: BorderRadius.circular(20.r),
                            icon: const AppSvg(assetName: AppAssets.draft),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
