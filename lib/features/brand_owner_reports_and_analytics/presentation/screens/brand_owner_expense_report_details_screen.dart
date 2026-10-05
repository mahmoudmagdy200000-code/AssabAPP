import 'dart:math';

import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_icon_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/enums/custody_preferred_receipt_method.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../brand_owner_requests/data/models/brand_owner_requests_models.dart';
import '../../../brand_owner_requests/presentation/cubits/brand_owner_payment_log_cubit.dart';
import '../../domain/entities/brand_owner_expense_report_details_entity.dart';
import '../../domain/entities/brand_owner_expense_report_filter_entity.dart';
import '../../domain/enums/brand_owner_expense_report_type.dart';
import '../../domain/enums/brand_owner_expenses_payment_methods_enum.dart';
import '../../domain/enums/expenses_requests_tax_non_tax_enum.dart';
import '../cubit/brand_owner_expense_report_details_cubit.dart';
import '../cubit/brand_owner_expense_report_details_state.dart';
import '../cubit/export_expense_report_cubit.dart';
import '../widgets/brand_owner_export_expense_report_bottom_sheet.dart';
import '../widgets/brand_owner_filter_expense_report_bottom_sheet.dart';

// ─────────────────────────────────────────────
//  Staggered Animated Card
// ─────────────────────────────────────────────

/// Wraps any child in a fade + slide-up entrance animation.
/// [index] controls the stagger delay (each card is 80 ms apart).
class _StaggeredCard extends StatefulWidget {
  final int index;
  final Widget child;
  const _StaggeredCard({required this.index, required this.child});

  @override
  State<_StaggeredCard> createState() => _StaggeredCardState();
}

class _StaggeredCardState extends State<_StaggeredCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    // stagger: 80 ms × index
    Future.delayed(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fade,
    child: SlideTransition(position: _slide, child: widget.child),
  );
}

// ─────────────────────────────────────────────
//  Animated Branch Bar
// ─────────────────────────────────────────────

/// A single branch row whose bar animates from 0 → target width on mount.
class _AnimatedBranchRow extends StatefulWidget {
  final ExpenseReportBranchComparisonEntity item;
  final Color color;
  final String Function(double) formatAmount;

  const _AnimatedBranchRow({
    required this.item,
    required this.color,
    required this.formatAmount,
  });

  @override
  State<_AnimatedBranchRow> createState() => _AnimatedBranchRowState();
}

