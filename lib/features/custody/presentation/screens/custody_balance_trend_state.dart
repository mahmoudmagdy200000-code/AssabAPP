import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/custody/presentation/widgets/custody_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/cubits/data_management/date_management/date_management_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../cubit/get_custody_trend_state/get_custody_trend_state_cubit.dart';
import '../cubit/get_custody_trend_state/get_custody_trend_state_state.dart';
import '../widgets/custody_balance_state_top_section.dart';
import '../widgets/custody_balance_trend_state_chart_section.dart';
import '../widgets/custody_month_and_year_section.dart';

class CustodyBalanceTrendState extends StatefulWidget {
  const CustodyBalanceTrendState({super.key});

  @override
  State<CustodyBalanceTrendState> createState() =>
      _CustodyBalanceTrendStateState();
}

class _CustodyBalanceTrendStateState extends State<CustodyBalanceTrendState> {
  static const _granularities = ['daily', 'weekly', 'monthly'];
  static const _custodyTypes = ['branch', 'personal'];

  late final PagingCubit _granularityPagingCubit;

  int _selectedGranularityIndex = 0;

  @override
  void initState() {
    super.initState();
    _granularityPagingCubit = PagingCubit(totalSteps: 3);
    _fetchTrendState();
  }

  @override
  void dispose() {
    _granularityPagingCubit.close();
    super.dispose();
  }

  void _fetchTrendState() {
    final dateCubit = context.read<DateManagementCubit>();
    final custodyTypeIndex = context.read<PagingCubit>().state.currentIndex;

    context.read<GetCustodyTrendStateCubit>().getTrendBalanceState(
      month: DateFormatter.getMonthNumber(
        dateCubit.state.selectedMonth,
      ).toString(),
      year: dateCubit.state.selectedYear.toString(),
      custodyType: _custodyTypes[custodyTypeIndex],
      granularity: _granularities[_selectedGranularityIndex],
    );
  }

  void _onMonthChanged(int index) {
    final dateCubit = context.read<DateManagementCubit>();
    dateCubit.selectMonth(DateManagementCubit.shortMonths[index]);
    _fetchTrendState();
  }

  void _onYearChanged(int index) {
    final dateCubit = context.read<DateManagementCubit>();
    dateCubit.selectYear(DateManagementCubit.years[index]);
    _fetchTrendState();
  }

