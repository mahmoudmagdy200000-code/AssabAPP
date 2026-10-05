import 'dart:io';
import 'package:dio/dio.dart';

class CreateWastAndDamageRequest {
  final String assignedToType;
  final String? assignedToId;
  final List<WastAndDamageItem> items;

  CreateWastAndDamageRequest({
    required this.assignedToType,
    this.assignedToId,
    required this.items,
  });

  FormData toFormData() {
    final formData = FormData();

    formData.fields.add(MapEntry('assigned_to_type', assignedToType));

    if (assignedToId != null) {
      formData.fields.add(MapEntry('assigned_to_id', assignedToId!));
    }

    for (var i = 0; i < items.length; i++) {
      final item = items[i];

      if (item.itemId != null) {
        formData.fields.add(MapEntry('items[$i][item_id]', item.itemId!));
      }

      if (item.purchaseOrderItemId != null) {
        formData.fields.add(
          MapEntry(
            'items[$i][purchase_order_item_id]',
            item.purchaseOrderItemId!,
          ),
        );
      }

      if (item.problemType != null) {
        formData.fields.add(
          MapEntry('items[$i][problem_type]', item.problemType!),
        );
      }

      if (item.causeOfDamage != null) {
        formData.fields.add(
          MapEntry('items[$i][cause_of_damage]', item.causeOfDamage!),
        );
      }

      if (item.quantity != null) {
        formData.fields.add(
          MapEntry('items[$i][quantity]', item.quantity!.toString()),
        );
      }

      if (item.reason != null) {
        formData.fields.add(MapEntry('items[$i][reason]', item.reason!));
      }

      if (item.justificationText != null) {
        formData.fields.add(
          MapEntry('items[$i][justification_text]', item.justificationText!),
        );
      }

      if (item.pricePerUnit != null) {
        formData.fields.add(
          MapEntry('items[$i][price_per_unit]', item.pricePerUnit!.toString()),
        );
      }

      if (item.unit != null) {
        formData.fields.add(MapEntry('items[$i][unit]', item.unit!));
      }

      if (item.myQuantityAccountable != null) {
        formData.fields.add(
          MapEntry(
            'items[$i][my_quantity_accountable]',
            item.myQuantityAccountable!.toString(),
          ),
        );
      }

      if (item.photo != null) {
        formData.files.add(
          MapEntry(
            'items[$i][photo]',
            MultipartFile.fromFileSync(
              item.photo!.path,
              filename: item.photo!.path.split('/').last,
            ),
          ),
        );
      }

      for (var j = 0; j < item.responsibleEmployees.length; j++) {
        final emp = item.responsibleEmployees[j];

        if (emp.cashierId != null) {
          formData.fields.add(
            MapEntry(
              'items[$i][responsible_employees][$j][cashier_id]',
              emp.cashierId!,
            ),
          );
        }

        if (emp.quantityAccountable != null) {
          formData.fields.add(
            MapEntry(
              'items[$i][responsible_employees][$j][quantity_accountable]',
              emp.quantityAccountable!.toString(),
            ),
          );
        }
      }
    }

    return formData;
  }
}

class WastAndDamageItem {
  final String? itemId;
  final String? purchaseOrderItemId;
  final String? problemType;
  final String? causeOfDamage;
  final double? quantity;
  final String? reason;
  final String? justificationText;
  final double? pricePerUnit;
  final String? unit;
  final double? myQuantityAccountable;
  final File? photo;
  final List<ResponsibleEmployee> responsibleEmployees;

  WastAndDamageItem({
    this.itemId,
    this.purchaseOrderItemId,
    this.problemType,
    this.causeOfDamage,
    this.quantity,
    this.reason,
    this.justificationText,
    this.pricePerUnit,
    this.unit,
    this.myQuantityAccountable,
    this.photo,
    this.responsibleEmployees = const [],
  });
}

class ResponsibleEmployee {
  final String? cashierId;
  final double? quantityAccountable;

  ResponsibleEmployee({this.cashierId, this.quantityAccountable});
}
