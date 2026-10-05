import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/custody/presentation/widgets/custody_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../shared/models/meta_model/meta_model.dart';
import '../../data/repositories/brand_owner_requests_repository.dart';
import '../../data/models/brand_owner_requests_models.dart';
import '../cubits/brand_owner_payment_log_cubit.dart';
import '../cubits/brand_owner_payment_log_state.dart';
import '../widgets/brand_owner_filter_payment_log.dart';
import 'brand_owner_payment_log_details_screen.dart';

class BrandOwnerPaymentLogScreen extends StatefulWidget {
  const BrandOwnerPaymentLogScreen({super.key});

  @override
  State<BrandOwnerPaymentLogScreen> createState() =>
      _BrandOwnerPaymentLogScreenState();
}

class _BrandOwnerPaymentLogScreenState
    extends State<BrandOwnerPaymentLogScreen> {
  late final BrandOwnerPaymentLogCubit _cubit;
  late final ScrollController _scrollController;

  BrandOwnerPaymentLogFilterQuery _currentFilterQuery =
      const BrandOwnerPaymentLogFilterQuery();

  // Kept for summary/meta while paginating
  BrandOwnerPaymentLogSummaryModel? _lastSummary;
  MetaModel? _lastMeta;

  @override
  void initState() {
    super.initState();
    _cubit = BrandOwnerPaymentLogCubit(getIt<BrandOwnerRequestsRepository>())
      ..getBrandOwnerPaymentLog();

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    final threshold = _scrollController.position.maxScrollExtent * 0.85;
    if (_scrollController.offset >= threshold) {
      _cubit.loadMore();
    }
  }

  Future<void> _openFilterSheet(BuildContext context) async {
    final result =
        await AppBottomSheet.customPageRoute<BrandOwnerPaymentLogFilterQuery>(
          context,
          (context) => BlocProvider(
            create: (context) => SearchCubit<BrandOwnerPaymentLogBranchItem>(),
            child: BrandOwnerFilterPaymentLog(
              paymentLogCubit: _cubit,
              initialQuery: _currentFilterQuery,
            ),
          ),
        );

    if (!mounted || result == null) {
      await _cubit.getBrandOwnerPaymentLog();

      return;
    }

    setState(() => _currentFilterQuery = result);

    await _cubit.getBrandOwnerPaymentLog(
      type: result.type,
      sortByDate: result.sortByDate,
      branchId: result.branchId,
    );
  }

  void _openDetails(String paymentLogId) {
    NavigationService.I.push(
      MaterialPageRoute(
        builder: (context) =>
            BrandOwnerPaymentLogDetailsScreen(paymentLogId: paymentLogId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.customColor.text2,
        body: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: CustodyAppBar(
                    title: context.tr.paymentLog,
                    subtitle: 'Track your payments to branch managers.',
                    titleColor: context.customColor.text1,
                    iconColor: context.customColor.text1,
                  ),
                ),
                AppPaddingWidget(
                  top: 30.r,
                  left: 0,
                  child: AppSvgButton(
                    assetName: AppAssets.filter,
                    onTap: () => _openFilterSheet(context),
                    iconColor: context.customColor.text1,
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocConsumer<BrandOwnerPaymentLogCubit, BrandOwnerPaymentLogState>(
                listenWhen: (_, current) =>
                    current is BrandOwnerPaymentLogSuccess,
                listener: (context, state) {
                  if (state is BrandOwnerPaymentLogSuccess) {
                    _lastSummary = state.summary;
                    _lastMeta = state.meta;
                  }
                },
                builder: (context, state) {
                  // ── full-screen loading (first fetch only) ──────────────
                  if (state is BrandOwnerPaymentLogLoading) {
                    return const AppLoadingWidget();
                  }

                  // ── full-screen error (only if we have no data yet) ─────
                  if (state is BrandOwnerPaymentLogFailure &&
                      _lastSummary == null) {
                    return AppFailureWidget(
                      failure: state.failure,
                      onRetry: () => _cubit.getBrandOwnerPaymentLog(),
                      withBorder: false,
                    );
                  }

                  // ── resolve list + summary from current or cached state ─
                  final List<BrandOwnerPaymentLogItemModel> items =
                      switch (state) {
                        BrandOwnerPaymentLogSuccess s => s.items,
                        BrandOwnerPaymentLogPaginating p => p.items,
                        _ => const [],
                      };

                  final summary = switch (state) {
                    BrandOwnerPaymentLogSuccess s => s.summary,
                    BrandOwnerPaymentLogPaginating p => p.summary,
                    _ => _lastSummary,
                  };

                  final isPaginating = state is BrandOwnerPaymentLogPaginating;
                  final hasPaginationError =
                      state is BrandOwnerPaymentLogFailure &&
                      _lastSummary != null;

                  if (summary == null) return const AppLoadingWidget();

                  return Container(
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        // ── summary row: cash in ──────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 2.w,
                                    color: AppColors.lightGreen,
                                  ),
                                  10.horizontalSpace,
                                  Flexible(
                                    child: Text(
                                      context.tr.totalCashIn,
                                      style: AppStyles.s12W400.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            5.horizontalSpace,
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SaudiRiyalSvgWidget(),
                                  2.horizontalSpace,
                                  Text(
                                    summary.totalCashIn.toStringAsFixed(2),
                                    style: AppStyles.s12W500.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        // ── summary row: cash out ─────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 2.w,
                                    color: context.customColor.error,
                                  ),
                                  10.horizontalSpace,
                                  Flexible(
                                    child: Text(
                                      context.tr.totalCashOut,
                                      style: AppStyles.s12W400.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            5.horizontalSpace,
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SaudiRiyalSvgWidget(),
                                  2.horizontalSpace,
                                  Text(
                                    summary.totalCashOut.toStringAsFixed(2),
                                    style: AppStyles.s12W500.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        // ── list ──────────────────────────────────────────
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.customColor.text2,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.all(8.r),
                            child: items.isEmpty && !isPaginating
                                ? Center(
                                    child: Text(
                                      context.tr.noRequestsYet,
                                      style: AppStyles.s14W400.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    controller: _scrollController,
                                    padding: EdgeInsets.zero,
                                    // +1 for the bottom indicator slot
                                    itemCount: items.length + 1,
                                    itemBuilder: (context, index) {
                                      // ── bottom slot ───────────────────
                                      if (index == items.length) {
                                        if (isPaginating) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16.r,
                                            ),
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                        if (hasPaginationError) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12.r,
                                            ),
                                            child: Center(
                                              child: TextButton.icon(
                                                onPressed: _cubit.loadMore,
                                                icon: const Icon(Icons.refresh),
                                                label: Text(
                                                  context.tr.retry,
                                                  style: AppStyles.s13W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text1,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        // No more pages – render nothing
                                        return const SizedBox.shrink();
                                      }

                                      // ── item ──────────────────────────
                                      final item = items[index];
                                      return AppGestureDetectorButton(
                                        onTap: () => _openDetails(item.id),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: context
                                                .customColor
                                                .reversedTextColor,
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(12.r),
                                          margin: EdgeInsets.only(
                                            bottom: index == items.length - 1
                                                ? 0
                                                : 10.r,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      context.customColor.text2,
                                                ),
                                                padding: EdgeInsets.all(8.r),
                                                child: AppSvg(
                                                  assetName: item.isIncome
                                                      ? AppAssets.bankSvg
                                                      : AppAssets.cash,
                                                  width: 15.r,
                                                  colorFilter: ColorFilter.mode(
                                                    context.customColor.text1,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                              10.horizontalSpace,
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.title,
                                                            style: AppStyles
                                                                .s15W500
                                                                .copyWith(
                                                                  color: context
                                                                      .customColor
                                                                      .text1,
                                                                ),
                                                          ),
                                                          Text(
                                                            item.branchName,
                                                            style: AppStyles
                                                                .s13W400
                                                                .copyWith(
                                                                  color: context
                                                                      .customColor
                                                                      .text3,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    5.horizontalSpace,
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              const SaudiRiyalSvgWidget(),
                                                              Text(
                                                                item.isIncome
                                                                    ? item.amount
                                                                          .toStringAsFixed(
                                                                            2,
                                                                          )
                                                                    : '-${item.amount.toStringAsFixed(2)}',
                                                                style: AppStyles.s12W500.copyWith(
                                                                  color:
                                                                      item.isIncome
                                                                      ? AppColors
                                                                            .lightGreen
                                                                      : context
                                                                            .customColor
                                                                            .error,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            item.dateTime,
                                                            style: AppStyles
                                                                .s13W400
                                                                .copyWith(
                                                                  color: context
                                                                      .customColor
                                                                      .text3,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