  void _onGranularityChanged(int index) {
    _selectedGranularityIndex = index;
    _granularityPagingCubit.goToStep(index);
    _fetchTrendState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          CustodyAppBar(
            title: context.tr.balanceTrendStatsTitle,
            subtitle: context.tr.balanceTrendStatsSubtitle,
            iconColor: context.customColor.text1,
            titleColor: context.customColor.text1,
            isTransparent: false,
          ),
          CustomDivider(color: context.customColor.border),
          AppPaddingWidget(
            child: CustodyMonthAndYearSection(
              onTapMonth: _onMonthChanged,
              onTapYear: _onYearChanged,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocListener<PagingCubit, PagingState>(
                      listener: (context, state) {
                        _fetchTrendState();
                      },
                      child: const CustodyBalanceStateTopSection(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(color: context.customColor.border),
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
                                child:
                                    BlocSelector<
                                      PagingCubit,
                                      PagingState,
                                      String
                                    >(
                                      selector: (state) {
                                        if (state.currentIndex == 0) {
                                          return context.tr.branchBalanceTrends;
                                        } else if (state.currentIndex == 1) {
                                          return context
                                              .tr
                                              .personalBalanceTrends;
                                        }

                                        return '';
                                      },
                                      builder: (context, state) {
                                        return Text(
                                          state,
                                          style: AppStyles.s16W600.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        );
                                      },
                                    ),
                              ),
                              BlocBuilder<
                                GetCustodyTrendStateCubit,
                                GetCustodyTrendStateState
                              >(
                                builder: (context, state) {
                                  String dateText = '';

                                  if (state is GetCustodyTrendStateSuccess) {
                                    final data = state.response.data;
                                    dateText =
                                        '${DateFormatter.getMonthName(data.month)} ${data.year}';
                                  }

                                  return Text(
                                    dateText,
                                    style: AppStyles.s14W400.copyWith(
                                      color: context.customColor.text4,
                                    ),
                                  );
                                },
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
                                      BlocSelector<
                                        PagingCubit,
                                        PagingState,
                                        int
                                      >(
                                        selector: (state) {
                                          return state.currentIndex;
                                        },
                                        builder: (context, state) {
                                          final isSelected = state == index;

                                          return CustomTextButton(
                                            text: texts[index],
                                            onTap: () {
                                              _onGranularityChanged(index);
                                            },
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
                          BlocBuilder<
                            GetCustodyTrendStateCubit,
                            GetCustodyTrendStateState
                          >(
                            builder: (context, state) {
                              if (state is GetCustodyTrendStateLoading) {
                                return const AppLoadingWidget();
                              }

                              if (state is GetCustodyTrendStateFailure) {
                                return AppFailureWidget(
                                  failure: state.failure,
                                  onRetry: _fetchTrendState,
                                );
                              }

                              if (state is GetCustodyTrendStateSuccess) {
                                final data = state.response.data;
                                final totalCustody = data.totalCustodyRequests;
                                final totalExpense = data.totalExpense;

                                final isCustodyChangePositive =
                                    totalCustody.changeAmount >= 0;
                                final isExpenseChangePositive =
                                    totalExpense.changeAmount >= 0;

                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                        border: Border.all(
                                          color: context.customColor.border,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(16.r),
                                      child: Column(
                                        spacing: 12.h,
                                        children: [
                                          _buildRow(
                                            context: context,
                                            title:
                                                context.tr.trendStatsTimeline,
                                            value: data.timelineLabel,
                                          ),
                                          _buildRow(
                                            context: context,
                                            title: context
                                                .tr
                                                .trendStatsShowingDataFrom,
                                            value: DateFormat(
                                              'yyyy, hh:mm a',
                                            ).format(data.showingDataFrom),
                                          ),
                                          _buildMetricCard(
                                            context: context,
                                            title: context
                                                .tr
                                                .trendStatsTotalCustodyRequests,
                                            value: totalCustody.value
                                                .toStringAsFixed(2),
                                            changeAmount:
                                                '${isCustodyChangePositive ? '+ ' : '- '}${totalCustody.changeAmount.abs().toStringAsFixed(2)}',
                                            changeAmountColor:
                                                isCustodyChangePositive
                                                ? AppColors.lightGreen
                                                : context.customColor.error,
                                            changePercentage:
                                                totalCustody.changePercentage,
                                            description: totalCustody
                                                .description
                                                .toUpperCase(),
                                            badgeColor: isCustodyChangePositive
                                                ? AppColors.lightGreen
                                                : context.customColor.dark,
                                          ),
                                          _buildMetricCard(
                                            context: context,
                                            title: context
                                                .tr
                                                .trendStatsTotalExpense,
                                            value: totalExpense.value
                                                .toStringAsFixed(2),
                                            changeAmount:
                                                '${isExpenseChangePositive ? '+ ' : '- '}${totalExpense.changeAmount.abs().toStringAsFixed(2)}',
                                            changeAmountColor:
                                                isExpenseChangePositive
                                                ? AppColors.lightGreen
                                                : context.customColor.error,
                                            changePercentage:
                                                totalExpense.changePercentage,
                                            description: totalExpense
                                                .description
                                                .toUpperCase(),
                                            badgeColor: isExpenseChangePositive
                                                ? AppColors.lightGreen
                                                : context.customColor.dark,
                                          ),
                                        ],
                                      ),
                                    ),
                                    CustodyBalanceTrendStateChartSection(
                                      expenseChart: data.expenseChart,
                                      custodyRequestChart:
                                          data.custodyRequestChart,
                                      granularity:
                                          _granularities[_selectedGranularityIndex],
                                      responseMonth: data.month,
                                      responseYear: data.year,
                                    ),
                                  ],
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                        ],
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

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required String changeAmount,
    required Color changeAmountColor,
    required String changePercentage,
    required String description,
    required Color badgeColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        spacing: 4.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10.w,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SaudiRiyalSvgWidget(),
                    Text(
                      changeAmount,
                      style: AppStyles.s13W500.copyWith(
                        color: changeAmountColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            spacing: 12.w,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(1000.r),
                ),
                padding: EdgeInsets.all(4.r),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: badgeColor,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(5.r),
                      child: AppSvg(
                        assetName: AppAssets.over,
                        width: 8.r,
                        colorFilter: ColorFilter.mode(
                          context.customColor.reversedTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    4.horizontalSpace,
                    Text(
                      changePercentage,
                      style: AppStyles.s12W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Text(
                  description,
                  style: AppStyles.s10W600.copyWith(
                    color: context.customColor.text4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
}
