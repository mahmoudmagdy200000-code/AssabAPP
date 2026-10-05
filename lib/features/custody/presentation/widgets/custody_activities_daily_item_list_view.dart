import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../data/models/personal_custody_transactions_response.dart';
import 'custody_activities_daily_item_card.dart';

class CustodyActivitiesDailyItemListView extends StatefulWidget {
  final List<PersonalCustodyTransaction> transactions;

  const CustodyActivitiesDailyItemListView({
    super.key,
    required this.transactions,
  });

  @override
  State<CustodyActivitiesDailyItemListView> createState() =>
      _CustodyActivitiesDailyItemListViewState();
}

class _CustodyActivitiesDailyItemListViewState
    extends State<CustodyActivitiesDailyItemListView> {
  @override
  Widget build(BuildContext context) {
    // Group transactions by date
    final Map<String, List<PersonalCustodyTransaction>> groupedTransactions =
        {};
    for (final transaction in widget.transactions) {
      final date =
          '${transaction.dateTime.year}-${transaction.dateTime.month.toString().padLeft(2, '0')}-${transaction.dateTime.day.toString().padLeft(2, '0')}';
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    return ListView.builder(
      itemCount: groupedTransactions.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final date = groupedTransactions.keys.elementAt(index);
        final dayTransactions = groupedTransactions[date]!;

        return Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.only(top: 16.r, left: 16.r, right: 16.r),
          margin: EdgeInsets.symmetric(vertical: 4.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date, // Display the date
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              12.verticalSpace,
              ListView.builder(
                itemCount: dayTransactions.length,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return CustodyActivitiesDailyItemCard(
                    transaction: dayTransactions[index],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
