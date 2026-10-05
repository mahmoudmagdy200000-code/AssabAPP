import 'package:assab/core/enums/purchase_branch_availability_enum.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/purchase/presentation/cubit/filter_branches/filter_branches_cubit.dart';
import 'package:assab/features/purchase/presentation/cubit/filter_branches/filter_branches_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_text_button.dart';

class FilterBranchWidgetAvailabilitySection extends StatelessWidget {
  const FilterBranchWidgetAvailabilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.availability,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        8.verticalSpace,
        Text(
          context.tr.showBranchesWithAtLeast80OfRequestedItems,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
        ),
        10.verticalSpace,
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.r,
            mainAxisSpacing: 12.r,
            childAspectRatio: 2.5.r,
          ),
          padding: EdgeInsets.zero,
          itemCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final options = [
              context.tr.all,
              context.tr.mod60,
              context.tr.mod70,
              context.tr.mod80,
              context.tr.mod90,
              context.tr.mod100,
            ];

            final availability = [
              PurchaseBranchAvailabilityEnum.all,
              PurchaseBranchAvailabilityEnum.mod60,
              PurchaseBranchAvailabilityEnum.mod70,
              PurchaseBranchAvailabilityEnum.mod80,
              PurchaseBranchAvailabilityEnum.mod90,
              PurchaseBranchAvailabilityEnum.mod100,
            ];

            return BlocSelector<FilterBranchesCubit, FilterBranchesState, bool>(
              selector: (state) => state.availability == availability[index],
              builder: (context, state) {
                return CustomTextButton(
                  text: options[index],
                  onTap: () {
                    context.read<FilterBranchesCubit>().setAvailability(
                      availability[index],
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
