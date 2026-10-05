import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/dynamic_steps/dynamic_steps_cubit.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../data/models/supplier_orders_response.dart';
import '../cubit/supplier_get_request_details/supplier_get_request_details_cubit.dart';
import '../cubit/supplier_get_requests/supplier_get_requests_cubit.dart';
import '../cubit/supplier_get_requests/supplier_get_requests_state.dart';
import '../widgets/supplier_item_requests_list_widget.dart';
import '../widgets/supplier_request_app_bar.dart';
import 'supplier_request_details_screen.dart';

class SupplierRequestScreen extends StatefulWidget {
  const SupplierRequestScreen({super.key});

  @override
  State<SupplierRequestScreen> createState() => _SupplierRequestScreenState();
}

class _SupplierRequestScreenState extends State<SupplierRequestScreen> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _getOrders();

    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenToScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _listenToScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.r) {
      if (context.read<SupplierGetRequestsCubit>().paginator.hasMore) {
        _getOrders(loadMore: true);
      }
    }
  }

  void _getOrders({bool loadMore = false}) {
    context.read<SupplierGetRequestsCubit>().getRequests(loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          const SupplierRequestAppBar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: AppPaddingWidget(
                top: 12.r,
                bottom: 12.r,
                left: 12.r,
                right: 12.r,
                child:
                    BlocBuilder<
                      SupplierGetRequestsCubit,
                      SupplierGetRequestsState
                    >(
                      builder: (context, state) {
                        final orders = <SupplierOrder>[];

                        if (state is SupplierGetRequestsLoading) {
                          return const AppLoadingWidget();
                        } else if (state is SupplierGetRequestsFailure) {
                          return AppFailureWidget(
                            failure: state.failure,
                            onRetry: _getOrders,
                            withBorder: false,
                          );
                        } else if (state is SupplierGetRequestsSuccess) {
                          orders.addAll(state.requests);
                        }

                        if (orders.isEmpty) {
                          return Center(
                            child: Text(
                              context.tr.noOrdersAvailable,
                              style: AppStyles.s15W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async => _getOrders(),
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: orders.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final orderOrRequest = orders[index];

                              return AppGestureDetectorButton(
                                onTap: () async {
                                  await NavigationService.I.push(
                                    MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (context) =>
                                                getIt<
                                                  SupplierGetRequestDetailsCubit
                                                >(),
                                          ),
                                          BlocProvider(
                                            create: (context) =>
                                                PagingCubit(totalSteps: 3),
                                          ),
                                          BlocProvider(
                                            create: (context) =>
                                                DynamicStepsCubit(),
                                          ),
                                        ],
                                        child: SupplierRequestDetailsScreen(
                                          id: orderOrRequest.id,
                                        ),
                                      ),
                                    ),
                                  );

                                  if (mounted) _getOrders();
                                },
                                child: SupplierItemRequestsListWidget(
                                  request: orderOrRequest,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
