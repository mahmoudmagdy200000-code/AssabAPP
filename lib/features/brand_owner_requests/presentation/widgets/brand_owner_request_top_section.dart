import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_text_button.dart';

class BrandOwnerRequestTopSection extends StatelessWidget {
  const BrandOwnerRequestTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppPaddingWidget(
          top: 14.r,
          bottom: 14.r,
          left: 12.r,
          right: 12.r,
          child: Row(
            children: [
              // FilterButton(onClick: () {}),
              // 10.horizontalSpace,
              Expanded(
                child: SizedBox(
                  height: 32.h,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final filters = [
                        context.tr.expenses,
                        context.tr.custodyRequests,
                        context.tr.cashSalesTransfers,
                      ];

                      return BlocSelector<PagingCubit, PagingState, bool>(
                        selector: (state) {
                          return state.currentIndex == index;
                        },
                        builder: (context, isSelected) {
                          return CustomTextButton(
                            text: filters[index],
                            padding: EdgeInsets.symmetric(horizontal: 25.r),
                            borderRadius: 1000.r,
                            textColor: isSelected
                                ? context.theme.primaryColor
                                : context.customColor.text3,
                            borderColor: isSelected
                                ? context.theme.primaryColor
                                : context.customColor.border,
                            onTap: () {
                              context.read<PagingCubit>().goToStep(index);
                            },
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => 10.horizontalSpace,
                  ),
                ),
              ),
            ],
          ),
        ),
        const CustomDivider(),
      ],
    );
  }
}
