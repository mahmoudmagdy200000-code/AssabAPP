import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum CraeteReturnRequirdActionEnum {
  replace('replacement'),
  refund('cash_refund'),
  credit('credit_future_order');

  final String _value;

  const CraeteReturnRequirdActionEnum(this._value);

  String get value => _value;

  static CraeteReturnRequirdActionEnum fromValue(String value) {
    return CraeteReturnRequirdActionEnum.values.firstWhere(
      (element) => element.value == value,
    );
  }

  String displayName(BuildContext context) {
    switch (this) {
      case CraeteReturnRequirdActionEnum.replace:
        return context.tr.replacementWithGoodProduct;
      case CraeteReturnRequirdActionEnum.refund:
        return context.tr.cashRefund;
      case CraeteReturnRequirdActionEnum.credit:
        return context.tr.creditForFutureOrders;
    }
  }
}
