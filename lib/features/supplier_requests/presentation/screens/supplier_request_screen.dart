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

  Future<void> _pickDate({required bool isFrom}) async {
    final cubit = context.read<SupplierGetRequestsCubit>();
    final currentStr = isFrom ? cubit.dateFrom : cubit.dateTo;
    final initial = currentStr != null
        ? (DateTime.tryParse(currentStr) ?? DateTime.now())
        : DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked == null || !mounted) return;
    final formatted =
        '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    if (isFrom) {
      cubit.setDateRange(dateFrom: formatted, dateTo: cubit.dateTo);
    } else {
      cubit.setDateRange(dateFrom: cubit.dateFrom, dateTo: formatted);
    }
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
                child: Column(
                  children: [
                    _SupplierOrderFilterBar(
                      onPickDate: _pickDate,
                    ),
                    8.verticalSpace,
                    Expanded(
                      child: BlocBuilder<
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupplierOrderFilterBar extends StatelessWidget {
  final Future<void> Function({required bool isFrom}) onPickDate;

  const _SupplierOrderFilterBar({required this.onPickDate});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final statuses = <(String?, String)>[
      (null, isAr ? 'الكل' : 'All'),
      ('pending', isAr ? 'قيد الانتظار' : 'Pending'),
      ('confirmed', isAr ? 'مؤكد' : 'Confirmed'),
      ('preparing', isAr ? 'قيد التجهيز' : 'Preparing'),
      ('on_the_way', isAr ? 'في الطريق' : 'Out for Delivery'),
      ('delivered', isAr ? 'تم التوصيل' : 'Delivered'),
      (
        'cancelled_by_supplier',
        isAr ? 'ملغي من المورد' : 'Canceled by Supplier',
      ),
      ('closed', isAr ? 'مغلق' : 'Closed'),
    ];

    return BlocBuilder<SupplierGetRequestsCubit, SupplierGetRequestsState>(
      builder: (context, state) {
        final cubit = context.read<SupplierGetRequestsCubit>();
        final activeStatus = cubit.statusFilter;
        final dateFrom = cubit.dateFrom;
        final dateTo = cubit.dateTo;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: statuses.map((entry) {
                  final value = entry.$1;
                  final label = entry.$2;
                  final selected = activeStatus == value;
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 6.r),
                    child: ChoiceChip(
                      label: Text(
                        label,
                        style: AppStyles.s12W500.copyWith(
                          color: selected
                              ? context.customColor.reversedTextColor
                              : context.customColor.text1,
                        ),
                      ),
                      selected: selected,
                      selectedColor: context.theme.primaryColor,
                      backgroundColor: context.customColor.text2,
                      side: BorderSide.none,
                      onSelected: (_) => cubit.setStatusFilter(value),
                    ),
                  );
                }).toList(),
              ),
            ),
            6.verticalSpace,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => onPickDate(isFrom: true),
                    icon: const Icon(Icons.date_range, size: 16),
                    label: Text(
                      dateFrom ?? (isAr ? 'من تاريخ' : 'From Date'),
                      style: AppStyles.s12W400,
                    ),
                  ),
                  8.horizontalSpace,
                  OutlinedButton.icon(
                    onPressed: () => onPickDate(isFrom: false),
                    icon: const Icon(Icons.date_range, size: 16),
                    label: Text(
                      dateTo ?? (isAr ? 'إلى تاريخ' : 'To Date'),
                      style: AppStyles.s12W400,
                    ),
                  ),
                  if (cubit.hasActiveFilters) ...[
                    8.horizontalSpace,
                    TextButton.icon(
                      onPressed: cubit.clearFilters,
                      icon: const Icon(Icons.clear, size: 16),
                      label: Text(
                        isAr ? 'مسح الفلاتر' : 'Clear',
                        style: AppStyles.s12W500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
