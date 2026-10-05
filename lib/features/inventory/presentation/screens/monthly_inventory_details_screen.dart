import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../data/models/monthly_inventory_details_response.dart';
import 'monthly_inventory_details_view_details_screen.dart';

class MonthlyInventoryDetailsScreen extends StatelessWidget {
  final MonthlyInventoryDetailsData details;

  const MonthlyInventoryDetailsScreen({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.monthlyRegularInventory,
            subtitle: context.tr.viewDetailsTimelinesAndStatuses,
            iconColor: context.customColor.text1,
            titleColor: context.customColor.text1,
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
              padding: EdgeInsets.all(12.r),
              child: Column(
                children: [
                  ContainerCustomTextField(
                    padding: EdgeInsets.all(6.r),
                    borderColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(1000.r),
                    child: Row(
                      children: List.generate(2, (index) {
                        final texts = [
                          context.tr.details,
                          context.tr.timelines,
                        ];

                        return BlocSelector<PagingCubit, PagingState, bool>(
                          selector: (state) {
                            return state.currentIndex == index;
                          },
                          builder: (context, isSelected) {
                            return Expanded(
                              child: CustomTextButton(
                                text: texts[index],
                                onTap: () {
                                  context.read<PagingCubit>().goToStep(index);
                                },
                                backgroundColor: isSelected
                                    ? context.customColor.reversedTextColor
                                    : Colors.transparent,
                                textColor: isSelected
                                    ? context.customColor.text1
                                    : context.customColor.text3,
                                borderColor: Colors.transparent,
                                borderRadius: 1000.r,
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  10.verticalSpace,
                  Expanded(
                    child: BlocSelector<PagingCubit, PagingState, int>(
                      selector: (state) => state.currentIndex,
                      builder: (context, state) {
                        return IndexedStack(
                          index: state,
                          children: [
                            MonthlyInventoryDetailsViewDetailsScreen(
                              details: details,
                            ),
                            TimeLinesView(
                              timelines: details.timelines.timelines,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
