import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';

class GroupedInvoiceSummaryExpenseDetailtsTopSection extends StatelessWidget {
  final int index;
  final String id;
  final ValueNotifier<int?> showDetailsNotifier;

  const GroupedInvoiceSummaryExpenseDetailtsTopSection({
    super.key,
    required this.index,
    required this.id,
    required this.showDetailsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${index + 1}',
          style: AppStyles.s14W600.copyWith(color: context.customColor.text3),
        ),
        14.horizontalSpace,
        Expanded(
          child: AppGestureDetectorButton(
            onTap: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocSelector<ValidationCubit, ValidationState, String?>(
                  selector: (state) => state.fieldsValue['invoiceNumber_$id'],
                  builder: (context, state) {
                    return Text(
                      state ?? 'Invoice Number',
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    );
                  },
                ),
                10.horizontalSpace,
                AppGestureDetectorButton(
                  onTap: () {
                    context.read<PagingCubit>().goToStep(1);
                  },
                  child: AppSvg(assetName: AppAssets.edit, width: 14.r),
                ),
                const Spacer(),
                AppGestureDetectorButton(
                  child: ValueListenableBuilder(
                    valueListenable: showDetailsNotifier,
                    builder: (context, value, child) {
                      return Icon(
                        value == index
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      );
                    },
                  ),
                  onTap: () {
                    showDetailsNotifier.value =
                        showDetailsNotifier.value == index ? null : index;
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
