import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/search/search_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_price_comparison/branch_manager_price_comparison_cubit.dart';
import 'package:assab/features/purchase/data/models/purchase_branch_items_response.dart';
import 'package:assab/features/purchase/data/models/suppliers_for_filter_purchase_items_response.dart';
import 'package:assab/features/purchase/presentation/cubit/get_purchase_branch_items/get_purchase_branch_items_cubit.dart';
import 'package:assab/features/purchase/presentation/cubit/get_purchase_branch_items/get_purchase_branch_items_state.dart';
import 'package:assab/features/purchase/presentation/cubit/get_suppliers_for_filter/get_suppliers_for_filter_cubit.dart';
import 'package:assab/features/purchase/presentation/cubit/get_suppliers_for_filter/get_suppliers_for_filter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/time_keys.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/selection_circule.dart';

class BranchManagerViewReportsFilterPriceComparisonBottomSheet
    extends StatefulWidget {
  const BranchManagerViewReportsFilterPriceComparisonBottomSheet({super.key});

  @override
  State<BranchManagerViewReportsFilterPriceComparisonBottomSheet>
  createState() =>
      _BranchManagerViewReportsFilterPriceComparisonBottomSheetState();
}

class _BranchManagerViewReportsFilterPriceComparisonBottomSheetState
    extends State<BranchManagerViewReportsFilterPriceComparisonBottomSheet> {
  late final GetPurchaseBranchItemsCubit _itemsCubit;
  late final GetSuppliersForFilterCubit _suppliersCubit;
  late final SearchCubit<PurchaseBranchItemData> _itemSearchCubit;
  late final SearchCubit<SuppliersForFilterPurchaseItemsResponseData>
  _supplierSearchCubit;

  @override
  void initState() {
    super.initState();
    _itemsCubit = getIt<GetPurchaseBranchItemsCubit>();
    _suppliersCubit = getIt<GetSuppliersForFilterCubit>();
    _itemSearchCubit = SearchCubit<PurchaseBranchItemData>();
    _supplierSearchCubit =
        SearchCubit<SuppliersForFilterPurchaseItemsResponseData>();

    _itemsCubit.getPurchaseBranchItems();
    _suppliersCubit.getSuppliers();

    _itemsCubit.stream.listen((state) {
      if (state is GetPurchaseBranchItemsSuccess) {
        _itemSearchCubit.setData(state.response);
      }
    });

    _suppliersCubit.stream.listen((state) {
      if (state is GetSuppliersForFilterSuccess) {
        _supplierSearchCubit.setData(state.suppliers);
      }
    });
  }

  @override
  void dispose() {
    _itemsCubit.close();
    _suppliersCubit.close();
    _itemSearchCubit.close();
    _supplierSearchCubit.close();
    super.dispose();
  }

  void _selectSortBy(BuildContext context, TimeKeys time) {
    context.read<ValidationCubit>().validateFieldAndStoreTypedValue<TimeKeys>(
      fieldName: 'sortBy',
      value: time,
      isValid: true,
    );
  }

  void _selectItem(BuildContext context, String itemId) {
    context.read<ValidationCubit>().validateFieldAndStoreTypedValue<String>(
      fieldName: 'itemId',
      value: itemId,
      isValid: true,
    );
  }

  void _selectSupplier(BuildContext context, String supplierId) {
    context.read<ValidationCubit>().validateFieldAndStoreTypedValue<String>(
      fieldName: 'supplierId',
      value: supplierId,
      isValid: true,
    );
  }

  void _clearFilters(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.validateFieldAndStoreTypedValue<TimeKeys?>(
      fieldName: 'sortBy',
      value: null,
      isValid: false,
    );

    validationCubit.validateFieldAndStoreTypedValue<String?>(
      fieldName: 'itemId',
      value: null,
      isValid: false,
    );

    validationCubit.validateFieldAndStoreTypedValue<String?>(
      fieldName: 'supplierId',
      value: null,
      isValid: false,
    );

    final priceComparisonCubit = context
        .read<BranchManagerPriceComparisonCubit>();

    priceComparisonCubit.clearFilters();

    priceComparisonCubit.loadPriceComparisons();

    NavigationService.I.pop();
  }

  void _showResults(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    final priceComparisonCubit = context
        .read<BranchManagerPriceComparisonCubit>();

    final sortBy = validationCubit.getTypedValue<TimeKeys?>('sortBy');
    final itemId = validationCubit.getTypedValue<String?>('itemId');
    final supplierId = validationCubit.getTypedValue<String?>('supplierId');

    priceComparisonCubit.loadPriceComparisons(
      timeKey: sortBy,
      itemId: itemId,
      supplierId: supplierId,
    );

    NavigationService.I.pop();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _itemsCubit),
        BlocProvider.value(value: _suppliersCubit),
        BlocProvider.value(value: _itemSearchCubit),
        BlocProvider.value(value: _supplierSearchCubit),
      ],
      child: Scaffold(
        body: AppPaddingWidget(
          top: 30.r,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Text(
                        'Filter Payment Log By:',
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      context.tr.sortByDate,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    5.verticalSpace,
                    BlocSelector<ValidationCubit, ValidationState, TimeKeys?>(
                      selector: (state) =>
                          state.getTypedValue<TimeKeys?>('sortBy'),
                      builder: (context, selectedSort) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: context.customColor.border,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.r,
                            vertical: 8.r,
                          ),
                          child: Column(
                            spacing: 10.h,
                            children: List.generate(3, (index) {
                              final texts = [
                                context.tr.last24Hours,
                                context.tr.last7Days,
                                context.tr.last30Days,
                              ];

                              final timeKeys = [
                                TimeKeys.last24Hours,
                                TimeKeys.last7Days,
                                TimeKeys.last30Days,
                              ];

                              return AppGestureDetectorButton(
                                onTap: () =>
                                    _selectSortBy(context, timeKeys[index]),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        texts[index],
                                        style: AppStyles.s13W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    SelectionCircule(
                                      isSelected:
                                          selectedSort == timeKeys[index],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                    10.verticalSpace,
                    BlocBuilder<
                      GetPurchaseBranchItemsCubit,
                      GetPurchaseBranchItemsState
                    >(
                      builder: (context, state) {
                        final count = switch (state) {
                          GetPurchaseBranchItemsSuccess(:final response) =>
                            response.length,
                          _ => 0,
                        };
                        return Text(
                          '${context.tr.items} ($count)',
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text3,
                          ),
                        );
                      },
                    ),
                    5.verticalSpace,
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: context.customColor.border),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.r,
                          vertical: 8.r,
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: context.customColor.border,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.r,
                                vertical: 8.r,
                              ),
                              child: Row(
                                children: [
                                  AppSvg(
                                    assetName: AppAssets.search,
                                    width: 15.r,
                                  ),
                                  10.horizontalSpace,
                                  Expanded(
                                    child: CustomTextField(
                                      hintText: 'Search by item name',
                                      onChanged: (value) {
                                        _itemSearchCubit.search(
                                          value,
                                          (item, query) => item.itemName
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
                                    GetPurchaseBranchItemsCubit,
                                    GetPurchaseBranchItemsState
                                  >(
                                    builder: (context, state) {
                                      return switch (state) {
                                        GetPurchaseBranchItemsLoading() =>
                                          const AppLoadingWidget(),
                                        GetPurchaseBranchItemsSuccess(
                                          response: final items,
                                        ) =>
                                          BlocBuilder<
                                            SearchCubit<PurchaseBranchItemData>,
                                            SearchState<PurchaseBranchItemData>
                                          >(
                                            builder: (context, filteredItems) {
                                              final displayItems =
                                                  filteredItems
                                                      is SearchSuccess<
                                                        PurchaseBranchItemData
                                                      >
                                                  ? filteredItems.results
                                                  : items;

                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount: displayItems.length,
                                                itemBuilder: (context, index) {
                                                  final item =
                                                      displayItems[index];
                                                  return Column(
                                                    children: [
                                                      BlocSelector<
                                                        ValidationCubit,
                                                        ValidationState,
                                                        String?
                                                      >(
                                                        selector: (state) =>
                                                            state.getTypedValue<
                                                              String
                                                            >('itemId'),
                                                        builder: (context, selectedItemId) {
                                                          return AppGestureDetectorButton(
                                                            onTap: () =>
                                                                _selectItem(
                                                                  context,
                                                                  item.itemId,
                                                                ),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    item.itemName,
                                                                    style: AppStyles
                                                                        .s13W500
                                                                        .copyWith(
                                                                          color: context
                                                                              .customColor
                                                                              .text1,
                                                                        ),
                                                                  ),
                                                                ),
                                                                10.horizontalSpace,
                                                                SelectionCircule(
                                                                  isSelected:
                                                                      selectedItemId ==
                                                                      item.itemId,
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      10.verticalSpace,
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        GetPurchaseBranchItemsFailure() =>
                                          AppFailureWidget(
                                            failure: state.failure,
                                          ),
                                        _ => const SizedBox(),
                                      };
                                    },
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    BlocBuilder<
                      GetSuppliersForFilterCubit,
                      GetSuppliersForFilterState
                    >(
                      builder: (context, state) {
                        final count = switch (state) {
                          GetSuppliersForFilterSuccess(
                            suppliers: final suppliers,
                          ) =>
                            suppliers.length,
                          _ => 0,
                        };
                        return Text(
                          '${context.tr.suppliers} ($count)',
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text3,
                          ),
                        );
                      },
                    ),
                    5.verticalSpace,
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: context.customColor.border),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.r,
                          vertical: 8.r,
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: context.customColor.border,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.r,
                                vertical: 8.r,
                              ),
                              child: Row(
                                children: [
                                  AppSvg(
                                    assetName: AppAssets.search,
                                    width: 15.r,
                                  ),
                                  10.horizontalSpace,
                                  Expanded(
                                    child: CustomTextField(
                                      hintText: 'Search by supplier name',
                                      onChanged: (value) {
                                        _supplierSearchCubit.search(
                                          value,
                                          (supplier, query) => supplier.name
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
                                    GetSuppliersForFilterCubit,
                                    GetSuppliersForFilterState
                                  >(
                                    builder: (context, state) {
                                      return switch (state) {
                                        GetSuppliersForFilterLoading() =>
                                          const AppLoadingWidget(),
                                        GetSuppliersForFilterSuccess(
                                          suppliers: final suppliers,
                                        ) =>
                                          BlocBuilder<
                                            SearchCubit<
                                              SuppliersForFilterPurchaseItemsResponseData
                                            >,
                                            SearchState<
                                              SuppliersForFilterPurchaseItemsResponseData
                                            >
                                          >(
                                            builder: (context, filteredSuppliers) {
                                              final displaySuppliers =
                                                  filteredSuppliers
                                                      is SearchSuccess<
                                                        SuppliersForFilterPurchaseItemsResponseData
                                                      >
                                                  ? filteredSuppliers.results
                                                  : suppliers;

                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount:
                                                    displaySuppliers.length,
                                                itemBuilder: (context, index) {
                                                  final supplier =
                                                      displaySuppliers[index];
                                                  return Column(
                                                    children: [
                                                      BlocSelector<
                                                        ValidationCubit,
                                                        ValidationState,
                                                        String?
                                                      >(
                                                        selector: (state) =>
                                                            state.getTypedValue<
                                                              String
                                                            >('supplierId'),
                                                        builder:
                                                            (
                                                              context,
                                                              selectedSupplierId,
                                                            ) {
                                                              return AppGestureDetectorButton(
                                                                onTap: () =>
                                                                    _selectSupplier(
                                                                      context,
                                                                      supplier
                                                                          .id,
                                                                    ),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        supplier
                                                                            .name,
                                                                        style: AppStyles
                                                                            .s13W500
                                                                            .copyWith(
                                                                              color: context.customColor.text1,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    10.horizontalSpace,
                                                                    SelectionCircule(
                                                                      isSelected:
                                                                          selectedSupplierId ==
                                                                          supplier
                                                                              .id,
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                      ),
                                                      10.verticalSpace,
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        GetSuppliersForFilterFailure() =>
                                          AppFailureWidget(
                                            failure: state.failure,
                                          ),
                                        _ => const SizedBox(),
                                      };
                                    },
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              Row(
                spacing: 10.w,
                children: [
                  Expanded(
                    child: CustomTextButton(
                      text: context.tr.defaultSettings,
                      onTap: () => _clearFilters(context),
                      borderRadius: 15.r,
                      padding: EdgeInsets.symmetric(vertical: 14.r),
                      textColor: context.customColor.text1,
                    ),
                  ),
                  Expanded(
                    child: BlocSelector<ValidationCubit, ValidationState, bool>(
                      selector: (state) {
                        final sortBy = state.getTypedValue<TimeKeys?>('sortBy');
                        final itemId = state.getTypedValue<String?>('itemId');
                        final supplierId = state.getTypedValue<String?>(
                          'supplierId',
                        );

                        return sortBy != null ||
                            itemId != null ||
                            supplierId != null;
                      },
                      builder: (context, isEnabled) {
                        return AppButton(
                          text: context.tr.showResults,
                          enabled: isEnabled,
                          onClick: () => _showResults(context),
                          borderRadius: BorderRadius.circular(15.r),
                          padding: EdgeInsets.symmetric(vertical: 14.r),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
