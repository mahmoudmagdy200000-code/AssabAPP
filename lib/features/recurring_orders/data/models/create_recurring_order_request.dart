class CreateRecurringOrderRequest {
  final CreateRecurringOrderRequestDirectSupplier? directSupplier;
  final CreateRecurringOrderRequestPurchaseOfficer? purchaseOfficer;
  final String? repeatFrequency;
  final CreateRecurringOrderRequestRepeatConfig? repeatConfig;
  final String? schedulingTime;
  final String? meridiem;
  final List<String>? notificationOptions;
  final List<String>? smartSettings;
  final String? startDate;
  final String? endDate;
  final String? endType;

  const CreateRecurringOrderRequest({
    required this.directSupplier,
    required this.purchaseOfficer,
    required this.repeatFrequency,
    required this.repeatConfig,
    required this.schedulingTime,
    required this.meridiem,
    required this.notificationOptions,
    required this.smartSettings,
    required this.startDate,
    required this.endDate,
    required this.endType,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (directSupplier != null) {
      data['direct_supplier'] = directSupplier!.toJson();
    }
    if (purchaseOfficer != null) {
      data['purchase_officer'] = purchaseOfficer!.toJson();
    }
    if (repeatFrequency != null) {
      data['repeat_frequency'] = repeatFrequency;
    }
    if (repeatConfig != null) {
      data['repeat_config'] = repeatConfig!.toJson();
    }
    if (schedulingTime != null) {
      data['scheduling_time'] = schedulingTime;
    }
    if (meridiem != null) {
      data['meridiem'] = meridiem;
    }
    if (notificationOptions != null) {
      data['notification_options'] = notificationOptions;
    }
    if (smartSettings != null) {
      data['smart_settings'] = smartSettings;
    }
    if (startDate != null) {
      data['start_date'] = startDate;
    }
    if (endDate != null) {
      data['end_date'] = endDate;
    }
    if (endType != null) {
      data['end_type'] = endType;
    }

    return data;
  }
}

class CreateRecurringOrderRequestDirectSupplier {
  final String? supplierId;
  final List<String>? notificationChannels;
  final String? message;
  final List<CreateRecurringOrderRequestDirectSupplierItem>? items;

  const CreateRecurringOrderRequestDirectSupplier({
    required this.supplierId,
    required this.notificationChannels,
    required this.message,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (supplierId != null) data['supplier_id'] = supplierId;
    if (notificationChannels != null) {
      data['notification_channels'] = notificationChannels;
    }
    if (message != null) data['message'] = message;
    if (items != null) {
      data['items'] = items!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class CreateRecurringOrderRequestDirectSupplierItem {
  final String? itemId;
  final int? quantity;
  final String? quality;

  const CreateRecurringOrderRequestDirectSupplierItem({
    required this.itemId,
    required this.quantity,
    required this.quality,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (itemId != null) data['item_id'] = itemId;
    if (quantity != null) data['quantity'] = quantity;
    if (quality != null) data['quality'] = quality;

    return data;
  }
}

class CreateRecurringOrderRequestPurchaseOfficer {
  final List<CreateRecurringOrderRequestPurchaseOfficerItem>? items;

  const CreateRecurringOrderRequestPurchaseOfficer({required this.items});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (items != null) {
      data['items'] = items!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class CreateRecurringOrderRequestPurchaseOfficerItem {
  final String? itemId;
  final int? quantity;
  final String? quality;
  final String? preferredDeliveryDate;
  final String? latestDeliveryDate;
  final String? specialInstructions;

  const CreateRecurringOrderRequestPurchaseOfficerItem({
    required this.itemId,
    required this.quantity,
    required this.quality,
    required this.preferredDeliveryDate,
    required this.latestDeliveryDate,
    required this.specialInstructions,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (itemId != null) data['item_id'] = itemId;
    if (quantity != null) data['quantity'] = quantity;
    if (quality != null) data['quality'] = quality;
    if (preferredDeliveryDate != null) {
      data['preferred_delivery_date'] = preferredDeliveryDate;
    }
    if (latestDeliveryDate != null) {
      data['latest_delivery_date'] = latestDeliveryDate;
    }
    if (specialInstructions != null) {
      data['special_instructions'] = specialInstructions;
    }

    return data;
  }
}

class CreateRecurringOrderRequestRepeatConfig {
  final List<int>? repeatDays;
  final String? repeatType;
  final List<int>? dates;
  final int? occurrence;
  final int? dayOfWeek;
  final String? levelRatio;
  final int? customThreshold;

  const CreateRecurringOrderRequestRepeatConfig({
    required this.repeatDays,
    required this.repeatType,
    required this.dates,
    required this.occurrence,
    required this.dayOfWeek,
    required this.levelRatio,
    required this.customThreshold,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (repeatDays != null) data['repeat_days'] = repeatDays;
    if (repeatType != null) data['repeat_type'] = repeatType;
    if (dates != null) data['dates'] = dates;
    if (occurrence != null) data['occurrence'] = occurrence;
    if (dayOfWeek != null) data['day_of_week'] = dayOfWeek;
    if (levelRatio != null) data['level_ratio'] = levelRatio;
    if (customThreshold != null) {
      data['custom_threshold'] = customThreshold;
    }

    return data;
  }
}
