import '../../features/receive_goods/domain/strategies/document_type_strategy.dart';

enum DocumentTypeEnum {
  invoice('invoice'),
  deliveryNote('delivery_note'),
  receiptWithoutDocuments('receipt_without_document');

  final String _value;

  const DocumentTypeEnum(this._value);

  String get value => _value;

  static DocumentTypeEnum fromValue(String value) {
    return DocumentTypeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DocumentTypeEnum.invoice,
    );
  }

  static DocumentTypeStrategy getStrategy(DocumentTypeEnum value) {
    switch (value) {
      case DocumentTypeEnum.invoice:
        return InvoiceDocumentTypeStrategy();
      case DocumentTypeEnum.deliveryNote:
        return DeliveryNoteDocumentTypeStrategy();
      case DocumentTypeEnum.receiptWithoutDocuments:
        return InvoiceDocumentTypeStrategy();
    }
  }
}
