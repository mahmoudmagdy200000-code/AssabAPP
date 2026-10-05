import 'package:flutter/material.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../data/model/cashier_model.dart';
import '../../filters/cashier_filter/cashier_status_mapper.dart';

class CashierStatusDropdown extends StatelessWidget {
  const CashierStatusDropdown({
    super.key,
    required this.value,
    required this.onSelected,
  });

  final CashierStatus value;
  final ValueChanged<CashierStatus> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CashierStatus>(
      onSelected: onSelected,
      offset: Offset(0, 45.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      itemBuilder: (context) {
        return CashierStatus.values
            .where((status) => status != CashierStatus.pending)
            .map((status) {
              return PopupMenuItem<CashierStatus>(
                value: status,
                child: Text(
                  status.label,
                  style: AppStyles.s13W400.copyWith(color: status.textColor),
                ),
              );
            })
            .toList();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value.label,
              style: AppStyles.s13W500.copyWith(color: value.textColor),
            ),
            6.horizontalSpace,
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
