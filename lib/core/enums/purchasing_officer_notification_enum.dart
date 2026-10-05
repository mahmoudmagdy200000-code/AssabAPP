import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum PurchasingOfficerNotificationEnum {
  email('email'),
  whatsApp('whatsapp'),
  pushNotification('in_app_notification'),
  sms('sms');

  final String _value;

  const PurchasingOfficerNotificationEnum(this._value);

  @override
  String toString() => _value;

  static PurchasingOfficerNotificationEnum fromString(String value) {
    return PurchasingOfficerNotificationEnum.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => PurchasingOfficerNotificationEnum.email,
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case PurchasingOfficerNotificationEnum.email:
        return context.tr.email;
      case PurchasingOfficerNotificationEnum.whatsApp:
        return context.tr.whatsApp;
      case PurchasingOfficerNotificationEnum.pushNotification:
        return context.tr.pushNotification;
      case PurchasingOfficerNotificationEnum.sms:
        return context.tr.sms;
    }
  }
}
