import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

import '../widgets/branch_manager_expenses_app_bar.dart';
import '../widgets/branch_manager_expenses_body.dart';

class BranchManagerExpensesScreen extends StatelessWidget {
  const BranchManagerExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: const Column(
        children: [BranchManagerExpensesAppBar(), BranchManagerExpensesBody()],
      ),
    );
  }
}