class _AnimatedBranchRowState extends State<_AnimatedBranchRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _widthAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _widthAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    // slight delay so the card entrance finishes first
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratio = widget.item.maxAmount == 0
        ? 0.0
        : widget.item.amount / widget.item.maxAmount;

    return Row(
      children: [
        SizedBox(
          width: 60.r,
          child: Text(
            widget.item.name,
            style: AppStyles.s10W500.copyWith(
              color: context.customColor.text3,
              height: 1.3,
            ),
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              return AnimatedBuilder(
                animation: _widthAnim,
                builder: (_, __) {
                  final barWidth =
                      (constraints.maxWidth * ratio * _widthAnim.value).clamp(
                        0.0,
                        constraints.maxWidth,
                      );
                  return Stack(
                    children: [
                      // Track
                      Container(
                        height: 28.r,
                        decoration: BoxDecoration(
                          color: context.customColor.text2,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      // Fill
                      Container(
                        height: 28.r,
                        width: barWidth.clamp(0.0, constraints.maxWidth),
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        8.horizontalSpace,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SaudiRiyalSvgWidget(color: context.customColor.text1, size: 12.r),
            4.horizontalSpace,
            Text(
              widget.formatAmount(widget.item.amount),
              style: AppStyles.s10W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Pulsing Trend Badge
// ─────────────────────────────────────────────

/// The trend badge that does a subtle scale-pulse on mount.
class _TrendBadge extends StatefulWidget {
  final String percent;
  final String label;
  final bool isUp;

  const _TrendBadge({
    required this.percent,
    required this.label,
    required this.isUp,
  });

  @override
  State<_TrendBadge> createState() => _TrendBadgeState();
}

class _TrendBadgeState extends State<_TrendBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.08), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = widget.isUp ? AppColors.lightGreen : AppColors.red;
    final textColor = widget.isUp ? AppColors.darkGreen : AppColors.red;

    return Row(
      children: [
        ScaleTransition(
          scale: _scale,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppSvg(
                  assetName: AppAssets.redShort,
                  width: 12.r,
                  colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
                ),
                5.horizontalSpace,
                Text(
                  widget.percent,
                  style: AppStyles.s11W600.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ),
        6.horizontalSpace,
        Text(
          widget.label,
          style: AppStyles.s10W500.copyWith(
            color: context.customColor.text3,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Animated Payment Log Row
// ─────────────────────────────────────────────

/// A payment log row that slides in from the right.
class _AnimatedPaymentLogRow extends StatefulWidget {
  final ExpenseReportPaymentLogEntity log;
  final int index;
  final String Function(double) formatAmount;
  final BrandOwnerExpensesPaymentMethodsEnum Function(String) methodResolver;

  const _AnimatedPaymentLogRow({
    required this.log,
    required this.index,
    required this.formatAmount,
    required this.methodResolver,
  });

  @override
  State<_AnimatedPaymentLogRow> createState() => _AnimatedPaymentLogRowState();
}

class _AnimatedPaymentLogRowState extends State<_AnimatedPaymentLogRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0.04, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final method = widget.methodResolver(widget.log.method);
    final amountColor = widget.log.amount < 0
        ? AppColors.red
        : AppColors.darkGreen;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.r),
          child: Row(
            children: [
              AppSvg(assetName: method.icon, width: 24.r),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.label(context),
                      style: AppStyles.s12W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    Text(
                      '${widget.log.branch} · ${widget.log.dateTime}',
                      style: AppStyles.s10W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SaudiRiyalSvgWidget(),
                  4.horizontalSpace,
                  Text(
                    widget.formatAmount(widget.log.amount),
                    style: AppStyles.s12W600.copyWith(color: amountColor),
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

// ─────────────────────────────────────────────
//  Active Filter Chip
// ─────────────────────────────────────────────

/// A filter chip with interactive active/inactive state.
class _FilterChip extends StatelessWidget {
  final String value;

  const _FilterChip({required this.value});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 8.r),
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              value,
              style: AppStyles.s12W500.copyWith(
                color: context.customColor.text1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          4.horizontalSpace,
          AnimatedRotation(
            turns: 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16.r,
              color: context.customColor.text1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Main Screen
// ─────────────────────────────────────────────
class BrandOwnerExpenseReportDetailsScreen extends StatefulWidget {
  final String reportId;
  final VoidCallback? onExportSuccess;

  const BrandOwnerExpenseReportDetailsScreen({
    super.key,
    required this.reportId,
    this.onExportSuccess,
  });

  @override
  State<BrandOwnerExpenseReportDetailsScreen> createState() =>
      _BrandOwnerExpenseReportDetailsScreenState();
}

class _BrandOwnerExpenseReportDetailsScreenState
    extends State<BrandOwnerExpenseReportDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pageAnimCtrl;
  late Animation<double> _pageFadeAnim;

  // Collapsible payment log
  bool _logExpanded = true;

  @override
  void initState() {
    super.initState();
    _pageAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pageFadeAnim = CurvedAnimation(
      parent: _pageAnimCtrl,
      curve: Curves.easeOut,
    );
    _pageAnimCtrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrandOwnerExpenseReportDetailsCubit>().loadReport(
        reportId: widget.reportId,
      );
    });
  }

  @override
  void dispose() {
    _pageAnimCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────
  String _formatAmount(double v) {
    final prefix = v < 0 ? '-' : '';
    final abs = v.abs();
    if (abs >= 1000) {
      final formatted = abs
          .toStringAsFixed(2)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
      return '$prefix$formatted';
    }
    return '$prefix${abs.toStringAsFixed(2)}';
  }

  BrandOwnerExpensesPaymentMethodsEnum _paymentMethodFromValue(String value) {
    return BrandOwnerExpensesPaymentMethodsEnum.fromValue(value);
  }

  ExpensesRequestsTaxNonTaxEnum _ratioTypeFromValue(String value) {
    return ExpensesRequestsTaxNonTaxEnum.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ExpensesRequestsTaxNonTaxEnum.tax,
    );
  }

  String _typeLabel(BuildContext context, BrandOwnerExpenseReportType? type) {
    return switch (type) {
      BrandOwnerExpenseReportType.quickCash => context.tr.quickCashExpense,
      BrandOwnerExpenseReportType.invoice => context.tr.singleInvoice,
      null => context.tr.all,
    };
  }

  String _periodLabel(ExpenseReportDateFilterEntity? date) {
    if (date == null) return 'Monthly';

    final monthName = DateFormatter.getMonthName(date.month);
    return '$monthName ${date.year}';
  }

  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: FadeTransition(
        opacity: _pageFadeAnim,
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child:
                  BlocBuilder<
                    BrandOwnerExpenseReportDetailsCubit,
                    BrandOwnerExpenseReportDetailsState
                  >(
                    builder: (context, state) {
                      return switch (state) {
                        BrandOwnerExpenseReportDetailsInitial() ||
                        BrandOwnerExpenseReportDetailsLoading() =>
                          const AppLoadingWidget(),
                        BrandOwnerExpenseReportDetailsFailure(:final failure) =>
                          AppFailureWidget(
                            failure: failure,
                            onRetry: () => context
                                .read<BrandOwnerExpenseReportDetailsCubit>()
                                .loadReport(reportId: widget.reportId),
                          ),
                        BrandOwnerExpenseReportDetailsSuccess(:final data) =>
                          _buildContent(context, data),
                      };
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    BrandOwnerExpenseReportDetailsEntity data,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      padding: EdgeInsets.all(16.r),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.h,
          children: [
            _buildFilterRow(data.filters, data.defaultBranch),
            _staggered(0, _buildSummaryCard(data.summary)),
            _staggered(1, _buildPaymentMethodCard(data.paymentMethods)),
            _staggered(2, _buildTopSuppliersCard(data.topSuppliers)),
            _staggered(3, _buildExpenseRatioCard(data.expenseRatios)),
            _staggered(4, _buildBranchComparisonCard(data.branchComparisons)),
            _staggered(5, _buildCashTransferLog(data.cashTransferLog)),
            _staggered(6, _buildQuickExpensesFooter(data.quickSummary)),
          ],
        ),
      ),
    );
  }

  /// Wraps a widget in the staggered-card entrance animation.
  Widget _staggered(int index, Widget child) =>
      _StaggeredCard(index: index, child: child);

  // ── App Bar ──────────────────────────────────
  Widget _buildAppBar() {
    return AppPaddingWidget(
      top: 30.r,
      child: Row(
        children: [
          const AppBackButton(),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.juneExpenseReportTitle,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                Text(
                  context.tr.trackEverySpendInOnePlace,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          ButtonTextIcon(
            onTap: () {
              AppBottomSheet.customPageRoute(
                context,
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => ValidationCubit(
                        requiredFields: {
                          'expenseType',
                          'formatType',
                          'year',
                          'monthNumber',
                        },
                      ),
                    ),
                    BlocProvider(
                      create: (context) => getIt<ExportExpenseReportCubit>(),
                    ),
                  ],
                  child: BrandOwnerExportExpenseReportBottomSheet(
                    onExportSuccess: widget.onExportSuccess,
                  ),
                ),
              );
            },
            label: context.tr.exportLabel,
            icon: AppSvg(
              assetName: AppAssets.download,
              width: 14.r,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            textStyle: AppStyles.s12W500.copyWith(
              color: context.customColor.text1,
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
            backgroundColor: context.customColor.reversedTextColor,
            borderColor: Colors.transparent,
            reversed: true,
            borderRadius: BorderRadius.circular(8.r),
            spaceBetweenTextAndIcon: 7,
          ),
        ],
      ),
    );
  }

  // ── Filter Row ───────────────────────────────
  Widget _buildFilterRow(
    BrandOwnerExpenseReportFilterEntity filters,
    ExpenseReportBranchEntity defaultBranch,
  ) {
    final labels = [
      _typeLabel(context, filters.type),
      _periodLabel(filters.date),
      filters.branchName ?? defaultBranch.name,
    ];

    return Row(
      children: [
        for (int i = 0; i < labels.length; i++) ...[
          Expanded(child: _FilterChip(value: labels[i])),
          if (i < labels.length - 1) 8.horizontalSpace,
        ],
        8.horizontalSpace,
        AppIconButton(
          icon: Icons.more_vert_rounded,
          onPressed: () {
            final brandOwnerPaymentLogCubit = context
                .read<BrandOwnerPaymentLogCubit>();
            final validationCubit = context.read<ValidationCubit>();
            final brandOwnerExpenseReportDetailsCubit = context
                .read<BrandOwnerExpenseReportDetailsCubit>();

            AppBottomSheet.customPageRoute(
              context,
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: brandOwnerPaymentLogCubit),
                  BlocProvider.value(value: validationCubit),
                  BlocProvider.value(
                    value: brandOwnerExpenseReportDetailsCubit,
                  ),
                  BlocProvider(
                    create: (context) =>
                        SearchCubit<BrandOwnerPaymentLogBranchItem>(),
                  ),
                ],
                child: BrandOwnerFilterExpenseReportBottomSheet(
                  reportId: widget.reportId,
                ),
              ),
            );
          },
          iconColor: context.customColor.text1,
          borderColor: context.customColor.border,
          borderRadius: 12.r,
          padding: 6.r,
          size: 20.r,
        ),
      ],
    );
  }

  // ── Summary Card ─────────────────────────────
  Widget _buildSummaryCard(ExpenseReportSummaryEntity summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  AppNetworkImage(
                    image: summary.branch.imageUrl,
                    width: 50.r,
                    height: 50.r,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  12.horizontalSpace,
                  Flexible(
                    child: Text(
                      context.tr.quickExpenseForBranch(summary.branch.name),
                      style: AppStyles.s13W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            10.horizontalSpace,
            Text(
              summary.periodLabel,
              textAlign: TextAlign.right,
              style: AppStyles.s11W500.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
        ),
        10.verticalSpace,
        const CustomDivider(),
        10.verticalSpace,
        Text(
          context.tr.totalQuickExpenseRequests,
          style: AppStyles.s16W500.copyWith(color: context.customColor.text3),
        ),
        6.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              context.tr.totalQuickExpenseCount(summary.totalRequests),
              style: AppStyles.s16W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            8.horizontalSpace,
            const Spacer(),
            Row(
              children: [
                SaudiRiyalSvgWidget(color: context.customColor.text1),
                4.horizontalSpace,
                Text(
                  _formatAmount(summary.totalAmount),
                  style: AppStyles.s22WB.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
          ],
        ),
        8.verticalSpace,
        _TrendBadge(
          percent: summary.trendPercent,
          label: summary.trendLabel,
          isUp: summary.trendIsUp,
        ),
      ],
    );
  }

  // ── Payment Method Card ──────────────────────
  Widget _buildPaymentMethodCard(
    List<ExpenseReportPaymentMethodEntity> methods,
  ) {
    final totalCount = methods.fold<int>(0, (sum, item) => sum + item.count);
    return _cardWrapper(
      title: context.tr.paymentMethodTitle,
      child: Column(
        children: [
          // Animated donut chart
          SizedBox(
            height: 220.h,
            child: _AnimatedDonutChart(
              segments: methods
                  .map(
                    (item) => DonutSegment(
                      value: item.amount,
                      color: _paymentMethodFromValue(
                        item.method,
                      ).color(context),
                    ),
                  )
                  .toList(),
              centerTitle: 'Cash vs Custody vs Supplier',
              centerSubtitle: context.tr.recordsCount(totalCount),
              titleColor: context.customColor.text1,
              subtitleColor: context.customColor.text3,
              strokeWidth: 28.r,
            ),
          ),
          16.verticalSpace,
          const CustomDivider(),
          12.verticalSpace,
          for (final item in methods) ...[
            _paymentMethodRow(item),
            8.verticalSpace,
          ],
        ],
      ),
    );
  }

  Widget _paymentMethodRow(ExpenseReportPaymentMethodEntity item) {
    final method = _paymentMethodFromValue(item.method);

    return Row(
      children: [
        Container(
          width: 4.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: method.color(context),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Text(
            '${method.label(context)} (${item.count})',
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SaudiRiyalSvgWidget(color: context.customColor.text1),
            4.horizontalSpace,
            Text(
              _formatAmount(item.amount),
              style: AppStyles.s12W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Top 5 Suppliers ──────────────────────────
  Widget _buildTopSuppliersCard(List<ExpenseReportSupplierEntity> suppliers) {
    return _cardWrapper(
      title: context.tr.topSuppliersTitle,
      titleAlignment: CrossAxisAlignment.start,
      child: Column(
        children: [
          for (int i = 0; i < suppliers.length; i++) ...[
            _supplierRow(suppliers[i], i),
            if (i < suppliers.length - 1) ...[
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
            ],
          ],
        ],
      ),
    );
  }

  Widget _supplierRow(ExpenseReportSupplierEntity item, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            item.name,
            style: AppStyles.s13W500.copyWith(color: context.customColor.text3),
          ),
        ),
        5.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SaudiRiyalSvgWidget(color: context.customColor.text3),
              4.horizontalSpace,
              Flexible(
                child: Text(
                  _formatAmount(item.amount),
                  style: AppStyles.s12W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Expense Ratio Card ───────────────────────
  Widget _buildExpenseRatioCard(List<ExpenseReportRatioEntity> ratioItems) {
    final totalCount = ratioItems.fold<int>(0, (sum, item) => sum + item.count);

    return _cardWrapper(
      title: context.tr.expenseRequestRatioTitle,
      child: Column(
        children: [
          SizedBox(
            height: 220.h,
            child: _AnimatedDonutChart(
              segments: ratioItems
                  .map(
                    (item) => DonutSegment(
                      value: item.amount,
                      color: _ratioTypeFromValue(
                        item.type,
                      ).expensesColor(context),
                    ),
                  )
                  .toList(),
              centerTitle: context.tr.taxVsNonTaxInvoiceRatio,
              centerSubtitle: context.tr.requestsCount(totalCount),
              titleColor: context.customColor.text1,
              subtitleColor: context.customColor.text3,
              strokeWidth: 28.r,
            ),
          ),
          16.verticalSpace,
          const CustomDivider(),
          12.verticalSpace,
          for (final item in ratioItems) ...[
            _expenseRatioRow(item),
            8.verticalSpace,
          ],
        ],
      ),
    );
  }

  Widget _expenseRatioRow(ExpenseReportRatioEntity item) {
    final type = _ratioTypeFromValue(item.type);

    return Row(
      children: [
        Container(
          width: 4.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: type.expensesColor(context),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Text(
            '${type.expensesLabel(context)} (${item.count})',
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SaudiRiyalSvgWidget(color: context.customColor.text1),
            4.horizontalSpace,
            Text(
              _formatAmount(item.amount),
              style: AppStyles.s12W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Branch Comparison ────────────────────────
  Widget _buildBranchComparisonCard(
    List<ExpenseReportBranchComparisonEntity> branches,
  ) {
    final redShades = [
      AppColors.red,
      AppColors.red.withOpacity(0.85),
      AppColors.red.withOpacity(0.7),
      AppColors.red.withOpacity(0.5),
      AppColors.red.withOpacity(0.3),
    ];

    return _cardWrapper(
      title: context.tr.branchComparisonReportsTitle,
      titleAlignment: CrossAxisAlignment.start,
      child: Column(
        children: [
          4.verticalSpace,
          for (int i = 0; i < branches.length; i++) ...[
            _AnimatedBranchRow(
              item: branches[i],
              color: redShades[i % redShades.length],
              formatAmount: _formatAmount,
            ),
            10.verticalSpace,
          ],
        ],
      ),
    );
  }

  // ── Cash Transfer Log ────────────────────────
  Widget _buildCashTransferLog(ExpenseReportCashTransferLogEntity log) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header with collapse toggle ──
          GestureDetector(
            onTap: () => setState(() => _logExpanded = !_logExpanded),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr.cashTransferAndOwnerPaymentLog,
                    style: AppStyles.s14W600.copyWith(
                      color: context.customColor.text1,
                      height: 1.3,
                    ),
                  ),
                ),
                Text(
                  context.tr.cashTransferCount(log.count),
                  style: AppStyles.s13W600.copyWith(
                    color: context.theme.primaryColor,
                  ),
                ),
                8.horizontalSpace,
                AnimatedRotation(
                  turns: _logExpanded ? 0 : 0.5,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 20.r,
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          12.verticalSpace,
          const CustomDivider(),
          12.verticalSpace,

          // ── Cash In / Out Summary ──
          Row(
            children: [
              Container(
                width: 3.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: AppColors.darkGreen,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  context.tr.totalCashIn,
                  style: AppStyles.s12W500.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SaudiRiyalSvgWidget(),
                  4.horizontalSpace,
                  Text(
                    _formatAmount(log.totalCashIn),
                    style: AppStyles.s13W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          8.verticalSpace,
          Row(
            children: [
              Container(
                width: 3.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  context.tr.totalCashOut,
                  style: AppStyles.s12W500.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SaudiRiyalSvgWidget(),
                  4.horizontalSpace,
                  Text(
                    _formatAmount(log.totalCashOut),
                    style: AppStyles.s13W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ── Animated Collapsible Log Items ──
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.easeOut,
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeIn,
            crossFadeState: _logExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                16.verticalSpace,
                const CustomDivider(),
                12.verticalSpace,
                for (int i = 0; i < log.logs.length; i++) ...[
                  _AnimatedPaymentLogRow(
                    log: log.logs[i],
                    index: i,
                    formatAmount: _formatAmount,
                    methodResolver: _paymentMethodFromValue,
                  ),
                  if (i < log.logs.length - 1) ...[
                    const CustomDivider(),
                    8.verticalSpace,
                  ],
                ],
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── Quick Expenses Footer ────────────────────
  Widget _buildQuickExpensesFooter(ExpenseReportQuickSummaryEntity summary) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  context.tr.quickExpensesReportTitle,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
              10.horizontalSpace,
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SaudiRiyalSvgWidget(color: context.customColor.text1),
                    4.horizontalSpace,
                    Flexible(
                      child: Text(
                        _formatAmount(summary.amount),
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _TrendBadge(
            percent: summary.trendPercent,
            label: summary.trendLabel,
            isUp: summary.trendIsUp,
          ),
        ],
      ),
    );
  }

  // ── Generic Card Wrapper ─────────────────────
  Widget _cardWrapper({
    required String title,
    required Widget child,
    CrossAxisAlignment titleAlignment = CrossAxisAlignment.center,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Column(
        crossAxisAlignment: titleAlignment,
        children: [
          Text(
            title,
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Animated Donut Chart Widget
// ─────────────────────────────────────────────

/// A StatefulWidget that animates the donut chart sweep from 0 → full.
class _AnimatedDonutChart extends StatefulWidget {
  final List<DonutSegment> segments;
  final String centerTitle;
  final String centerSubtitle;
  final Color titleColor;
  final Color subtitleColor;
  final double strokeWidth;

  const _AnimatedDonutChart({
    required this.segments,
    required this.centerTitle,
    required this.centerSubtitle,
    required this.titleColor,
    required this.subtitleColor,
    this.strokeWidth = 28,
  });

  @override
  State<_AnimatedDonutChart> createState() => _AnimatedDonutChartState();
}

class _AnimatedDonutChartState extends State<_AnimatedDonutChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _sweep;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _sweep = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    // delay slightly so the card entrance is visible first
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sweep,
      builder: (_, __) => CustomPaint(
        painter: DonutChartPainter(
          segments: widget.segments,
          centerTitle: widget.centerTitle,
          centerSubtitle: widget.centerSubtitle,
          titleColor: widget.titleColor,
          subtitleColor: widget.subtitleColor,
          strokeWidth: widget.strokeWidth,
          // progress drives how much of the full arc is drawn
          progress: _sweep.value,
        ),
        size: Size(double.infinity, 160.r),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Donut Chart Custom Painter  (progress-aware)
// ─────────────────────────────────────────────
class DonutSegment {
  final double value;
  final Color color;
  const DonutSegment({required this.value, required this.color});
}

class DonutChartPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final String centerTitle;
  final String centerSubtitle;
  final Color titleColor;
  final Color subtitleColor;
  final double strokeWidth;

  /// 0.0 → 1.0: how much of the arc has been drawn (for entrance animation).
  final double progress;

  const DonutChartPainter({
    required this.segments,
    required this.centerTitle,
    required this.centerSubtitle,
    required this.titleColor,
    required this.subtitleColor,
    this.strokeWidth = 28,
    this.progress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) / 2) - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final total = segments.fold<double>(0, (s, e) => s + e.value);
    double startAngle = -pi / 2;

    for (final seg in segments) {
      // Full sweep for this segment, scaled by progress
      final fullSweep = (seg.value / total) * 2 * pi;
      final animatedSweep = fullSweep * progress;

      if (animatedSweep <= 0) {
        startAngle += fullSweep;
        continue;
      }

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = seg.color;

      // Gap only when the arc is long enough
      final gap = animatedSweep > 0.08 ? 0.04 : 0.0;
      canvas.drawArc(rect, startAngle, animatedSweep - gap, false, paint);
      startAngle += fullSweep;
    }

    // Center text fades in with progress
    final textOpacity = (progress * 3 - 2).clamp(0.0, 1.0);
    if (textOpacity <= 0) return;

    final titleSpan = TextSpan(
      text: centerTitle,
      style: AppStyles.s12W600.copyWith(
        color: titleColor.withOpacity(textOpacity),
        height: 1.4,
      ),
    );
    final titlePainter = TextPainter(
      text: titleSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: radius * 1.2);
    titlePainter.paint(
      canvas,
      center - Offset(titlePainter.width / 2, titlePainter.height / 2 + 8),
    );

    final subtitleSpan = TextSpan(
      text: centerSubtitle,
      style: AppStyles.s10W500.copyWith(
        color: subtitleColor.withOpacity(textOpacity),
      ),
    );
    final subtitlePainter = TextPainter(
      text: subtitleSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: radius * 1.2);
    subtitlePainter.paint(
      canvas,
      center -
          Offset(
            subtitlePainter.width / 2,
            subtitlePainter.height / 2 - titlePainter.height / 2 - 4,
          ),
    );
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter old) =>
      old.segments != segments ||
      old.centerTitle != centerTitle ||
      old.centerSubtitle != centerSubtitle ||
      old.titleColor != titleColor ||
      old.subtitleColor != subtitleColor ||
      old.strokeWidth != strokeWidth ||
      old.progress != progress;
}
