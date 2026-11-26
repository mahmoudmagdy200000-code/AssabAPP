import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/receive_goods_quality_enum.dart';
import '../../data/models/receive_goods_local_item_model.dart';

/// Reads a numeric validation field from either `fieldsValueTyped` or `fieldsValue`.
double? readValidationDouble(ValidationState state, String fieldName) {
  final typed = state.fieldsValueTyped[fieldName];
  if (typed is num) {
    return typed.toDouble();
  }
  final raw = state.fieldsValue[fieldName];
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }
  return double.tryParse(raw.trim());
}

class ReceiptDeductionSummary {
  final double preVatAmount;
  final double vatInclusiveAmount;
  final String reason;

  const ReceiptDeductionSummary({
    required this.preVatAmount,
    required this.vatInclusiveAmount,
    required this.reason,
  });
}

/// Computes the once-per-receipt VAT-inclusive deduction summary across
/// short-quantity and damaged-quality variance items (AUD-S1-008 / PUR-E2E-11).
ReceiptDeductionSummary? computeReceiptDeductionSummary({
  required List<ReceiveGoodsLocalItemModel> varianceItems,
  double? invoiceVatRate,
  double? explicitDamageAmount,
}) {
  if (varianceItems.isEmpty) {
    return null;
  }

  double normalizePct(double rate) =>
      rate > 0.0 && rate <= 1.0 ? rate * 100.0 : rate;

  double preVat = 0.0;
  double vatInclusive = 0.0;
  bool hasShortage = false;
  bool hasQualityDamage = false;

  for (final item in varianceItems) {
    final effectiveRate = normalizePct(invoiceVatRate ?? item.vatRate ?? 0.0);
    final multiplier = 1.0 + (effectiveRate / 100.0);

    if (item.qtyOrdered > item.qtyReceived) {
      hasShortage = true;
      final linePreVat = (item.qtyOrdered - item.qtyReceived) * item.unitPrice;
      preVat += linePreVat;
      vatInclusive += linePreVat * multiplier;
    } else if (item.quality == ReceiveGoodsQualityEnum.poor) {
      hasQualityDamage = true;
      final linePreVat =
          explicitDamageAmount != null &&
                  explicitDamageAmount > 0 &&
                  varianceItems.length == 1
              ? explicitDamageAmount
              : item.qtyReceived * item.unitPrice;
      preVat += linePreVat;
      vatInclusive += linePreVat * multiplier;
    }
  }

  if (!hasShortage &&
      hasQualityDamage &&
      explicitDamageAmount != null &&
      explicitDamageAmount > 0 &&
      varianceItems.length > 1) {
    final effectiveRate = normalizePct(invoiceVatRate ?? varianceItems.first.vatRate ?? 0.0);
    preVat = explicitDamageAmount;
    vatInclusive = explicitDamageAmount * (1.0 + (effectiveRate / 100.0));
  }

  if (vatInclusive <= 0.0) {
    return null;
  }

  return ReceiptDeductionSummary(
    preVatAmount: double.parse(preVat.toStringAsFixed(2)),
    vatInclusiveAmount: double.parse(vatInclusive.toStringAsFixed(2)),
    reason: hasShortage ? 'short_quantity' : 'damaged_quality',
  );
}
