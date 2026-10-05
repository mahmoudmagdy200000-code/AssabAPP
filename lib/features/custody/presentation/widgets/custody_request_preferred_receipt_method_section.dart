import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/custody_preferred_receipt_method.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_button.dart';

class CustodyRequestPreferredReceiptMethodSection extends StatefulWidget {
  final String? title;
  const CustodyRequestPreferredReceiptMethodSection({super.key, this.title});

  @override
  State<CustodyRequestPreferredReceiptMethodSection> createState() =>
      _CustodyRequestPreferredReceiptMethodSectionState();
}

class _CustodyRequestPreferredReceiptMethodSectionState
    extends State<CustodyRequestPreferredReceiptMethodSection> {
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
      label: widget.title ?? context.tr.preferredReceiptMethod,
      padding: EdgeInsets.all(6.r),
      borderRadius: BorderRadius.circular(1000.r),
      borderColor: Colors.transparent,
      child: Row(
        children: List.generate(2, (index) {
          final texts = [context.tr.bankTransfer, context.tr.cashHandover];

          final options = [
            CustodyPreferredReceiptMethod.bankTransfer,
            CustodyPreferredReceiptMethod.cashHandover,
          ];

          return Flexible(
            child: ValueListenableBuilder(
              valueListenable: _selectedIndexNotifier,
              builder: (context, value, child) {
                return CustomTextButton(
                  text: texts[index],
                  onTap: () {
                    _selectedIndexNotifier.value = index;
                    context.read<ValidationCubit>().validateFieldAndStoreValue(
                      fieldName: 'preferredReceiptMethod',
                      value: options[index].value,
                      isValid: true,
                    );
                  },
                  textColor: context.customColor.text1,
                  backgroundColor: value == index
                      ? context.customColor.reversedTextColor
                      : Colors.transparent,
                  borderColor: Colors.transparent,
                  borderRadius: 1000.r,
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
