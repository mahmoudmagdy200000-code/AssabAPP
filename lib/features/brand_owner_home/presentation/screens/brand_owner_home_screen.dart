import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../branch_manager_home/presentation/widgets/branch_manager_action_button.dart';
import '../../data/models/brand_owner_home_data_model.dart';
import '../cubit/brand_owner_branches/brand_owner_branches_cubit.dart';
import '../cubit/brand_owner_home/brand_owner_home_cubit.dart';
import '../cubit/brand_owner_home/brand_owner_home_state.dart';
import '../widgets/bran_owner_home_top_section.dart';
import '../widgets/brand_owner_choos_branch_bottom_sheet.dart';
import '../widgets/brand_owner_choose_data_dashboard_bottom_sheet.dart';
import '../widgets/brand_owner_expenses_trend_state_chart_section.dart';

class BrandOwnerHomeScreen extends StatefulWidget {
  const BrandOwnerHomeScreen({super.key});

  @override
  State<BrandOwnerHomeScreen> createState() => _BrandOwnerHomeScreenState();
}

class _BrandOwnerHomeScreenState extends State<BrandOwnerHomeScreen> {
  late PagingCubit _granularityPagingCubit;

  static const _granularities = ['daily', 'weekly', 'monthly'];

  @override
  void initState() {
    super.initState();

    _granularityPagingCubit = PagingCubit(totalSteps: 3);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrandOwnerHomeCubit>().loadDashboard();
    });
  }

  @override
  void dispose() {
    _granularityPagingCubit.close();
    super.dispose();
  }

  void _onGranularityChanged(int index) {
    _granularityPagingCubit.goToStep(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BrandOwnerHomeCubit, BrandOwnerHomeState>(
        builder: (context, state) => switch (state) {
          BrandOwnerHomeInitial() ||
          BrandOwnerHomeLoading() => const AppLoadingWidget(),
          BrandOwnerHomeFailure() => AppFailureWidget(
            failure: state.failure,
            onRetry: () {
              context.read<BrandOwnerHomeCubit>().loadDashboard();
            },
          ),
          BrandOwnerHomeSuccess(:final data) => _buildBody(context, data),
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, BrandOwnerHomeDataModel data) {
    return Column(
      children: [
        const BranOwnerHomeTopSection(),
        Expanded(
          child: Container(
            color: context.customColor.text2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        ContainerCustomTextField(
                          padding: EdgeInsets.all(5.r),
                          borderColor: context.customColor.reversedTextColor,
                          borderRadius: BorderRadius.circular(1000.r),
                          child: Row(
                            children: [
                              AppGestureDetectorButton(
                                onTap: () {
                                  final validationCubit = context
                                      .read<ValidationCubit>();
                                  final brandOwnerHomeCubit = context
                                      .read<BrandOwnerHomeCubit>();

                                  AppBottomSheet.customPageRoute(
                                    context,
                                    (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(
                                          value: validationCubit,
                                        ),
                                        BlocProvider(
                                          create: (context) =>
                                              getIt<BrandOwnerBranchesCubit>()
                                                ..loadBranches(),
                                        ),
                                        BlocProvider.value(
                                          value: brandOwnerHomeCubit,
                                        ),
                                      ],
                                      child:
                                          const BrandOwnerChoosBranchBottomSheet(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        context.customColor.reversedTextColor,
                                    borderRadius: BorderRadius.circular(1000.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.r,
                                    vertical: 6.r,
                                  ),
                                  child: Row(
                                    children: [
                                      AppSvg(
                                        assetName: AppAssets.branchStoreSvg,
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        data.responseBranchName,
                                        style: AppStyles.s12W400.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      5.horizontalSpace,
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: context.customColor.text1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: AppGestureDetectorButton(
                                  onTap: () {
                                    final validationCubit = context
                                        .read<ValidationCubit>();
                                    final brandOwnerHomeCubit = context
                                        .read<BrandOwnerHomeCubit>();

                                    AppBottomSheet.customPageRoute(
                                      context,
                                      (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(
                                            value: validationCubit,
                                          ),

                                          BlocProvider.value(
                                            value: brandOwnerHomeCubit,
                                          ),
                                        ],
                                        child:
                                            const BrandOwnerChooseDataDashboardBottomSheet(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          context.customColor.reversedTextColor,
                                      borderRadius: BorderRadius.circular(
                                        1000.r,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.r,
                                      vertical: 6.r,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            _monthName(data.responseMonth),
                                            style: AppStyles.s12W400.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        5.horizontalSpace,
                                        Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: context.customColor.text1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        12.verticalSpace,
                        SizedBox(
                          height: 250.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildListViewItem(
                                context,
                                title: context.tr.invoicesSummary,
                                approved: data.approvedInvoices.toString(),
                                totalAmount: data.totalInvoiceAmount
                                    .toStringAsFixed(0),
                                increasePercentage: '+${data.pendingInvoices}%',
                                pending: data.pendingInvoices.toString(),
                              ),
                              10.horizontalSpace,
                              _buildListViewItem(
                                context,
                                title: context.tr.expensesSummary,
                                approved: data.approvedExpenses.toString(),
                                totalAmount: data.totalExpenseAmount
                                    .toStringAsFixed(0),
                                increasePercentage: '+${data.pendingExpenses}%',
                                pending: data.pendingExpenses.toString(),
                              ),
                            ],
                          ),
                        ),
                        12.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.reversedTextColor,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.all(12.r),
                          child: Row(
                            spacing: 10.w,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BranchManagerActionButton(
                                assetName: AppAssets.box,
                                label: context.tr.startInventory,
                                onTap: () {},
                              ),
                              BranchManagerActionButton(
                                assetName: AppAssets.home,
                                label: context.tr.bankTransfer,
                                onTap: () {
                                  NavigationService.I.pushNamed(
                                    AppRouteName.brandOwnerPaymentScreen,
                                  );
                                },
                              ),
                              BranchManagerActionButton(
                                assetName: AppAssets.cash,
                                label: context.tr.cashHandover,
                                onTap: () {
                                  NavigationService.I.pushNamed(
                                    AppRouteName.brandOwnerPaymentScreen,
                                  );
                                },
                              ),
                              BranchManagerActionButton(
                                assetName: AppAssets.wait,
                                label: context.tr.escalationRequests,
                                onTap: () {
                                  NavigationService.I.pushNamed(
                                    AppRouteName
                                        .brandOwnerEscalationRequestsScreen,
                                  );
                                },
                              ),
                              BranchManagerActionButton(
                                assetName: AppAssets.viewReports,
                                label: context.tr.reportsAndAnalytics,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        Row(
                          spacing: 10.w,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                context.tr.expenseTrends,
                                style: AppStyles.s16W600.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ),
                            Text(
                              '${_monthName(data.responseMonth)} ${data.responseYear}',
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text4,
                              ),
                            ),
                          ],
                        ),
                        12.verticalSpace,
                        BlocProvider.value(
                          value: _granularityPagingCubit,
                          child: Row(
                            spacing: 10.w,
                            children: List.generate(3, (index) {
                              final texts = [
                                context.tr.trendStatsDaily,
                                context.tr.trendStatsWeekly,
                                context.tr.trendStatsMonthly,
                              ];

                              return Expanded(
                                child:
                                    BlocSelector<PagingCubit, PagingState, int>(
                                      selector: (state) => state.currentIndex,
                                      builder: (context, selectedIndex) {
                                        final isSelected =
                                            selectedIndex == index;

                                        return CustomTextButton(
                                          text: texts[index],
                                          onTap: () =>
                                              _onGranularityChanged(index),
                                          borderRadius: 1000.r,
                                          textColor: isSelected
                                              ? context.theme.primaryColor
                                              : context.customColor.text3,
                                          borderColor: isSelected
                                              ? context.theme.primaryColor
                                              : context.customColor.border,
                                        );
                                      },
                                    ),
                              );
                            }),
                          ),
                        ),
                        12.verticalSpace,
                        _buildExpensesTrendContent(context, data),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesTrendContent(
    BuildContext context,
    BrandOwnerHomeDataModel data,
  ) {
    return BlocSelector<PagingCubit, PagingState, int>(
      bloc: _granularityPagingCubit,
      selector: (state) => state.currentIndex,
      builder: (context, index) {
        final granularity = _granularities[index];
        final trend = data.trendFor(granularity);

        if (trend == null) return const SizedBox.shrink();

        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: context.customColor.border),
              ),
              child: Column(
                spacing: 12.h,
                children: [
                  _buildRow(
                    context: context,
                    title: context.tr.trendStatsTimeline,
                    value: trend.trendPeriod,
                  ),
                  const CustomDivider(),
                  Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          context.tr.approved,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          trend.approved.toString(),
                          style: AppStyles.s12W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const CustomDivider(),
                  Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          context.tr.totalAmount,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SaudiRiyalSvgWidget(),
                            2.horizontalSpace,
                            Flexible(
                              child: Text(
                                trend.totalAmount.toStringAsFixed(0),
                                style: AppStyles.s12W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: context.customColor.text2,
                          borderRadius: BorderRadius.circular(1000.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.r,
                          vertical: 4.r,
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: context.customColor.dark,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(7.r),
                              child: AppSvg(
                                assetName: AppAssets.over,
                                colorFilter: ColorFilter.mode(
                                  context.customColor.reversedTextColor,
                                  BlendMode.srcIn,
                                ),
                                width: 8.r,
                              ),
                            ),
                            5.horizontalSpace,
                            Text(
                              '+${trend.increasePercentage.toStringAsFixed(1)}%',
                              style: AppStyles.s13W400.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Text(
                          context.tr.noIncreaseFromLastMonth.toUpperCase(),
                          style: AppStyles.s12W500.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BrandOwnerExpensesTrendStateChartSection(
              expenseChart: trend.chartData,
              granularity: granularity,
              responseMonth: data.responseMonth,
              responseYear: data.responseYear,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 10.w,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }

  Widget _buildListViewItem(
    BuildContext context, {
    required String title,
    required String approved,
    required String totalAmount,
    required String increasePercentage,
    required String pending,
  }) {
    return Container(
      width: 250.w,
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyles.s16W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            5.verticalSpace,
            const CustomDivider(),
            5.verticalSpace,
            Row(
              spacing: 10.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    context.tr.approved,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    approved,
                    style: AppStyles.s12W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            const CustomDivider(),
            5.verticalSpace,
            Row(
              spacing: 10.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    context.tr.totalAmount,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    totalAmount,
                    style: AppStyles.s12W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            const CustomDivider(),
            5.verticalSpace,
            Row(
              spacing: 10.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(1000.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: context.customColor.dark,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(7.r),
                        child: AppSvg(
                          assetName: AppAssets.over,
                          colorFilter: ColorFilter.mode(
                            context.customColor.reversedTextColor,
                            BlendMode.srcIn,
                          ),
                          width: 8.r,
                        ),
                      ),
                      5.horizontalSpace,
                      Text(
                        increasePercentage,
                        style: AppStyles.s13W400.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Text(
                    context.tr.noIncreaseFromLastMonth.toUpperCase(),
                    style: AppStyles.s12W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: context.customColor.text2,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(12.r),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 10.w,
                    children: [
                      Flexible(
                        child: Text(
                          context.tr.pending,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          pending,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  CustomTextButton(
                    onTap: () {
                      context.read<PagingCubit>().goToStep(2);
                    },
                    text: context.tr.goToRequests,
                    textColor: context.customColor.text1,
                    backgroundColor: context.customColor.reversedTextColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _monthNames = [
  '',
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String _monthName(int month) {
  return _monthNames[month.clamp(1, 12)];
}
