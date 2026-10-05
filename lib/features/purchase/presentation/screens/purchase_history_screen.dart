import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_search_empty_result_widget.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/dynamic_steps/dynamic_steps_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/search/search_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../branch_manager_requests/presentation/cubit/get_order_details/get_order_details_cubit.dart';
import '../../../branch_manager_requests/presentation/screens/request_details_screen.dart';
import '../../data/models/purchase_history_response.dart';
import '../cubit/purchase_history/purchase_history_cubit.dart';
import '../cubit/purchase_history/purchase_history_state.dart';
import '../cubit/select_filter_purchase_history/select_filter_purchase_history_cubit.dart';
import '../widgets/filter_purchase_history_bottom_sheet_widget.dart';
import '../widgets/purchase_history_app_bar.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _getPurchaseHistory();

    _scrollController = ScrollController()
      ..addListener(_scrollControllerListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollControllerListener);

    _scrollController.dispose();
    super.dispose();
  }

  void _scrollControllerListener() {
    if (!_scrollController.position.outOfRange &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200.r) {
      final cubit = context.read<PurchaseHistoryCubit>();

      if (cubit.paginator.hasMore) {
        _getPurchaseHistory(loadMore: true);
      }
    }
  }

  void _getPurchaseHistory({
    bool loadMore = false,
    String? perspective,
    String? type,
    String? dateRange,
  }) {
    context.read<PurchaseHistoryCubit>().getPurchaseHistory(
      loadMore: loadMore,
      perspective: perspective,
      type: type,
      dateRange: dateRange,
    );
  }

  String _getPurchaseName(List<PurchaseHistoryDataItem> items) {
    String name = '';

    if (items.length == 1) {
      name = items.first.itemName;
    } else {
      name = '${items.length} ${context.tr.itemsRequired}';
    }

    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          const PurchaseHistoryAppBar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                children: [
                  AppPaddingWidget(
                    top: 13.r,
                    bottom: 13.r,
                    left: 15.r,
                    right: 15.r,
                    child: Builder(
                      builder: (scaffoldContext) {
                        return PurchaseSearchBar(
                          hintText: context.tr.egBeefOrder,
                          onChanged: (value) {
                            context
                                .read<SearchCubit<PurchaseHistoryData>>()
                                .search(
                                  value,
                                  (item, query) => item.items.any(
                                    (element) => element.itemName
                                        .toLowerCase()
                                        .contains(query.toLowerCase()),
                                  ),
                                );
                          },
                          onFilterTap: () {
                            AppBottomSheet.show(
                              scaffoldContext,
                              (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) =>
                                        getIt<
                                          SelectFilterPurchaseHistoryCubit
                                        >(),
                                  ),
                                ],
                                child: FilterPurchaseHistoryBottomSheetWidget(
                                  onClearFilters: () {
                                    _getPurchaseHistory();
                                  },
                                  onApplyFilters:
                                      (perspective, type, dateRange) {
                                        _getPurchaseHistory(
                                          perspective: perspective,
                                          type: type,
                                          dateRange: dateRange,
                                        );
                                      },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                      ),
                      padding: EdgeInsets.all(8.r),
                      margin: EdgeInsets.all(7.r),
                      child: BlocConsumer<PurchaseHistoryCubit, PurchaseHistoryState>(
                        listener: (context, state) {
                          if (state is PurchaseHistorySuccess) {
                            context
                                .read<SearchCubit<PurchaseHistoryData>>()
                                .setData(state.purchases);
                          }
                        },
                        builder: (context, state) {
                          if (state is PurchaseHistoryLoading) {
                            return const AppLoadingWidget();
                          } else if (state is PurchaseHistoryFailure) {
                            return AppFailureWidget(
                              failure: state.failure,
                              withBorder: false,
                              onRetry: _getPurchaseHistory,
                            );
                          }

                          return BlocBuilder<
                            SearchCubit<PurchaseHistoryData>,
                            SearchState<PurchaseHistoryData>
                          >(
                            builder: (context, searchState) {
                              if (searchState
                                  is SearchSuccess<PurchaseHistoryData>) {
                                final purchases = searchState.results;

                                if (purchases.isEmpty) {
                                  return const AppSearchEmptyResultWidget();
                                }

                                return ListView.builder(
                                  itemCount: purchases.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    final purchase = purchases[index];

                                    return AppGestureDetectorButton(
                                      onTap: () {
                                        NavigationService.I.push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MultiBlocProvider(
                                                  providers: [
                                                    BlocProvider(
                                                      create: (context) =>
                                                          PagingCubit(
                                                            totalSteps: 3,
                                                          ),
                                                    ),
                                                    BlocProvider(
                                                      create: (context) =>
                                                          getIt<
                                                            GetOrderDetailsCubit
                                                          >(),
                                                    ),
                                                    BlocProvider(
                                                      create: (context) =>
                                                          DynamicStepsCubit(),
                                                    ),
                                                    BlocProvider(
                                                      create: (context) =>
                                                          ValidationCubit(
                                                            requiredFields: {
                                                              'approval',
                                                              'timelines',
                                                            },
                                                          ),
                                                    ),
                                                  ],
                                                  child: RequestDetailsScreen(
                                                    id: purchase.id,
                                                    strategy:
                                                        purchase.orderType,
                                                  ),
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: context
                                              .customColor
                                              .reversedTextColor,
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.r,
                                          horizontal: 20.r,
                                        ),
                                        margin: EdgeInsets.only(bottom: 8.r),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    _getPurchaseName(
                                                      purchase.items,
                                                    ),
                                                    style: AppStyles.s13W600
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text1,
                                                        ),
                                                  ),
                                                ),
                                                10.horizontalSpace,
                                                purchase.status.buildStatus(
                                                  context,
                                                ),
                                              ],
                                            ),
                                            4.verticalSpace,
                                            purchase.orderType.buildRowType(
                                              context,
                                            ),
                                            4.verticalSpace,
                                            Text(
                                              '${DateFormatter.formatDateMDY(DateTime.tryParse(purchase.createdAt))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(purchase.createdAt))}',
                                              softWrap: true,
                                              style: AppStyles.s12W400.copyWith(
                                                color:
                                                    context.customColor.text3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
            ),
          ),
        ],
      ),
    );
  }
}
