import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/enums/manager_shift/end_shift_handover_timing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/widgets/app_failure_widget.dart';
import '../../../../../../../../core/widgets/app_loading_widget.dart';
import '../../../../logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import '../end_manager_shift_widgets/final_daily_close_widgets/final_daily_close_table_widget.dart';

class FinalHandoverSummaryWidget extends StatefulWidget {
  const FinalHandoverSummaryWidget({
    super.key,
    required this.currentTimeSetting,
    required this.handoverDate,
  });
  final HandoverTiming currentTimeSetting;
  final String handoverDate;

  @override
  State<FinalHandoverSummaryWidget> createState() =>
      _FinalHandoverSummaryWidgetState();
}

class _FinalHandoverSummaryWidgetState
    extends State<FinalHandoverSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.parse(widget.handoverDate);
    final formattedHandoverDate = DateFormat('dd/MMM/yyyy').format(parsedDate);

    return AppScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr.myHandoverSummary, style: AppStyles.s18W500),

              15.verticalSpace,

              Text(
                context.tr.breakdownBelowIncludesSales,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text4,
                ),
              ),

              15.verticalSpace,

              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightGray,
                      blurRadius: 10.r,
                      spreadRadius: 1.h,
                    ),
                  ],
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(context.tr.businessDate, style: AppStyles.s18W500),

                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppSvg(
                          assetName: AppAssets.calendar,
                          width: 20.w,
                          height: 20.h,
                        ),
                        5.horizontalSpace,
                        Text(
                          widget.currentTimeSetting == HandoverTiming.yesterday
                              ? context.tr.yesterdayWithDate(
                                  formattedHandoverDate,
                                )
                              : context.tr.todayWithDate(formattedHandoverDate),
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text4,
                          ),
                        ),
                      ],
                    ),

                    10.verticalSpace,
                    const CustomDivider(),
                    10.verticalSpace,

                    Text(
                      widget.currentTimeSetting == HandoverTiming.yesterday
                          ? context
                                .tr
                                .allHandoverAndShiftsWillBeRecordedUnderYesterdayWorkday
                          : context
                                .tr
                                .allHandoversShiftsAndSalesWillBeRecordedUnderTodayWorkday,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              15.verticalSpace,

              BlocBuilder<FinalDailyCloseCubit, FinalDailyCloseState>(
                builder: (context, state) {
                  if (state is FinalDailyCloseFetchLoading) {
                    return const Center(child: AppLoadingWidget());
                  } else if (state is FinalDailyCloseFetchFailure) {
                    return Center(
                      child: AppFailureWidget(
                        failure: state.failure,
                        onRetry: () => context
                            .read<FinalDailyCloseCubit>()
                            .getDailyClose(),
                      ),
                    );
                  } else if (state is FinalDailyCloseLoadedOrUpdated) {
                    return FinalDailyCloseTableWidget(
                      cashiersBreakdowns: state.cashiers,
                      totals: state.totals,
                      isEnabled: false,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
