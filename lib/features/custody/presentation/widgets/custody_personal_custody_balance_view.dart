import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/data_management/date_management/date_management_cubit.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_placeholder.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/custody_personal_balance_response.dart';
import '../cubit/get_personal_balance/get_personal_balance_cubit.dart';
import '../cubit/get_personal_balance/get_personal_balance_state.dart';
import '../cubit/get_personal_balance_transactions/get_personal_balance_transactions_cubit.dart';
import 'custody_empty_widget.dart';
import 'custody_month_and_year_section.dart';
import 'custody_recent_activities_section.dart';
import 'see_all_personal_custody_activities.dart';

class CustodyPersonalCustodyBalanceView extends StatefulWidget {
  const CustodyPersonalCustodyBalanceView({super.key});

  @override
  State<CustodyPersonalCustodyBalanceView> createState() =>
      _CustodyPersonalCustodyBalanceViewState();
}

class _CustodyPersonalCustodyBalanceViewState
    extends State<CustodyPersonalCustodyBalanceView> {
  @override
  void initState() {
    super.initState();

    _getPersonal();
  }

  void _getPersonal() {
    context.read<GetPersonalBalanceCubit>().getPersonalBalance();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: [
        Container(
          decoration: BoxDecoration(
            color: context.customColor.text2.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.all(12.r),
          margin: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
          child: Column(
            children: [
              CustodyMonthAndYearSection(
                onTapMonth: (index) {
                  context.read<DateManagementCubit>().selectMonth(
                    DateManagementCubit.shortMonths[index],
                  );
                  context.read<GetPersonalBalanceCubit>().getPersonalBalance(
                    month: DateFormatter.getMonthNumber(
                      DateManagementCubit.shortMonths[index],
                    ).toString(),
                    year: context
                        .read<DateManagementCubit>()
                        .state
                        .selectedYear
                        .toString(),
                  );
                },
                onTapYear: (index) {
                  context.read<DateManagementCubit>().selectYear(
                    DateManagementCubit.years[index],
                  );

                  context.read<GetPersonalBalanceCubit>().getPersonalBalance(
                    month: DateFormatter.getMonthNumber(
                      context.read<DateManagementCubit>().state.selectedMonth,
                    ).toString(),
                    year: DateManagementCubit.years[index].toString(),
                  );
                },
              ),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              Row(
                children: [
                  Container(
                    color: AppColors.lightGreen,
                    width: 2.w,
                    height: 20.h,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.tr.totalCashIn,
                      softWrap: true,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                  3.horizontalSpace,
                  SaudiRiyalSvgWidget(
                    size: 18.r,
                    color: context.customColor.text3,
                  ),
                  5.horizontalSpace,
                  BlocBuilder<GetPersonalBalanceCubit, GetPersonalBalanceState>(
                    builder: (context, state) {
                      double amount = 0;

                      if (state is GetPersonalBalanceLoading) {
                        return AppPlaceholder(
                          width: 100.w,
                          height: 12.r,
                          borderRadius: BorderRadius.circular(1000.r),
                        );
                      } else if (state is GetPersonalBalanceSuccess) {
                        amount = state.balance.totalCashIn;
                      }

                      return Text(
                        amount.toStringAsFixed(2),
                        softWrap: true,
                        textAlign: TextAlign.end,
                        style: AppStyles.s12W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      );
                    },
                  ),
                ],
              ),
              12.verticalSpace,
              Row(
                children: [
                  Container(
                    color: context.customColor.error,
                    width: 2.w,
                    height: 20.h,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.tr.totalCashOut,
                      softWrap: true,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                  3.horizontalSpace,
                  SaudiRiyalSvgWidget(
                    size: 18.r,
                    color: context.customColor.text3,
                  ),
                  5.horizontalSpace,
                  BlocBuilder<GetPersonalBalanceCubit, GetPersonalBalanceState>(
                    builder: (context, state) {
                      double amount = 0;

                      if (state is GetPersonalBalanceLoading) {
                        return AppPlaceholder(
                          width: 100.w,
                          height: 12.r,
                          borderRadius: BorderRadius.circular(1000.r),
                        );
                      } else if (state is GetPersonalBalanceSuccess) {
                        amount = state.balance.totalCashOut;
                      }

                      return Text(
                        amount.toStringAsFixed(2),
                        softWrap: true,
                        textAlign: TextAlign.end,
                        style: AppStyles.s12W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ).sliverBoxAdapter,
        12.verticalSpace.sliverBoxAdapter,
        AppGestureDetectorButton(
          onTap: () => AppBottomSheet.customPageRoute(
            context,
            (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
                BlocProvider(
                  create: (context) =>
                      getIt<GetPersonalBalanceTransactionsCubit>(),
                ),
              ],
              child: const SeeAllPersonalCustodyActivities(),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              border: Border(
                right: BorderSide(color: context.customColor.border),
                left: BorderSide(color: context.customColor.border),
                top: BorderSide(color: context.customColor.border),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
            margin: EdgeInsets.symmetric(horizontal: 20.r),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr.recentActivities,
                    style: AppStyles.s16W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                10.horizontalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.r,
                    horizontal: 12.r,
                  ),
                  child: Row(
                    children: [
                      Text(
                        context.tr.seeAll,
                        style: AppStyles.s12W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      6.horizontalSpace,
                      AppSvg(
                        assetName: AppAssets.arrowRight,
                        colorFilter: ColorFilter.mode(
                          context.customColor.text1,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).sliverBoxAdapter,
        BlocBuilder<GetPersonalBalanceCubit, GetPersonalBalanceState>(
          builder: (context, state) {
            if (state is GetPersonalBalanceLoading) {
              return SizedBox(
                height: 400.r,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [AppLoadingWidget()],
                ),
              ).sliverBoxAdapter;
            } else if (state is GetPersonalBalanceFailure) {
              return SizedBox(
                height: 300.r,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppFailureWidget(
                      failure: state.failure,
                      onRetry: _getPersonal,
                    ),
                  ],
                ),
              ).sliverBoxAdapter;
            }

            final List<CustodyPersonalBalanceResponseRecentActivity>
            recentActivity = state is GetPersonalBalanceSuccess
                ? state.balance.recentActivity
                : [];

            if (recentActivity.isEmpty) {
              return CustodyEmptyWidget(
                asset: AppAssets.transaction,
                title: context.tr.noTransactionsYet,
                desc: context
                    .tr
                    .yourAccountActivityWillAppearHereOnceTransactionsAreRecorded,
              ).sliverBoxAdapter;
            }

            return CustodyRecentActivitiesSection(
              recentActivity: recentActivity,
            );
          },
        ),
      ],
    );
  }
}
