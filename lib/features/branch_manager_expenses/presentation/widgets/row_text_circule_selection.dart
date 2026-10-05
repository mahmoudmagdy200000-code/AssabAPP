import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';

class RowTextCirculeSelection extends StatelessWidget {
  final String text;
  final bool isSelected;

  const RowTextCirculeSelection({
    super.key,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            softWrap: true,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text1),
          ),
        ),
        12.horizontalSpace,
        SelectionCircule(isSelected: isSelected),
      ],
    );
  }
}
