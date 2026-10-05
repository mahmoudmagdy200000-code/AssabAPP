import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_text_button.dart';

class BranchManagerRequestMultiOrderDetailsTopSection extends StatelessWidget {
  const BranchManagerRequestMultiOrderDetailsTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.r,
      margin: EdgeInsets.symmetric(vertical: 12.r, horizontal: 12.r),
      child: ListView.separated(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return CustomTextButton(
            text: 'BBBBBBB',
            borderRadius: 1000.r,
            onTap: () {},
          );
        },
        separatorBuilder: (context, index) => 10.horizontalSpace,
      ),
    );
  }
}
