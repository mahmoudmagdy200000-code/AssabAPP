import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../../core/cubits/validation/validation_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/end_manager_shift/end_manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/enums/manager_shift/end_shift_handover_timing.dart';
import 'set_workday_widgets/set_to_business_date_selection_widget.dart';

class ManagerEndShiftSetWorkdayWidget extends StatelessWidget {
  const ManagerEndShiftSetWorkdayWidget({super.key});

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<FinalDailyCloseCubit, FinalDailyCloseState>(
    builder: (context, state) {
      final daily = context.read<FinalDailyCloseCubit>();
      Future<void> select(String option) async {
        if (context.read<EndAndUpdateManagerShiftCubit>().state
            is EndManagerShiftButtonLoading) {
          return;
        }
        context.read<EndAndUpdateManagerShiftCubit>().handoverTiming =
            option == 'today' ? HandoverTiming.today : HandoverTiming.yesterday;
        context.read<ValidationCubit>().validateField('handoverTiming', true);
        await daily.selectWorkday(option);
      }

      final todayDate = daily.workdayDates['today'];
      final yesterdayDate = daily.workdayDates['yesterday'];
      return AppPaddingWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr.workDayManagement, style: AppStyles.s20W500),
            Text(context.tr.defineWhichDayYourBranchDataBelongsTo),
            15.verticalSpace,
            SetToBusinessDateSelectionWidget(
              subtitle: todayDate == null
                  ? context.tr.today
                  : context.tr.todayWithDate(todayDate),
              isSelected: daily.selectedWorkday == 'today',
              onTap: () => select('today'),
            ),
            10.verticalSpace,
            SetToBusinessDateSelectionWidget(
              subtitle: yesterdayDate == null
                  ? context.tr.yesterdaysReport
                  : context.tr.yesterdayWithDate(yesterdayDate),
              isSelected: daily.selectedWorkday == 'yesterday',
              onTap: () => select('yesterday'),
            ),
            if (state is FinalDailyCloseLoadedOrUpdated)
              Text(state.businessDate ?? ''),
            if (state is FinalDailyCloseFetchLoading)
              const LinearProgressIndicator(),
            if (state is FinalDailyCloseFetchFailure)
              Text(state.failure.error.getErrorMessage),
          ],
        ),
      );
    },
  );
}
