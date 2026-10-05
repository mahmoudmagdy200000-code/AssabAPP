class PurchaseCreateOrderRequest {
  bool? isDraft;
  final List<PurchaseCreateOrderRequestBranch> branches;
  final List<PurchaseCreateOrderRequestDirectSupplier> directSupplier;
  final List<PurchaseCreateOrderRequestPurchaseOfficer> purchaseOfficer;
  bool isEmergencyOrder;

  PurchaseCreateOrderRequest({
    this.isDraft,
    List<PurchaseCreateOrderRequestBranch>? branches,
    List<PurchaseCreateOrderRequestDirectSupplier>? directSupplier,
    List<PurchaseCreateOrderRequestPurchaseOfficer>? purchaseOfficer,
    bool? isEmergencyOrder,
  }) : branches = branches ?? [],
       directSupplier = directSupplier ?? [],
       purchaseOfficer = purchaseOfficer ?? [],
       isEmergencyOrder = isEmergencyOrder ?? false;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    json['is_draft'] = isDraft;

    if (branches.isNotEmpty) {
      json['branches'] = branches.map((b) => b.toJson()).toList();
    }

    if (directSupplier.isNotEmpty) {
      json['direct_supplier'] = directSupplier.map((s) => s.toJson()).toList();
    }

    if (purchaseOfficer.isNotEmpty) {
      json['purchase_officer'] = purchaseOfficer
          .map((p) => p.toJson())
          .toList();
    }

    json['is_emergency'] = isEmergencyOrder;

    return json;
  }

  void updateIsEmergencyOrder(bool emergency) {
    isEmergencyOrder = emergency;
  }

  void updateIsDraft(bool draft) {
    isDraft = draft;
  }

  void upsertBranch(PurchaseCreateOrderRequestBranch branch) {
    branches.removeWhere((b) => b.branchId == branch.branchId);
    branches.add(branch);
  }

  void removeBranch(String branchId) {
    branches.removeWhere((b) => b.branchId == branchId);
  }

  void clearBranches() {
    branches.clear();
  }

  void upsertDirectSupplier(PurchaseCreateOrderRequestDirectSupplier supplier) {
    directSupplier.removeWhere((s) => s.supplierId == supplier.supplierId);
    directSupplier.add(supplier);
  }

  void removeDirectSupplier(String supplierId) {
    directSupplier.removeWhere((s) => s.supplierId == supplierId);
  }

  void setPurchaseOfficerItems(
    List<PurchaseCreateOrderRequestPurchaseOfficerItem> items,
  ) {
    purchaseOfficer
      ..clear()
      ..add(PurchaseCreateOrderRequestPurchaseOfficer(items: items));
  }
}

class PurchaseCreateOrderRequestBranch {
  String? branchId;
  String? priority;
  String? justification;
  final List<PurchaseCreateOrderRequestBranchItem>? items;

  PurchaseCreateOrderRequestBranch({
    this.branchId,
    this.priority,
    this.justification,
    List<PurchaseCreateOrderRequestBranchItem>? items,
  }) : items = List<PurchaseCreateOrderRequestBranchItem>.from(items ?? []);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (branchId != null) {
      json['branch_id'] = branchId.toString();
    }

    if (priority != null) {
      json['priority'] = priority.toString();
    }

    if (justification != null) {
      json['justification'] = justification.toString();
    }

    if (items != null && items!.isNotEmpty) {
      json['items'] = items!.map((i) => i.toJson()).toList();
    }

    return json;
  }

  void updateBranchId(String id) {
    branchId = id;
  }

  void updatePriority(String newPriority) {
    priority = newPriority;
  }

  void updateJustification(String newJustification) {
    justification = newJustification;
  }

  void updateItems(List<PurchaseCreateOrderRequestBranchItem> newItems) {
    items
      ?..clear()
      ..addAll(newItems);
  }
}

class PurchaseCreateOrderRequestBranchItem {
  final String itemId;
  final int quantity;

  PurchaseCreateOrderRequestBranchItem({
    required this.itemId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {'item_id': itemId, 'quantity': quantity};
  }
}

class PurchaseCreateOrderRequestDirectSupplier {
  String? supplierId;
  final List<String> notificationChannels;
  String? message;
  final List<PurchaseCreateOrderRequestDirectSupplierItem> items;

  PurchaseCreateOrderRequestDirectSupplier({
    this.supplierId,
    List<String>? notificationChannels,
    this.message,
    List<PurchaseCreateOrderRequestDirectSupplierItem>? items,
  }) : notificationChannels = List<String>.from(notificationChannels ?? []),
       items = List<PurchaseCreateOrderRequestDirectSupplierItem>.from(
         items ?? [],
       );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (supplierId != null) {
      json['supplier_id'] = supplierId.toString();
    }

    if (notificationChannels.isNotEmpty) {
      json['notification_channels'] = notificationChannels;
    }

    if (message != null) {
      json['message'] = message.toString();
    }

    if (items.isNotEmpty) {
      json['items'] = items.map((i) => i.toJson()).toList();
    }

    return json;
  }

  void updateSupplierId(String id) {
    supplierId = id;
  }

  void updateNotificationChannels(List<String> channels) {
    notificationChannels
      ..clear()
      ..addAll(channels);
  }

  void updateMessage(String newMessage) {
    message = newMessage;
  }

  void updateItems(
    List<PurchaseCreateOrderRequestDirectSupplierItem> newItems,
  ) {
    items
      ..clear()
      ..addAll(newItems);
  }
}

class PurchaseCreateOrderRequestDirectSupplierItem {
  final String itemId;
  final String itemName;
  final String? itemImage;
  final String itemUnit;
  final String itemPrice;
  final int quantity;
  final String quality;

  PurchaseCreateOrderRequestDirectSupplierItem({
    required this.itemId,
    required this.itemName,
    required this.itemImage,
    required this.itemUnit,
    required this.itemPrice,
    required this.quantity,
    required this.quality,
  });

  Map<String, dynamic> toJson() {
    return {'item_id': itemId, 'quantity': quantity, 'quality': quality};
  }
}

class PurchaseCreateOrderRequestPurchaseOfficer {
  final List<PurchaseCreateOrderRequestPurchaseOfficerItem> items;

  PurchaseCreateOrderRequestPurchaseOfficer({required this.items});

  Map<String, dynamic> toJson() => {
    'items': items.map((i) => i.toJson()).toList(),
  };
}

class PurchaseCreateOrderRequestPurchaseOfficerItem {
  final String itemId;
  final String itemName;
  final String? itemImage;
  final String itemUnit;
  final String itemPrice;
  final int quantity;
  final String quality;
  final String preferredDeliveryDate;
  final String latestDeliveryDate;
  final String? specialInstructions;

  PurchaseCreateOrderRequestPurchaseOfficerItem({
    required this.itemId,
    required this.itemName,
    required this.itemImage,
    required this.itemUnit,
    required this.itemPrice,
    required this.quantity,
    required this.quality,
    required this.preferredDeliveryDate,
    required this.latestDeliveryDate,
    this.specialInstructions,
  });

  Map<String, dynamic> toJson() => {
    'item_id': itemId,
    'quantity': quantity,
    'quality': quality,
    'preferred_delivery_date': preferredDeliveryDate,
    'latest_delivery_date': latestDeliveryDate,
    'special_instructions': specialInstructions,
  };
}
