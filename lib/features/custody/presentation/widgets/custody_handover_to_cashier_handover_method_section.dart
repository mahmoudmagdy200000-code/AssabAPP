import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_button.dart';

class CustodyHandoverToCashierHandoverMethodSection extends StatefulWidget {
  const CustodyHandoverToCashierHandoverMethodSection({super.key});

  @override
  State<CustodyHandoverToCashierHandoverMethodSection> createState() =>
      _CustodyHandoverToCashierHandoverMethodSectionState();
}

class _CustodyHandoverToCashierHandoverMethodSectionState
    extends State<CustodyHandoverToCashierHandoverMethodSection> {
  late final ValueNotifier<int> _selectedIndexNotifier;

  @override
  void initState() {
    super.initState();

    _selectedIndexNotifier = ValueNotifier<int>(-1);
  }

  @override
  void dispose() {
    _selectedIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContainerCustomTextField(
      label: context.tr.handoverMethod,
      padding: EdgeInsets.all(6.r),
      borderRadius: BorderRadius.circular(1000.r),
      borderColor: Colors.transparent,
      child: Row(
        children: List.generate(2, (index) {
          final texts = [context.tr.bankTransfer, context.tr.cashHandover];

          return Expanded(
            child: ValueListenableBuilder(
              valueListenable: _selectedIndexNotifier,
              builder: (context, value, child) {
                return CustomTextButton(
                  text: texts[index],
                  onTap: () {},
                  borderRadius: 1000.r,
                  backgroundColor: value == index
                      ? context.customColor.reversedTextColor
                      : Colors.transparent,
                  borderColor: Colors.transparent,
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
