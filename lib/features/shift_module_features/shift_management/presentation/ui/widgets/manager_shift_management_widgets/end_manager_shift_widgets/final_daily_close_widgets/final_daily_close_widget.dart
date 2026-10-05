import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import 'final_daily_close_table_widget.dart';

class FinalDailyCloseWidget extends StatelessWidget {
  const FinalDailyCloseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr.finalDailyClose, style: AppStyles.s20W500),
          2.verticalSpace,
          Text(
            context.tr.reviewAllHandoverBeforeSubmitting,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),

          15.verticalSpace,
          const CustomDivider(),
          15.verticalSpace,

          BlocBuilder<FinalDailyCloseCubit, FinalDailyCloseState>(
            builder: (context, state) {
              if (state is FinalDailyCloseFetchLoading) {
                return const Center(child: AppLoadingWidget());
              } else if (state is FinalDailyCloseFetchFailure) {
                return Center(
                  child: AppFailureWidget(
                    failure: state.failure,
                    onRetry: () =>
                        context.read<FinalDailyCloseCubit>().getDailyClose(),
                  ),
                );
              }

              final cashiersBreakdowns = context
                  .read<FinalDailyCloseCubit>()
                  .cashiersBreakdown;
              final totals = context.read<FinalDailyCloseCubit>().totals;

              return FinalDailyCloseTableWidget(
                cashiersBreakdowns: cashiersBreakdowns,
                totals: totals,
              );
            },
          ),
        ],
      ),
    );
  }
}
