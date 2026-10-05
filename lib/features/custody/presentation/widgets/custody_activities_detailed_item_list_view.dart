import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/personal_custody_transactions_response.dart';

class CustodyActivitiesDetailedItemListView extends StatelessWidget {
  final List<PersonalCustodyTransaction> transactions;

  const CustodyActivitiesDetailedItemListView({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final transaction = transactions[index];

        return Container(
          decoration: BoxDecoration(
            color: context.customColor.reversedTextColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
          margin: EdgeInsets.only(bottom: 12.r),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      transaction.transactionType,
                      style: AppStyles.s13W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  SaudiRiyalSvgWidget(color: context.customColor.text3),
                  4.horizontalSpace,
                  Text(
                    transaction.amount,
                    style: AppStyles.s13WB.copyWith(
                      color: (double.tryParse(transaction.amount) ?? 0) > 0
                          ? AppColors.lightGreen
                          : context.customColor.error,
                    ),
                  ),
                ],
              ),
              5.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      transaction.cashierName ?? 'N/A',
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    '${transaction.dateTime.hour}:${transaction.dateTime.minute.toString().padLeft(2, '0')} ${transaction.dateTime.hour >= 12 ? 'PM' : 'AM'}',
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
