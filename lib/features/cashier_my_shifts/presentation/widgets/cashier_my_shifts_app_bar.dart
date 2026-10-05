import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';

class CashierMyShiftsAppBar extends StatelessWidget {
  const CashierMyShiftsAppBar({super.key});

  List<String> _types(BuildContext context) => [
    context.tr.shifts,
    context.tr.ledger,
  ];

  @override
  Widget build(BuildContext context) {
    final isLedger = context.watch<PagingCubit>().state.currentIndex == 1;

    return AppPaddingWidget(
      top: 40.r,
      child: Row(
        spacing: 16.w,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.myShifts,
                  style: AppStyles.s20W600.copyWith(
                    color: isLedger
                        ? context.customColor.reversedTextColor
                        : context.customColor.text1,
                  ),
                ),
                6.verticalSpace,
                Text(
                  context.tr.roleSeniorCashier,
                  style: AppStyles.s12W400.copyWith(
                    color: isLedger
                        ? context.customColor.reversedTextColor
                        : context.customColor.text1,
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: ContainerCustomTextField(
          //     backgroundColor: context.customColor.text3.withValues(alpha: 0.2),
          //     borderRadius: BorderRadius.circular(1000.r),
          //     borderColor: Colors.transparent,
          //     padding: EdgeInsets.all(6.r),
          //     child: Row(
          //       children: List.generate(2, (index) {
          //         return Expanded(
          //           child: AppGestureDetectorButton(
          //             onTap: () {
          //               context.read<PagingCubit>().goToStep(index);
          //             },
          //             child: BlocSelector<PagingCubit, PagingState, bool>(
          //               selector: (state) => state.currentIndex == index,
          //               builder: (context, isSelected) {
          //                 return Container(
          //                   decoration: BoxDecoration(
          //                     color: isSelected
          //                         ? context.customColor.reversedTextColor
          //                         : Colors.transparent,
          //                     borderRadius: BorderRadius.circular(1000.r),
          //                   ),
          //                   padding: EdgeInsets.symmetric(
          //                     horizontal: 12.w,
          //                     vertical: 6.h,
          //                   ),
          //                   child: Text(
          //                     _types(context)[index],
          //                     style: AppStyles.s13W600.copyWith(
          //                       color: isSelected
          //                           ? context.customColor.text1
          //                           : context.customColor.text3,
          //                     ),
          //                     textAlign: TextAlign.center,
          //                   ),
          //                 );
          //               },
          //             ),
          //           ),
          //         );
          //       }),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
