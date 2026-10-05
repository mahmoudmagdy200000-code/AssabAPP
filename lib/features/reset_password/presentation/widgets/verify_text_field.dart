import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

class VerifyTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String value)? onChanged;

  const VerifyTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55.h,
      height: 55.h,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: 1,
        maxLength: 1,
        textAlign: TextAlign.center,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: const InputDecoration(
          counter: null,
          counterStyle: null,
          counterText: '',
          hintText: '-',
        ),
      ),
    );
  }
}
