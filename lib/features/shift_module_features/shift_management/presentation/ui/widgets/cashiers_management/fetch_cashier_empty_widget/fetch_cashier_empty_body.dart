import 'package:flutter/material.dart';

import 'empty_cashiers_with_filter_widget.dart';
import 'empty_cashiers_without_filter_widget.dart';

class ShiftManagementEmptyBody extends StatelessWidget {
  const ShiftManagementEmptyBody({super.key, required this.hasFilters});
  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: hasFilters
            ? const EmptyCashiersWithFilterWidget()
            : const EmptyCashiersWithoutFilterWidget(),
      ),
    );
  }
}
