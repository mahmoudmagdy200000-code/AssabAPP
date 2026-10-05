class SupplierAlternativeProductRequest {
  final String alternativeItemId;
  final String note;

  SupplierAlternativeProductRequest({
    required this.alternativeItemId,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {'reason': note, 'alternative_item_id': alternativeItemId};
  }
}
