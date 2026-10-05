import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/container_custom_text_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';

class CashierInfoEditingValueWidget extends StatelessWidget {
  const CashierInfoEditingValueWidget({
    super.key,
    required this.hintText,
    required this.initValue,
    required this.validationFieldName,
    required this.errorMsg,
    this.onChanged,
    this.width,
  });

  final String hintText;
  final String initValue;
  final double? width;
  final Function(String)? onChanged;
  final String validationFieldName;
  final String errorMsg;

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //       width: width??150.w,
    //       child: ContainerCustomTextField(
    //         padding: EdgeInsetsGeometry.symmetric(
    //           horizontal: 5.w,
    //           vertical: 5.h,
    //         ),
    //         child: CustomTextField(
    //           hintText: hintText,
    //           initialValue: initValue,
    //           onChanged: onChanged,
    //         ),
    //       ),
    //     );
    return SizedBox(
      width: width ?? 150.w,
      child: BlocSelector<ValidationCubit, ValidationState, bool?>(
        selector: (state) => state.fieldsValidity[validationFieldName],
        builder: (context, state) {
          final isValid = state;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContainerCustomTextField(
                backgroundColor: Colors.white,
                borderColor: isValid == null || isValid
                    ? null
                    : context.customColor.error,

                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 5.w,
                  vertical: 5.h,
                ),
                child: CustomTextField(
                  hintText: hintText,
                  initialValue: initValue,
                  onChanged: onChanged,
                ),
              ),

              isValid == null || isValid
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        10.verticalSpace,
                        Text(
                          errorMsg,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.error,
                          ),
                        ),
                      ],
                    ),
            ],
          );
        },
      ),
    );
  }
}
