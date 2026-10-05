import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';

class ModifyAssetStatusApprovalRequestOwnerWidget extends StatelessWidget {
  const ModifyAssetStatusApprovalRequestOwnerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelTextField(text: context.tr.approvalRequestOwner),
        ContainerCustomTextField(
          backgroundColor: Colors.transparent,
          child: CustomTextField(
            hintText: context.tr.exampleNoteApprovalRequestOwner,
            maxLines: 3,
            onChanged: (value) {
              context.read<ValidationCubit>().validateFieldAndStoreValue(
                fieldName: 'approvalRequestOwnerNote',
                value: value,
                isValid: value.isNotEmpty,
              );
            },
          ),
        ),
      ],
    );
  }
}
