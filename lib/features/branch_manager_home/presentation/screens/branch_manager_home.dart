import 'package:flutter/material.dart';

import '../widgets/branch_manager_home_bottom_section.dart';
import '../widgets/branch_manager_home_middle_section.dart';
import '../widgets/branch_manager_home_top_section.dart';

class BranchManagerHome extends StatelessWidget {
  const BranchManagerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BranchManagerHomeTopSection(),
            BranchManagerHomeMiddleSection(),
            BranchManagerHomeBottomSection(),
          ],
        ),
      ),
    );
  }
}
