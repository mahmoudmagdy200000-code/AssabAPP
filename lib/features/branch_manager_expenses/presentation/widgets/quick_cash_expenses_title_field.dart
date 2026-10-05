import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_field.dart';

class QuickCashExpensesTitleField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const QuickCashExpensesTitleField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  State<QuickCashExpensesTitleField> createState() =>
      _QuickCashExpensesTitleFieldState();
}

class _QuickCashExpensesTitleFieldState
    extends State<QuickCashExpensesTitleField> {
  late final ValueNotifier<int> _valueListenable;

  @override
  void initState() {
    _valueListenable = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  dispose() {
    _valueListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContainerCustomTextField(
      label: widget.label,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CustomTextField(
              controller: widget.controller,
              hintText: context.tr.expenseTitleHint,
              maxLength: 30,
              onChanged: (value) {
                _valueListenable.value = value.length;
                context.read<ValidationCubit>().validateField(
                  'title',
                  value.isNotEmpty,
                );
              },
            ),
          ),
          Row(
            children: [
              ValueListenableBuilder(
                valueListenable: _valueListenable,
                builder: (context, value, child) {
                  return Text(
                    '$value',
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text1,
                    ),
                  );
                },
              ),
              SizedBox(width: 4.w),
              Text(
                '/ 30',
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
