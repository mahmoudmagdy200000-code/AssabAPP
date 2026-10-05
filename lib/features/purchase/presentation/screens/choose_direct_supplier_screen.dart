import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_search_empty_result_widget.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/search/search_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../data/models/purchase_branch_items_response.dart';
import '../../data/models/purchase_suppliers_response.dart';
import '../cubit/filter_suppliers/filter_suppliers_cubit.dart';
import '../cubit/get_purchase_suppliers/get_purchase_suppliers_cubit.dart';
import '../cubit/get_purchase_suppliers/get_purchase_suppliers_state.dart';
import '../widgets/direct_supplier_list_view_widget.dart';
import '../widgets/filter_supplier_widget.dart';
import '../widgets/purchase_app_bar.dart';

class ChooseDirectSupplierScreen extends StatefulWidget {
  final PurchaseBranchItemData item;
  final int quantity;
  final String sourceTypeFieldName;
  final String sourceIdFieldName;
  final String sourceNameFieldName;
  final String choosedSourceItemIdFieldName;
  final String addedItemMainId;

  const ChooseDirectSupplierScreen({
    super.key,
    required this.item,
    required this.quantity,
    required this.sourceTypeFieldName,
    required this.sourceIdFieldName,
    required this.sourceNameFieldName,
    required this.choosedSourceItemIdFieldName,
    required this.addedItemMainId,
  });

  @override
  State<ChooseDirectSupplierScreen> createState() =>
      _ChooseDirectSupplierScreenState();
}

class _ChooseDirectSupplierScreenState
    extends State<ChooseDirectSupplierScreen> {
  @override
  void initState() {
    super.initState();

    _getSuppliers();
  }

  void _getSuppliers({String? availability, int? timeDelivery}) {
    context.read<GetPurchaseSuppliersCubit>().getPurchaseSuppliers(
      itemId: widget.item.itemId,
      quantity: widget.quantity.toString(),
      availability: availability,
      timeDelivery: timeDelivery,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          10.verticalSpace,
          PurchaseAppBar(
            iconColor: context.customColor.text1,
            title: '${context.tr.allSuppliers} (8)',
            titleColor: context.customColor.text1,
            subtitle: context.tr.chooseSupplierForThisOrderRequest,
          ),
          AppPaddingWidget(
            top: 8.r,
            bottom: 24.r,
            child: PurchaseSearchBar(
              hintText: context.tr.searchForSuppliersByName,
              onChanged: (value) {
                context.read<SearchCubit<PurchaseSuppliersData>>().search(
                  value,
                  (item, query) => item.supplier.name.contains(query),
                );
              },
              onFilterTap: () {
                AppBottomSheet.customPageRoute(
                  context,
                  (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => getIt<FilterSuppliersCubit>(),
                      ),
                    ],
                    child: FilterSupplierWidget(
                      onApplyFilters: (availability, timeDelivery) {
                        _getSuppliers(
                          availability: availability,
                          timeDelivery: timeDelivery,
                        );
                      },
                      onResetFilters: () {
                        _getSuppliers();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child:
                  BlocBuilder<
                    GetPurchaseSuppliersCubit,
                    GetPurchaseSuppliersState
                  >(
                    builder: (context, state) {
                      if (state is GetPurchaseSuppliersLoading) {
                        return const AppLoadingWidget();
                      } else if (state is GetPurchaseSuppliersFailure) {
                        return AppFailureWidget(
                          failure: state.failure,
                          withBorder: false,
                          onRetry: _getSuppliers,
                        );
                      } else if (state is GetPurchaseSuppliersSuccess) {
                        context
                            .read<SearchCubit<PurchaseSuppliersData>>()
                            .setData(state.response.data);
                      }

                      return BlocBuilder<
                        SearchCubit<PurchaseSuppliersData>,
                        SearchState<PurchaseSuppliersData>
                      >(
                        builder: (context, searchState) {
                          if (searchState
                              is SearchSuccess<PurchaseSuppliersData>) {
                            final suppliers = searchState.results;

                            if (suppliers.isEmpty) {
                              return const AppSearchEmptyResultWidget();
                            }

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: suppliers.length,
                              itemBuilder: (context, index) {
                                return DirectSupplierListViewWidget(
                                  supplier: suppliers[index],
                                  quantity: widget.quantity,
                                  selectedIndex: index,
                                  sourceTypeFieldName:
                                      widget.sourceTypeFieldName,
                                  sourceIdFieldName: widget.sourceIdFieldName,
                                  sourceNameFieldName:
                                      widget.sourceNameFieldName,
                                  choosedSourceItemIdFieldName:
                                      widget.choosedSourceItemIdFieldName,
                                  addedItemMainId: widget.addedItemMainId,
                                );
                              },
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      );
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
