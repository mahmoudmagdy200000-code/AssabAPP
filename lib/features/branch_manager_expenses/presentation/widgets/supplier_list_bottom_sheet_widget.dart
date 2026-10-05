import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/suppliers/suppliers_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/suppliers/suppliers_state.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/row_text_circule_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/search/search_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_search_empty_result_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/supplier_model.dart';

class SupplierListBottomSheetWidget extends StatefulWidget {
  final ValueChanged<SupplierModel> onSelected;
  final VoidCallback? initState;

  const SupplierListBottomSheetWidget({
    super.key,
    required this.onSelected,
    this.initState,
  });

  @override
  State<SupplierListBottomSheetWidget> createState() =>
      _SupplierListBottomSheetWidgetState();
}

class _SupplierListBottomSheetWidgetState
    extends State<SupplierListBottomSheetWidget> {
  @override
  void initState() {
    context.read<SuppliersCubit>().getSuppliers();

    if (widget.initState != null) {
      widget.initState!();
    }
    super.initState();
  }

  void _selectSupplier({
    required BuildContext context,
    required String? selectedSupplier,
    required SupplierModel supplier,
  }) {
    if (selectedSupplier != supplier.id) {
      context.read<SuppliersCubit>().selectSupplier(supplier.id, supplier.name);
      widget.onSelected(supplier);
      NavigationService.I.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.supplierList,
                  style: AppStyles.s20W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                12.verticalSpace,
                Text(
                  context.tr.supplierListDesc,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                14.verticalSpace,
                const CustomDivider(),
                20.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppSvg(assetName: AppAssets.search),
                    10.horizontalSpace,
                    Expanded(
                      child: CustomTextField(
                        hintText: context.tr.searchHint,
                        onChanged: (value) {
                          context.read<SearchCubit<SupplierModel>>().search(
                            value,
                            (item, query) => item.name.toLowerCase().contains(
                              query.toLowerCase(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                14.verticalSpace,
                const CustomDivider(),
                14.verticalSpace,
              ],
            ),
          ),
          BlocConsumer<SuppliersCubit, SuppliersState>(
            listener: (context, state) {
              if (state is SuppliersSuccess) {
                context.read<SearchCubit<SupplierModel>>().setData(
                  state.suppliers.data,
                );
              }
            },
            builder: (context, state) {
              if (state is SuppliersLoading) {
                return const SliverToBoxAdapter(child: AppLoadingWidget());
              } else if (state is SuppliersFailure) {
                return AppFailureWidget(failure: state.failure);
              }

              return BlocBuilder<
                SearchCubit<SupplierModel>,
                SearchState<SupplierModel>
              >(
                builder: (context, searchState) {
                  if (searchState is SearchSuccess<SupplierModel>) {
                    final suppliers = searchState.results;

                    if (suppliers.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: AppSearchEmptyResultWidget(),
                      );
                    }

                    return SliverList.builder(
                      itemCount: suppliers.length,
                      itemBuilder: (context, index) {
                        return BlocSelector<
                          SuppliersCubit,
                          SuppliersState,
                          String?
                        >(
                          selector: (state) => (state is SelectSupplier)
                              ? state.supplierId
                              : null,
                          builder: (context, selectedSupplier) {
                            return AppGestureDetectorButton(
                              onTap: () => _selectSupplier(
                                context: context,
                                selectedSupplier: selectedSupplier,
                                supplier: suppliers[index],
                              ),
                              child: Column(
                                children: [
                                  RowTextCirculeSelection(
                                    text: suppliers[index].name,
                                    isSelected:
                                        selectedSupplier == suppliers[index].id,
                                  ),
                                  if (index < suppliers.length - 1) ...[
                                    14.verticalSpace,
                                    const CustomDivider(),
                                    14.verticalSpace,
                                  ],
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
