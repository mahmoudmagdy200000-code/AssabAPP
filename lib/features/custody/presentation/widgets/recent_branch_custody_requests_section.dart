import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/custody/data/models/custody_requests_response.dart';
import 'package:flutter/material.dart';

import '../../../../core/strategies/user_type_strategy.dart';
import 'branch_custody_request_view_item_list_widget.dart';

class RecentBranchCustodyRequestsSection extends StatelessWidget {
  final List<CustodyRequestItem> requests;

  const RecentBranchCustodyRequestsSection({super.key, required this.requests});

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
            itemCount: requests.length,
            itemBuilder: (context, index) {
              return BranchCustodyRequestViewItemListWidget(
                request: requests[index],
                margin: index < 4 ? 8.r : 0,
                userTypeStrategy: BranchManagerUserStrategy(),
              );
            },
          ),
        ),
      ),
    );
  }
}
