import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/styles/app_styles.dart';
import '../widgets/variance/list_responsible_employee.dart';
import '../widgets/variance/reason_text_form_field.dart';
import '../widgets/variance/variance_list_files.dart';
import '../widgets/variance/variance_upload_files_button.dart';

class VarianceDetectMeAndOrView extends StatelessWidget {
  const VarianceDetectMeAndOrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListResponsibleEmployee(),
        20.verticalSpace,
        Row(
          children: [
            Text(
              context.tr.reasonForVariance,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.horizontalSpace,
            Text(
              context.tr.optional,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
        ),
        8.verticalSpace,
        ReasonTextFormField(
          onChanged: (value) {
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'reason',
              value: value,
              isValid: value.isNotEmpty,
            );
          },
        ),
        20.verticalSpace,
        Row(
          children: [
            Text(
              context.tr.addAttachments,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.horizontalSpace,
            Text(
              context.tr.optional,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
        ),
        8.verticalSpace,
        const VarianceUploadFilesButton(),
        const VarianceListFiles(),
      ],
    );
  }
}
