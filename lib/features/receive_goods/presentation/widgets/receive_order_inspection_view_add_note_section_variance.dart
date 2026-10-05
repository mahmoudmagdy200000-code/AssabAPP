import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ReceiveOrderInspectionViewAddNoteSectionVariance extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const ReceiveOrderInspectionViewAddNoteSectionVariance({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerCustomTextField(
      label: context.tr.addNote,
      backgroundColor: context.customColor.reversedTextColor,
      child: CustomTextField(
        maxLines: 3,
        hintText: context.tr.describeTheIssueEgVisibleSpoilageUnusable,
        onChanged: onChanged,
      ),
    );
  }
}
