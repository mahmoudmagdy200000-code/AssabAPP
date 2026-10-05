import 'package:assab/core/utils/date_formatter.dart';

import '../../../../core/enums/purchase_sources_types.dart';
import '../../../../core/enums/recurring_order_activate_period_end_date_enum.dart';
import '../../../../core/enums/recurring_order_date_picker_enum.dart';
import '../../../../core/enums/recurring_order_notifications_enum.dart';
import '../../../../core/enums/recurring_order_repeat_days_enum.dart';
import '../../../../core/enums/recurring_order_setting_repeat_type_every_enum.dart';
import '../../../../core/enums/recurring_order_smart_settings_enum.dart';
import '../../../../core/enums/recurring_order_status_enum.dart';
import '../../../../core/enums/recurring_setting_repeat_type.dart';
import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../domain/strategies/recurring_order_status_strategy.dart';
import '../../domain/strategies/repeat_frequency_strategy.dart';

class RecurringOrderDetailsResponse {
  final RecurringOrderDetailsData data;

  const RecurringOrderDetailsResponse({required this.data});

  factory RecurringOrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return RecurringOrderDetailsResponse(
      data: RecurringOrderDetailsData.fromJson(json['data']),
    );
  }
}

/* =============================== DATA =============================== */

class RecurringOrderDetailsData {
  final String id;
  final PurchaseSourceStrategy orderType;
  final RecurringOrderDetailsStatusSection statusSection;
  final RecurringOrderDetailsInspectionSummary inspectionSummary;
  final RecurringOrderDetailsFrequencySettings frequencySettings;
  final List<RecurringOrderDetailsItemAvailability> itemCountAndAvailability;
  final RecurringOrderDetailsDetails details;
  final RecurringOrderDetailsHistory history;
  final List<String> availableActions;

  const RecurringOrderDetailsData({
    required this.id,
    required this.orderType,
    required this.statusSection,
    required this.inspectionSummary,
    required this.frequencySettings,
    required this.itemCountAndAvailability,
    required this.details,
    required this.history,
    required this.availableActions,
  });

  factory RecurringOrderDetailsData.fromJson(Map<String, dynamic> json) {
    return RecurringOrderDetailsData(
      id: json['id'],
      orderType: PurchaseSourcesTypes.getStrategy(
        PurchaseSourcesTypes.fromValue(json['order_type'] as String),
      ),
      statusSection: RecurringOrderDetailsStatusSection.fromJson(
        json['status_section'],
      ),
      inspectionSummary: RecurringOrderDetailsInspectionSummary.fromJson(
        json['inspection_summary'],
      ),
      frequencySettings: RecurringOrderDetailsFrequencySettings.fromJson(
        json['frequency_settings'],
      ),
      itemCountAndAvailability: (json['item_count_and_availability'] as List)
          .map((e) => RecurringOrderDetailsItemAvailability.fromJson(e))
          .toList(),
      details: RecurringOrderDetailsDetails.fromJson(json['details']),
      history: RecurringOrderDetailsHistory.fromJson(json['history']),
      availableActions: (json['available_actions'] as List).cast<String>(),
    );
  }
}

/* =============================== STATUS =============================== */

class RecurringOrderDetailsStatusSection {
  final String status;
  final RecurringOrderStatusStrategy statusValue;
  final String message;

  const RecurringOrderDetailsStatusSection({
    required this.status,
    required this.statusValue,
    required this.message,
  });

  factory RecurringOrderDetailsStatusSection.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecurringOrderDetailsStatusSection(
      status: json['status'],
      statusValue: RecurringOrderStatusEnum.fromString(
        json['status_value'],
      ).strategy,
      message: json['message'],
    );
  }
}

/* =============================== INSPECTION SUMMARY =============================== */

class RecurringOrderDetailsInspectionSummary {
  final String orderName;
  final String directSupplierOrPurchasingOfficerName;
  final String repeatFrequency;
  final String nextOrderScheduling;
  final String schedulingTime;
  final String meridiem;
  final String endDate;

  const RecurringOrderDetailsInspectionSummary({
    required this.orderName,
    required this.directSupplierOrPurchasingOfficerName,
    required this.repeatFrequency,
    required this.nextOrderScheduling,
    required this.schedulingTime,
    required this.meridiem,
    required this.endDate,
  });

  factory RecurringOrderDetailsInspectionSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecurringOrderDetailsInspectionSummary(
      orderName: json['order_name'],
      directSupplierOrPurchasingOfficerName:
          json['direct_supplier_or_purchasing_officer_name'],
      repeatFrequency: json['repeat_frequency'],
      nextOrderScheduling:
          DateFormatter.formatDateMDY(
            DateTime.tryParse(json['next_order_scheduling'] ?? ''),
          ) ??
          '-',
      schedulingTime:
          DateFormatter.formatBackendTime(
            schedulingTime: json['scheduling_time'],
            meridiem: json['meridiem'],
          ) ??
          '-',
      meridiem: json['meridiem'] ?? '-',
      endDate:
          DateFormatter.formatDateMDY(
            DateTime.tryParse(json['end_date'] ?? ''),
          ) ??
          '-',
    );
  }
}

class RecurringOrderDetailsFrequencySettings {
  final RepeatFrequencyStrategy frequency;
  final RecurringOrderActivatePeriodEndDateEnum endType;
  final String? levelRatio;
  final RecurringSettingRepeatType? repeatType;
  final List<RecurringOrderDatePickerEnum>? dates;
  final List<RecurringOrderRepeatDaysEnum>? repeatDays;
  final RecurringOrderSettingRepeatTypeEveryEnum? every;
  final RecurringOrderRepeatDaysEnum? dayOfWeek;

  const RecurringOrderDetailsFrequencySettings({
    required this.frequency,
    required this.endType,
    required this.levelRatio,
    required this.repeatType,
    required this.dates,
    required this.repeatDays,
    required this.every,
    required this.dayOfWeek,
  });

  factory RecurringOrderDetailsFrequencySettings.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecurringOrderDetailsFrequencySettings(
      frequency: RepeatFrequencyStrategy.fromString(
        json['frequency'] as String,
      ),
      endType: RecurringOrderActivatePeriodEndDateEnum.fromValue(
        json['end_type'] as String,
      ),
      repeatType: json['repeat_type'] == null
          ? null
          : RecurringSettingRepeatType.fromValue(json['repeat_type'] as String),
      levelRatio: (json['level_ratio'] as String?),
      dates: json['dates'] == null
          ? null
          : (json['dates'] as List?)
                ?.cast<int>()
                .map((e) => RecurringOrderDatePickerEnum.fromValue(e))
                .toList(),
      repeatDays: json['repeat_days'] == null
          ? null
          : (json['repeat_days'] as List?)
                ?.cast<int>()
                .map((e) => RecurringOrderRepeatDaysEnum.fromValue(e))
                .toList(),
      every: json['every'] == null
          ? null
          : RecurringOrderSettingRepeatTypeEveryEnum.fromValue(
              (json['every'] as num).toInt(),
            ),
      dayOfWeek: json['day_of_week'] == null
          ? null
          : RecurringOrderRepeatDaysEnum.fromValue(
              (json['day_of_week'] as num).toInt(),
            ),
    );
  }
}

/* =============================== ITEM AVAILABILITY =============================== */

class RecurringOrderDetailsItemAvailability {
  final String itemName;
  final String? itemLogo;
  final int quantityPurchased;
  final int quantityInStock;

  const RecurringOrderDetailsItemAvailability({
    required this.itemName,
    required this.itemLogo,
    required this.quantityPurchased,
    required this.quantityInStock,
  });

  factory RecurringOrderDetailsItemAvailability.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecurringOrderDetailsItemAvailability(
      itemName: json['item_name'],
      itemLogo: json['item_logo'],
      quantityPurchased: json['quantity_purchased'],
      quantityInStock: json['quantity_in_stock'],
    );
  }
}

/* =============================== DETAILS =============================== */

class RecurringOrderDetailsDetails {
  final RecurringOrderDetailsInnerInspectionSummary inspectionSummary;
  final String? message;
  final List<String> notificationChannels;
  final List<RecurringOrderDetailsItemSummary> itemsSummary;
  final RecurringOrderDetailsSchedulingSettings schedulingSettings;

  const RecurringOrderDetailsDetails({
    required this.inspectionSummary,
    required this.message,
    required this.notificationChannels,
    required this.itemsSummary,
    required this.schedulingSettings,
  });

