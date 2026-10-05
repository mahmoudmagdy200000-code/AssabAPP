import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/purchase/presentation/cubit/select_filter_item/select_filter_item_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/enums/select_filter_item_type.dart';
import '../../data/models/suppliers_for_filter_purchase_items_response.dart';
import '../cubit/get_suppliers_for_filter/get_suppliers_for_filter_cubit.dart';
import 'filter_item_purchase_supplier_section.dart';

class FilterItemPurchaseBottomSheet extends StatefulWidget {
  final void Function() onClearFilter;
  final void Function(String? categoryId, String? supplierId) onApplyFilter;

  const FilterItemPurchaseBottomSheet({
    super.key,
    required this.onClearFilter,
    required this.onApplyFilter,
  });

  @override
  State<FilterItemPurchaseBottomSheet> createState() =>
      _FilterItemPurchaseBottomSheetState();
}

class _FilterItemPurchaseBottomSheetState
    extends State<FilterItemPurchaseBottomSheet> {
  late final ValueNotifier<int> _isExpandedNotifier;

  @override
  void initState() {
    super.initState();

    _isExpandedNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _isExpandedNotifier.dispose();
    super.dispose();
  }

  void _clearFilter() {
    context.read<SelectFilterItemCubit>().clearSelection();
    _resetFieldValidity('filterType');
    _resetFieldValidity('filterId');

    widget.onClearFilter();

    NavigationService.I.pop();
  }

  void _resetFieldValidity(String field) {
    context.read<ValidationCubit>().resetFieldValidity(field);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 50.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.tr.filterItemListBy}:',
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    14.verticalSpace,
                    // FilterItemPurchaseCategorySection(
                    //   isExpandedNotifier: _isExpandedNotifier,
                    // ),
                    // 16.verticalSpace,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              SearchCubit<
                                SuppliersForFilterPurchaseItemsResponseData
                              >(),
                        ),
                        BlocProvider(
                          create: (context) =>
                              getIt<GetSuppliersForFilterCubit>(),
                        ),
                      ],
                      child: FilterItemPurchaseSupplierSection(
                        isExpandedNotifier: _isExpandedNotifier,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    onTap: _clearFilter,
                    text: context.tr.clearFilter,
                    padding: EdgeInsets.symmetric(
                      vertical: 18.r,
                      horizontal: 15.r,
                    ),
                    textStyle: AppStyles.s14W500.copyWith(
                      color: context.customColor.text6,
                    ),
                  ),
                ),
                20.horizontalSpace,
                Expanded(
                  child: BlocSelector<ValidationCubit, ValidationState, bool>(
                    selector: (state) => state.enableButton,
                    builder: (context, state) {
                      return AppButton(
                        onClick: () {
                          final selectFilterItemState = context
                              .read<SelectFilterItemCubit>()
                              .state;

                          final selectedFilterType =
                              selectFilterItemState.selectedFilterType;

                          String? categoryId;
                          String? supplierId;

                          if (selectedFilterType ==
                              SelectFilterItemType.supplier) {
                            supplierId = selectFilterItemState.selectedId;
                          } else if (selectedFilterType ==
                              SelectFilterItemType.category) {
                            categoryId = selectFilterItemState.selectedId;
                          }

                          widget.onApplyFilter(categoryId, supplierId);

                          NavigationService.I.pop();
                        },
                        text: context.tr.showResults,
                        enabled: state,
                        padding: EdgeInsets.symmetric(
                          vertical: 19.r,
                          horizontal: 15.r,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
