import 'package:assab/core/enums/purchase_response_time_enum.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../cubit/filter_branches/filter_branches_cubit.dart';
import '../cubit/filter_branches/filter_branches_state.dart';

class FilterBranchWidgetResponseTimeSection extends StatelessWidget {
  const FilterBranchWidgetResponseTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.responseTime,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        8.verticalSpace,
        Text(
          context.tr.branchesThatRespondOrFulfillRequestsQuicklyIdealForUrgent,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
        ),
        10.verticalSpace,
        ListView.separated(
          separatorBuilder: (context, index) =>
              index < 2 ? 8.verticalSpace : const SizedBox.shrink(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            final options = [
              context.tr.fast80100,
              context.tr.normal5080,
              context.tr.slowBelow50,
            ];

            final responseTime = [
              PurchaseResponseTimeEnum.fast,
              PurchaseResponseTimeEnum.normal,
              PurchaseResponseTimeEnum.slow,
            ];

            return BlocSelector<FilterBranchesCubit, FilterBranchesState, bool>(
              selector: (state) => state.responseTime == responseTime[index],
              builder: (context, state) {
                return CustomTextButton(
                  text: options[index],
                  onTap: () {
                    context.read<FilterBranchesCubit>().setResponseTime(
                      responseTime[index],
                    );
                  },
                  borderRadius: 1000.r,
                  textColor: state
                      ? context.theme.primaryColor
                      : context.customColor.text3,
                  borderColor: state
                      ? context.theme.primaryColor
                      : context.customColor.border,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.r,
                    vertical: 11.r,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
