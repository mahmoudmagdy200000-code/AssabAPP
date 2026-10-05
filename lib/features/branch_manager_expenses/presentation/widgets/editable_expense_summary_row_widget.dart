import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/edit_button.dart';

class EditableExpenseSummaryRowWidget extends StatelessWidget {
  final bool isDraft;
  final VoidCallback onEdit;
  final Widget child;

  const EditableExpenseSummaryRowWidget({
    super.key,
    required this.isDraft,
    required this.onEdit,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: child),
        if (isDraft) ...[10.horizontalSpace, EditButton(onTap: onEdit)],
      ],
    );
  }
}
