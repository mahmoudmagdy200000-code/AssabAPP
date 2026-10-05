import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/purchase/presentation/cubit/filter_suppliers/filter_suppliers_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/purchase_supplier_availability_enum.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../cubit/filter_suppliers/filter_suppliers_cubit.dart';

class FilterSupplierWidgetAvailabilitySection extends StatelessWidget {
  const FilterSupplierWidgetAvailabilitySection({super.key});

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
            crossAxisCount: 4,
            crossAxisSpacing: 10.r,
            mainAxisSpacing: 10.r,
            childAspectRatio: 2.r,
          ),
          padding: EdgeInsets.zero,
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final options = [
              context.tr.all,
              context.tr.online,
              context.tr.away,
              context.tr.offline,
            ];

            final availability = [
              PurchaseSupplierAvailabilityEnum.all,
              PurchaseSupplierAvailabilityEnum.online,
              PurchaseSupplierAvailabilityEnum.away,
              PurchaseSupplierAvailabilityEnum.offline,
            ];

            return BlocSelector<
              FilterSuppliersCubit,
              FilterSuppliersState,
              bool
            >(
              selector: (state) => state.availability == availability[index],
              builder: (context, state) {
                return CustomTextButton(
                  text: options[index],
                  onTap: () {
                    context.read<FilterSuppliersCubit>().setAvailability(
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
                  padding: EdgeInsets.symmetric(horizontal: 10.r),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
