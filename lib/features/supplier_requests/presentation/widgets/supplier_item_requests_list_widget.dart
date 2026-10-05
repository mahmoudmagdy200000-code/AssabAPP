import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/models/supplier_orders_response.dart';

class SupplierItemRequestsListWidget extends StatelessWidget {
  final SupplierOrder request;

  const SupplierItemRequestsListWidget({super.key, required this.request});

  String itemText(BuildContext context) {
    String text = '';

    if (request.items.length == 1) {
      text = request.items[0].productName;
    } else {
      text = '${request.items.length} ${context.tr.itemsRequired}';
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      margin: EdgeInsets.only(bottom: 8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  itemText(context),
                  style: AppStyles.s13W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              10.horizontalSpace,
              request.status.buildStatus(context),
            ],
          ),
          4.verticalSpace,
          request.orderType.buildRowType(context),
          4.verticalSpace,
          Text(
            '${DateFormatter.formatDateMDY(DateTime.tryParse(request.createdAt))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(request.createdAt))}',
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          4.verticalSpace,
          Text(
            request.branch.name,
            style: AppStyles.s12W500.copyWith(color: const Color(0xff049899)),
          ),
        ],
      ),
    );
  }
}
