import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum CancelReasonUserTypeEnum {
  supplier('supplier'),
  officer('officer'),
  brandOwner('brand_owner'),
  branch('branch_manager');

  final String _value;

  const CancelReasonUserTypeEnum(this._value);

  static CancelReasonUserTypeEnum fromValue(String value) {
    return CancelReasonUserTypeEnum.values.firstWhere(
      (element) => element._value == value,
      orElse: () => CancelReasonUserTypeEnum.branch,
    );
  }

  @override
  String toString() => _value;

  String getRejectionType(BuildContext context) {
    switch (this) {
      case CancelReasonUserTypeEnum.supplier:
        return context.tr.supplier;
      case CancelReasonUserTypeEnum.officer:
        return context.tr.officer;
      case CancelReasonUserTypeEnum.branch:
        return context.tr.branchManager;
      case CancelReasonUserTypeEnum.brandOwner:
        return context.tr.brandOwner;
    }
  }
}
