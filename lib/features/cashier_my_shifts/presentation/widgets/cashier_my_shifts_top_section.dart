import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helpers/shared_preferences_helper.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/filter_button.dart';
import '../../../shift_module_features/shift_management/presentation/logic/shifts/cashier_shifts_management_cubit.dart';
import '../../../shift_module_features/shift_management/presentation/logic/shifts/shift_filter/shift_filter_cubit.dart';
import '../../../shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shifts_filter_sheet_widgets/shifts_filter_bottom_sheet_widget.dart';

class CashierMyShiftsTopSection extends StatelessWidget {
  const CashierMyShiftsTopSection({super.key});

  List<String> _steps(BuildContext context) => [
    context.tr.pending,
    context.tr.inProgress,
    context.tr.completed,
    context.tr.reassigned,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterButton(
          onClick: () => AppBottomSheet.showModal(
            context,
            (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => getIt<ChooseItemCubit>()),

                BlocProvider(
                  create: (context) => getIt<CashierShiftsManagementCubit>(
                    param1: getIt<SharedPreferencesHelper>().getString('u_id'),
                  ),
                ),
                BlocProvider(create: (context) => ShiftFilterCubit()),
              ],
              child: const ShiftsFilterBottomSheetWidget(),
            ),
            isScrollControlled: true,
            useSafeArea: true,
          ),
        ),
        14.horizontalSpace,
        Expanded(
          child: SizedBox(
            height: 32.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return BlocSelector<PagingCubit, PagingState, bool>(
                  selector: (state) => state.currentIndex == index,
                  builder: (context, state) {
                    return CustomTextButton(
                      text: _steps(context)[index],
                      onTap: () {
                        context.read<PagingCubit>().goToStep(index);
                      },
                      borderRadius: 1000.r,
                      borderColor: state
                          ? context.theme.primaryColor
                          : context.customColor.border,
                      textColor: state
                          ? context.theme.primaryColor
                          : context.customColor.text3,
                      padding: EdgeInsets.symmetric(horizontal: 25.r),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => 10.horizontalSpace,
              itemCount: _steps(context).length,
            ),
          ),
        ),
      ],
    );
  }
}
