import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/search/search_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_search_empty_result_widget.dart';
import 'package:assab/features/purchase/data/models/purchase_branches_response.dart';
import 'package:assab/features/purchase/presentation/cubit/filter_branches/filter_branches_state.dart';
import 'package:assab/features/purchase/presentation/cubit/get_purchase_branches/get_purchase_branches_cubit.dart';
import 'package:assab/features/purchase/presentation/cubit/get_purchase_branches/get_purchase_branches_state.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/purchase_branch_availability_enum.dart';
import '../../../../core/enums/purchase_response_time_enum.dart';
import '../../data/models/purchase_branch_items_response.dart';
import '../cubit/filter_branches/filter_branches_cubit.dart';
import '../widgets/choose_branch_list_view_widget.dart';
import '../widgets/filter_branch_widget.dart';
import '../widgets/purchase_app_bar.dart';

class ChooseBranchScreen extends StatefulWidget {
  final PurchaseBranchItemData item;
  final int quantity;
  final String sourceTypeFieldName;
  final String sourceIdFieldName;
  final String sourceNameFieldName;
  final String choosedSourceItemIdFieldName;

  const ChooseBranchScreen({
    super.key,
    required this.item,
    required this.quantity,
    required this.sourceTypeFieldName,
    required this.sourceIdFieldName,
    required this.sourceNameFieldName,
    required this.choosedSourceItemIdFieldName,
  });

  @override
  State<ChooseBranchScreen> createState() => _ChooseBranchScreenState();
}

class _ChooseBranchScreenState extends State<ChooseBranchScreen> {
  @override
  void initState() {
    super.initState();

    _getBranches();
  }

  void _getBranches({
    String? availability,
    String? responseTime,
    String? distance,
  }) {
    context.read<GetPurchaseBranchesCubit>().getPurchaseBranches(
      itemId: widget.item.id,
      quantity: widget.quantity.toString(),
      availability: availability,
      responseTime: responseTime,
      distance: distance,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          10.verticalSpace,
          BlocSelector<
            SearchCubit<PurchaseBranchData>,
            SearchState<PurchaseBranchData>,
            int
          >(
            selector: (state) => state is SearchSuccess<PurchaseBranchData>
                ? state.results.length
                : 0,
            builder: (context, state) {
              return PurchaseAppBar(
                iconColor: context.customColor.text1,
                title: '${context.tr.allBranches} ($state)',
                titleColor: context.customColor.text1,
                subtitle: context.tr.chooseTheBranchForThisOrderRequest,
              );
            },
          ),
          AppPaddingWidget(
            top: 8.r,
            bottom: 24.r,
            child: BlocSelector<FilterBranchesCubit, FilterBranchesState, int>(
              selector: (state) {
                int count = 0;

                if (state.distance > 5) {
                  count++;
                }
                if (state.responseTime != PurchaseResponseTimeEnum.non) {
                  count++;
                }
                if (state.availability != PurchaseBranchAvailabilityEnum.non) {
                  count++;
                }

                return count;
              },
              builder: (context, countFilter) {
                return PurchaseSearchBar(
                  hintText: context.tr.searchForBranchByName,
                  onChanged: (value) {
                    context.read<SearchCubit<PurchaseBranchData>>().search(
                      value,
                      (item, query) => item.branch.name.contains(query),
                    );
                  },
                  countFilter: countFilter,
                  onFilterTap: () {
                    final filterCubit = context.read<FilterBranchesCubit>();
                    final getBranchesCubit = context
                        .read<GetPurchaseBranchesCubit>();

                    AppBottomSheet.customPageRoute(
                      context,
                      (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: filterCubit),
                          BlocProvider.value(value: getBranchesCubit),
                        ],
                        child: FilterBranchWidget(
                          item: widget.item,
                          quantity: widget.quantity,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child:
                  BlocConsumer<
                    GetPurchaseBranchesCubit,
                    GetPurchaseBranchesState
                  >(
                    listener: (context, state) {
                      if (state is GetPurchaseBranchesSuccess) {
                        context.read<SearchCubit<PurchaseBranchData>>().setData(
                          state.response.data,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is GetPurchaseBranchesLoading) {
                        return const AppLoadingWidget();
                      } else if (state is GetPurchaseBranchesFailure) {
                        return AppFailureWidget(
                          failure: state.failure,
                          withBorder: false,
                          onRetry: _getBranches,
                        );
                      }

                      return BlocBuilder<
                        SearchCubit<PurchaseBranchData>,
                        SearchState<PurchaseBranchData>
                      >(
                        builder: (context, state) {
                          if (state is SearchSuccess<PurchaseBranchData>) {
                            final branches = state.results;

                            if (branches.isEmpty) {
                              return const AppSearchEmptyResultWidget();
                            }

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: branches.length,
                              itemBuilder: (context, index) {
                                return ChooseBranchListViewWidget(
                                  branch: branches[index],
                                  item: widget.item,
                                  quantity: widget.quantity,
                                  selectedIndex: index,
                                  sourceTypeFieldName:
                                      widget.sourceTypeFieldName,
                                  sourceIdFieldName: widget.sourceIdFieldName,
                                  sourceNameFieldName:
                                      widget.sourceNameFieldName,
                                  choosedSourceItemIdFieldName:
                                      widget.choosedSourceItemIdFieldName,
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
