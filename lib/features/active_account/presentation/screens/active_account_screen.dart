import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

import '../widgets/active_account_form.dart';
import '../widgets/active_account_top_section.dart';

class ActiveAccountScreen extends StatelessWidget {
  const ActiveAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: context.theme.primaryColor,
      child: Column(
        children: [
          const ActiveAccountTopSection(),
          34.verticalSpace,
          const ActiveAccountForm(),
        ],
      ),
    );
  }
}
