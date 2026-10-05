import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../data/models/branch_custody_transactions_response.dart';
import 'branch_custody_transactions_view_item_list_widget.dart';

class RecentBranchCustodyTransactionsSection extends StatelessWidget {
  final List<BranchCustodyTransaction> transactions;

  const RecentBranchCustodyTransactionsSection({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 12.r, left: 20.r, right: 20.r),
      sliver: DecoratedSliver(
        decoration: BoxDecoration(
          color: context.customColor.text2.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20.r),
        ),
        sliver: SliverPadding(
          padding: EdgeInsets.all(8.r),
          sliver: SliverList.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  bottom: index == transactions.length - 1 ? 0 : 8.r,
                ),
                child: BranchCustodyTransactionsViewItemListWidget(
                  transaction: transactions[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
