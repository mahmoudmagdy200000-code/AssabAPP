import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';

class BranchManagerRequestsEmptyWidget extends StatelessWidget {
  final Function() onRefresh;
  final String message;

  const BranchManagerRequestsEmptyWidget({
    super.key,
    required this.onRefresh,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Text(
                  message,
                  style: AppStyles.s15W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