  factory RecurringOrderDetailsDetails.fromJson(Map<String, dynamic> json) {
    return RecurringOrderDetailsDetails(
      inspectionSummary: RecurringOrderDetailsInnerInspectionSummary.fromJson(
        json['inspection_summary'],
      ),
      message: json['message'],
      notificationChannels: (json['notification_channels'] as List)
          .cast<String>(),
      itemsSummary: (json['items_summary'] as List)
          .map((e) => RecurringOrderDetailsItemSummary.fromJson(e))
          .toList(),
      schedulingSettings: RecurringOrderDetailsSchedulingSettings.fromJson(
        json['scheduling_settings'],
      ),
    );
  }
}

/* =============================== INNER INSPECTION =============================== */

class RecurringOrderDetailsInnerInspectionSummary {
  final String orderName;
  final String directSupplierOrPurchasingOfficerName;
  final String startDate;
  final String schedulingTime;
  final String meridiem;
  final String? endDate;

  const RecurringOrderDetailsInnerInspectionSummary({
    required this.orderName,
    required this.directSupplierOrPurchasingOfficerName,
    required this.startDate,
    required this.schedulingTime,
    required this.meridiem,
    required this.endDate,
  });

  factory RecurringOrderDetailsInnerInspectionSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecurringOrderDetailsInnerInspectionSummary(
      orderName: json['order_name'],
      directSupplierOrPurchasingOfficerName:
          json['direct_supplier_or_purchasing_officer_name'],
      startDate: json['start_date'],
      schedulingTime: json['scheduling_time'] ?? '-',
      meridiem: json['meridiem'] ?? '-',
      endDate: json['end_date'],
    );
  }
}

/* =============================== ITEM SUMMARY =============================== */

class RecurringOrderDetailsItemSummary {
  final String id;
  final String itemId;
  final String itemName;
  final String? itemImage;
  final String? itemLogo;
  final int quantity;
  final String quality;
  final num unitPrice;
  final String? preferredDeliveryDate;
  final String? latestDeliveryDate;
  final String? specialInstructions;

  const RecurringOrderDetailsItemSummary({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.itemImage,
    required this.itemLogo,
    required this.quantity,
    required this.quality,
    required this.unitPrice,
    required this.preferredDeliveryDate,
    required this.latestDeliveryDate,
    required this.specialInstructions,
  });

  factory RecurringOrderDetailsItemSummary.fromJson(Map<String, dynamic> json) {
    return RecurringOrderDetailsItemSummary(
      id: json['id'],
      itemId: json['item_id'],
      itemName: json['item_name'],
      itemImage: json['item_image'],
      itemLogo: json['item_logo'],
      quantity: json['quantity'],
      quality: json['quality'],
      unitPrice: json['unit_price'],
      preferredDeliveryDate: json['preferred_delivery_date'],
      latestDeliveryDate: json['latest_delivery_date'],
      specialInstructions: json['special_instructions'],
    );
  }
}

/* =============================== SCHEDULING SETTINGS =============================== */

class RecurringOrderDetailsSchedulingSettings {
  final List<RecurringOrderNotificationsEnum> notifications;
  final List<RecurringOrderSmartSettingsEnum> smartSettings;

  const RecurringOrderDetailsSchedulingSettings({
    required this.notifications,
    required this.smartSettings,
  });

  factory RecurringOrderDetailsSchedulingSettings.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecurringOrderDetailsSchedulingSettings(
      notifications: (json['notifications'] as List)
          .cast<String>()
          .map((e) => RecurringOrderNotificationsEnum.fromValue(e))
          .toList(),
      smartSettings: (json['smart_settings'] as List)
          .cast<String>()
          .map((e) => RecurringOrderSmartSettingsEnum.fromValue(e))
          .toList(),
    );
  }
}

/* =============================== HISTORY =============================== */

class RecurringOrderDetailsHistory {
  final int totalCompletedOrders;
  final int totalCanceledOrders;
  final List<dynamic> list;

  const RecurringOrderDetailsHistory({
    required this.totalCompletedOrders,
    required this.totalCanceledOrders,
    required this.list,
  });

  factory RecurringOrderDetailsHistory.fromJson(Map<String, dynamic> json) {
    return RecurringOrderDetailsHistory(
      totalCompletedOrders: json['total_completed_orders'],
      totalCanceledOrders: json['total_canceled_orders'],
      list: json['list'] ?? [],
    );
  }
}
