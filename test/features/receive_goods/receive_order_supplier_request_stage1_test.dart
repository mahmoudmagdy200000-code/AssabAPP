import 'dart:io';

import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/enums/media_file_type.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/features/receive_goods/data/models/receive_order_supplier_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Stage 1 T1.6 ReceiveOrderSupplierRequest & Validation isolation', () {
    test('allows nullable InvoiceData.file without throwing', () {
      final request = ReceiveOrderSupplierRequest(
        items: [
          ReceivedItem(
            itemId: 'order-item-1',
            quantityReceived: 10.0,
            quality: 'normal',
            temperature: 4.0,
            expirationDate: '2026-12-31',
          ),
        ],
        documentType: 'invoice',
        invoiceData: InvoiceData(
          invoiceNumber: 'INV-100',
          invoiceDate: '2026-11-26',
          dueDate: '2026-12-26',
          paymentTerms: 'Net 30 days',
          file: null,
          notes: 'Invoice note',
          taxRate: 15.0,
          amountBeforeTax: 300.0,
          taxAmount: 45.0,
          totalAmount: 345.0,
        ),
      );

      final formData = request.toFormData();
      expect(
        formData.fields.any(
          (e) => e.key == 'invoice_data[invoice_number]' && e.value == 'INV-100',
        ),
        isTrue,
      );
      expect(
        formData.files.any((e) => e.key == 'invoice_data[photo]'),
        isFalse,
      );
    });

    test('supports double VarianceItem.quantity and serializes DeductData', () {
      final request = ReceiveOrderSupplierRequest(
        items: [
          ReceivedItem(
            itemId: 'order-item-1',
            quantityReceived: 7.5,
            quality: 'normal',
            temperature: 4.0,
            expirationDate: '2026-12-31',
          ),
        ],
        documentType: 'invoice',
        invoiceData: InvoiceData(
          invoiceNumber: 'INV-101',
          invoiceDate: '2026-11-26',
          dueDate: '2026-12-26',
          paymentTerms: 'Net 30 days',
          taxRate: 15.0,
        ),
        variance: VarianceData(
          action: 'deduct_from_invoice',
          note: '2.5 kg missing on delivery',
          items: [
            VarianceItem(itemId: 'order-item-1', quantity: 2.5),
          ],
          deductData: const DeductData(
            amount: 75.0,
            reason: 'short_quantity',
            notes: '2.5 kg short @ 30 SAR',
          ),
        ),
      );

      final formData = request.toFormData();
      final fieldMap = {for (final entry in formData.fields) entry.key: entry.value};

      expect(fieldMap['variance[action]'], 'deduct_from_invoice');
      expect(fieldMap['variance[note]'], '2.5 kg missing on delivery');
      expect(fieldMap['variance[items][0][quantity]'], '2.5');
      expect(fieldMap['variance[deduct_data][amount]'], '75.00');
      expect(fieldMap['variance[deduct_data][reason]'], 'short_quantity');
      expect(fieldMap['variance[deduct_data][notes]'], '2.5 kg short @ 30 SAR');
    });

    test('ValidationCubit isolates invoice file/note from varianceFile/varianceNote', () {
      final cubit = ValidationCubit(
        requiredFields: {'file', 'varianceFile'},
        optionalFields: {'note', 'varianceNote'},
      );
      addTearDown(cubit.close);

      const invoiceFile = MediaFile(
        path: '/tmp/invoice.pdf',
        name: 'invoice.pdf',
        type: MediaFileType.pdf,
        selected: true,
        fileExtension: 'PDF',
      );
      const varianceFile = MediaFile(
        path: '/tmp/damage.jpg',
        name: 'damage.jpg',
        type: MediaFileType.image,
        selected: true,
        fileExtension: 'JPG',
      );

      cubit.validateFieldAndStoreTypedValue<MediaFile?>(
        fieldName: 'file',
        value: invoiceFile,
        isValid: true,
      );
      cubit.validateFieldAndStoreValue(
        fieldName: 'note',
        value: 'Invoice attachment note',
        isValid: true,
      );

      cubit.validateFieldAndStoreTypedValue<MediaFile?>(
        fieldName: 'varianceFile',
        value: varianceFile,
        isValid: true,
      );
      cubit.validateFieldAndStoreValue(
        fieldName: 'varianceNote',
        value: 'Box crushed on arrival',
        isValid: true,
      );

      expect(cubit.getTypedValue<MediaFile>('file')?.name, 'invoice.pdf');
      expect(cubit.getTypedValue<MediaFile>('varianceFile')?.name, 'damage.jpg');
      expect(cubit.getFieldValue('note'), 'Invoice attachment note');
      expect(cubit.getFieldValue('varianceNote'), 'Box crushed on arrival');
    });

    test('receive_order_summary_view has no force-unwrap file! and uses separated variance keys', () {
      final summarySource = File(
        'lib/features/receive_goods/presentation/screens/receive_order_summary_view.dart',
      ).readAsStringSync();
      final strategySource = File(
        'lib/features/receive_goods/domain/strategies/document_type_strategy.dart',
      ).readAsStringSync();
      final varianceViewSource = File(
        'lib/features/receive_goods/presentation/screens/receive_goods_variance_view.dart',
      ).readAsStringSync();

      expect(summarySource.contains('file!.toFile'), isFalse);
      expect(summarySource.contains("getFieldValue('varianceNote')"), isTrue);
      expect(summarySource.contains("getTypedValue<MediaFile>('varianceFile')"), isTrue);
      expect(summarySource.contains('DeductData('), isTrue);
      expect(strategySource.contains("'varianceFile'"), isTrue);
      expect(varianceViewSource.contains("'varianceNote'"), isTrue);
    });
  });
}
