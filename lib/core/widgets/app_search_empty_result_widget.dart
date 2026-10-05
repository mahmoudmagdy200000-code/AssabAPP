import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

class AppSearchEmptyResultWidget extends StatelessWidget {
  const AppSearchEmptyResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.tr.noSearchResultsFound,
        style: AppStyles.s14W500.copyWith(color: context.customColor.text3),
      ),
    );
  }
}
