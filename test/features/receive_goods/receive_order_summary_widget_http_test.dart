import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/enums/media_file_type.dart';
import 'package:assab/core/enums/receive_goods_quality_enum.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/features/receive_goods/data/data_sources/receive_goods_remote_data_source.dart';
import 'package:assab/features/receive_goods/data/models/receive_goods_local_item_model.dart';
import 'package:assab/features/receive_goods/data/repository/receive_goods_repository.dart';
import 'package:assab/features/receive_goods/domain/utils/receive_goods_deduction_helper.dart';
import 'package:assab/features/receive_goods/presentation/cubit/start_receive_order/start_receive_order_cubit.dart';
import 'package:assab/features/receive_goods/presentation/screens/receive_order_summary_view.dart';
import 'package:assab/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _CapturedMultipartHttpRequest {
  final String method;
  final Uri uri;
  final String? contentType;
  final FormData? rawFormData;
  final String serializedMultipartBody;

  const _CapturedMultipartHttpRequest({
    required this.method,
    required this.uri,
    required this.contentType,
    required this.rawFormData,
    required this.serializedMultipartBody,
  });
}

class _RecordingMultipartAdapter implements HttpClientAdapter {
  final List<_CapturedMultipartHttpRequest> captured = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final bytes = <int>[];
    if (requestStream != null) {
      await for (final chunk in requestStream) {
        bytes.addAll(chunk);
      }
    }
    captured.add(
      _CapturedMultipartHttpRequest(
        method: options.method,
        uri: options.uri,
        contentType: options.contentType,
        rawFormData: options.data is FormData ? options.data as FormData : null,
        serializedMultipartBody: utf8.decode(bytes, allowMalformed: true),
      ),
    );
    return ResponseBody.fromString(
      '{"success":true,"data":{"id":"gr-test-1"}}',
      201,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const _contractArtifactPath =
    '../ASSAB_PURCHASE_DELIVERY/audit-stage-1-remediation-r2/widget-multipart-contracts.json';

void _recordWidgetContract(
  String scenarioKey,
  _CapturedMultipartHttpRequest request,
) {
  final file = File(_contractArtifactPath);
  file.parent.createSync(recursive: true);
  final existing = file.existsSync()
      ? (jsonDecode(file.readAsStringSync()) as Map<String, dynamic>)
      : <String, dynamic>{};

  final formData = request.rawFormData!;
  existing[scenarioKey] = {
    'method': request.method,
    'path': request.uri.path,
    'fields': formData.fields
        .map((e) => {'key': e.key, 'value': e.value})
        .toList(),
    'files': formData.files
        .map((e) => {'field': e.key, 'filename': e.value.filename ?? 'upload.jpg'})
        .toList(),
  };

  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(existing));
}

Widget _buildSummaryTestApp({
  required ValidationCubit validationCubit,
  required StartReceiveOrderCubit startCubit,
  required PagingCubit pagingCubit,
  required String orderId,
}) {
  return MaterialApp(
    navigatorKey: NavigationService.I.navigatorKey,
    locale: const Locale('en'),
    supportedLocales: S.delegate.supportedLocales,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: ThemeData(extensions: LightTheme.extension),
    home: Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ValidationCubit>.value(value: validationCubit),
          BlocProvider<StartReceiveOrderCubit>.value(value: startCubit),
          BlocProvider<PagingCubit>.value(value: pagingCubit),
        ],
        child: Builder(
          builder: (context) {
            AppResponsive.init(context, designWidth: 375, designHeight: 812);
            return ReceiveOrderSummaryView(orderId: orderId);
          },
        ),
      ),
    ),
  );
}

void main() {
  late Directory tempDir;
  late File invoiceFile;
  late File varianceFile;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('assab_s1_widget_');
    invoiceFile = File('${tempDir.path}/invoice_doc.jpg')
      ..writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0, 0x49, 0x4E, 0x56]);
    varianceFile = File('${tempDir.path}/variance_damage.jpg')
      ..writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0, 0x56, 0x41, 0x52]);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('AUD-S1-008: Deduction calculation + ReceiveOrderSummaryView widget HTTP submission', () {
    test('computeReceiptDeductionSummary calculates VAT-inclusive deduction for 15%, 0%, multi-line, and quality-only', () {
      final short15 = computeReceiptDeductionSummary(
        varianceItems: [
          ReceiveGoodsLocalItemModel(
            itemId: 'line-1',
            productName: 'Flour',
            itemLogo: null,
            qtyOrdered: 10,
            qtyReceived: 8,
            unitPrice: 20.0,
            quality: ReceiveGoodsQualityEnum.normal,
            termperature: 4,
            unit: 'kg',
            isVariance: true,
            expirationDate: '2026-12-31',
          ),
        ],
        invoiceVatRate: 15.0,
      );
      expect(short15?.preVatAmount, 40.00);
      expect(short15?.vatInclusiveAmount, 46.00);
      expect(short15?.reason, 'short_quantity');

      final short0 = computeReceiptDeductionSummary(
        varianceItems: [
          ReceiveGoodsLocalItemModel(
            itemId: 'line-1',
            productName: 'Flour',
            itemLogo: null,
            qtyOrdered: 10,
            qtyReceived: 8,
            unitPrice: 20.0,
            quality: ReceiveGoodsQualityEnum.normal,
            termperature: 4,
            unit: 'kg',
            isVariance: true,
            expirationDate: '2026-12-31',
          ),
        ],
        invoiceVatRate: 0.0,
      );
      expect(short0?.vatInclusiveAmount, 40.00);

      final qualityOnly = computeReceiptDeductionSummary(
        varianceItems: [
          ReceiveGoodsLocalItemModel(
            itemId: 'line-2',
            productName: 'Tomatoes',
            itemLogo: null,
            qtyOrdered: 5,
            qtyReceived: 5,
            unitPrice: 10.0,
            quality: ReceiveGoodsQualityEnum.poor,
            termperature: 4,
            unit: 'kg',
            isVariance: true,
            expirationDate: '2026-12-31',
          ),
        ],
        invoiceVatRate: 15.0,
        explicitDamageAmount: 40.0,
      );
      expect(qualityOnly?.reason, 'damaged_quality');
      expect(qualityOnly?.vatInclusiveAmount, 46.00);
    });

    testWidgets(
      'Submitting ReceiveOrderSummaryView with 15% VAT sends VAT-inclusive 46.00 deduction and isolated invoice/variance files over Dio HTTP multipart',
      (tester) async {
        final adapter = _RecordingMultipartAdapter();
        final dio = Dio(BaseOptions(baseUrl: 'https://test.assab.local/api/v1/'));
        dio.httpClientAdapter = adapter;
        final remote = ReceiveGoodsRemoteDataSource(
          dio,
          baseUrl: 'https://test.assab.local/api/v1/',
        );
        final repo = ReceiveGoodsRepository(remote);
        final startCubit = StartReceiveOrderCubit(repo);
        final validationCubit = ValidationCubit(requiredFields: {});
        final pagingCubit = PagingCubit(totalSteps: 4, initialIndex: 3);

        tester.view.physicalSize = const Size(1170, 4800);
        tester.view.devicePixelRatio = 3.0;

        addTearDown(() async {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          await startCubit.close();
          await validationCubit.close();
          await pagingCubit.close();
        });

        validationCubit.validateFieldAndStoreList<ReceiveGoodsLocalItemModel>(
          fieldName: 'receiveGoodsItems',
          value: [
            ReceiveGoodsLocalItemModel(
              itemId: '11111111-1111-4111-8111-111111111111',
              productName: 'Sugar',
              itemLogo: null,
              qtyOrdered: 10,
              qtyReceived: 8,
              unitPrice: 20.0,
              quality: ReceiveGoodsQualityEnum.normal,
              termperature: 4,
              unit: 'kg',
              isVariance: true,
              expirationDate: '2026-12-31',
              vatRate: 15.0,
            ),
          ],
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'documentType',
          value: 'invoice',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'invoiceNumber',
          value: 'INV-WIDGET-46',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'invoiceDate',
          value: '2026-11-26',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'dueDate',
          value: '2026-12-26',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'paymentTerms',
          value: 'Net 30 days',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<double>(
          fieldName: 'vatRate',
          value: 15.0,
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<double>(
          fieldName: 'amountBeforeTax',
          value: 300.0,
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<double>(
          fieldName: 'vatAmount',
          value: 45.0,
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<double>(
          fieldName: 'totalAmount',
          value: 345.0,
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<MediaFile?>(
          fieldName: 'file',
          value: MediaFile(
            path: invoiceFile.path,
            name: 'invoice_doc.jpg',
            type: MediaFileType.image,
            selected: true,
            fileExtension: 'JPG',
          ),
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'note',
          value: 'Original tax invoice attached',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'varianceRequiredAction',
          value: 'deduct_from_invoice',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<MediaFile?>(
          fieldName: 'varianceFile',
          value: MediaFile(
            path: varianceFile.path,
            name: 'variance_damage.jpg',
            type: MediaFileType.image,
            selected: true,
            fileExtension: 'JPG',
          ),
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'varianceNote',
          value: '2 kg short in seal',
          isValid: true,
        );

        await tester.pumpWidget(
          _buildSummaryTestApp(
            validationCubit: validationCubit,
            startCubit: startCubit,
            pagingCubit: pagingCubit,
            orderId: '10000000-0000-4000-8000-000000000001',
          ),
        );
        await tester.pump();

        final submitFinder = find.byType(AppButton);
        expect(submitFinder, findsOneWidget);
        await tester.ensureVisible(submitFinder);
        await tester.runAsync(() async {
          await tester.tap(submitFinder);
          await Future<void>.delayed(const Duration(milliseconds: 250));
        });
        await tester.pump();
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        expect(
          adapter.captured.length,
          1,
          reason: 'startCubit state=${startCubit.state}',
        );
        final req = adapter.captured.single;
        expect(req.method, 'POST');
        expect(
          req.uri.path,
          contains('/purchase/receiving/orders/10000000-0000-4000-8000-000000000001/start'),
        );
        expect(req.contentType, contains('multipart/form-data'));

        final fields = {for (final f in req.rawFormData!.fields) f.key: f.value};
        expect(fields['variance[action]'], 'deduct_from_invoice');
        expect(fields['variance[deduct_data][amount]'], '46.00');
        expect(fields['variance[deduct_data][reason]'], 'short_quantity');
        expect(fields['variance[note]'], '2 kg short in seal');
        expect(fields['invoice_data[notes]'], 'Original tax invoice attached');
        expect(fields['invoice_data[tax_rate]'], '15');
        expect(
          fields.keys.where((k) => k.startsWith('variance[items]')),
          isEmpty,
        );

        // Verify actual wire multipart stream carries both distinct attachments & deduction payload
        expect(req.serializedMultipartBody, contains('name="variance[deduct_data][amount]"'));
        expect(req.serializedMultipartBody, contains('46.00'));
        expect(req.serializedMultipartBody, contains('filename="invoice_doc.jpg"'));
        expect(req.serializedMultipartBody, contains('filename="variance_damage.jpg"'));
        _recordWidgetContract('qty_short_15', req);
      },
    );

    testWidgets(
      'Submitting ReceiveOrderSummaryView with 0% VAT across multiple lines sends 40.00 aggregate once',
      (tester) async {
        final adapter = _RecordingMultipartAdapter();
        final dio = Dio(BaseOptions(baseUrl: 'https://test.assab.local/api/v1/'));
        dio.httpClientAdapter = adapter;
        final remote = ReceiveGoodsRemoteDataSource(
          dio,
          baseUrl: 'https://test.assab.local/api/v1/',
        );
        final startCubit = StartReceiveOrderCubit(ReceiveGoodsRepository(remote));
        final validationCubit = ValidationCubit(requiredFields: {});
        final pagingCubit = PagingCubit(totalSteps: 4, initialIndex: 3);

        tester.view.physicalSize = const Size(1170, 4800);
        tester.view.devicePixelRatio = 3.0;

        addTearDown(() async {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          await startCubit.close();
          await validationCubit.close();
          await pagingCubit.close();
        });

        validationCubit.validateFieldAndStoreList<ReceiveGoodsLocalItemModel>(
          fieldName: 'receiveGoodsItems',
          value: [
            ReceiveGoodsLocalItemModel(
              itemId: '11111111-1111-4111-8111-111111111112',
              productName: 'Rice',
              itemLogo: null,
              qtyOrdered: 10,
              qtyReceived: 9,
              unitPrice: 20.0,
              quality: ReceiveGoodsQualityEnum.normal,
              termperature: 4,
              unit: 'kg',
              isVariance: true,
              expirationDate: '2026-12-31',
              vatRate: 0.0,
            ),
            ReceiveGoodsLocalItemModel(
              itemId: '11111111-1111-4111-8111-111111111113',
              productName: 'Oil',
              itemLogo: null,
              qtyOrdered: 5,
              qtyReceived: 4,
              unitPrice: 20.0,
              quality: ReceiveGoodsQualityEnum.poor,
              termperature: 4,
              unit: 'liter',
              isVariance: true,
              expirationDate: '2026-12-31',
              vatRate: 0.0,
            ),
          ],
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'documentType',
          value: 'invoice',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'invoiceNumber',
          value: 'INV-WIDGET-0',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'invoiceDate',
          value: '2026-11-26',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'dueDate',
          value: '2026-12-26',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'paymentTerms',
          value: 'Net 30 days',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<double>(
          fieldName: 'vatRate',
          value: 0.0,
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<double>(
          fieldName: 'amountBeforeTax',
          value: 300.0,
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<MediaFile?>(
          fieldName: 'file',
          value: MediaFile(
            path: invoiceFile.path,
            name: 'invoice_doc.jpg',
            type: MediaFileType.image,
            selected: true,
            fileExtension: 'JPG',
          ),
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'varianceRequiredAction',
          value: 'deduct_from_invoice',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<MediaFile?>(
          fieldName: 'varianceFile',
          value: MediaFile(
            path: varianceFile.path,
            name: 'variance_damage.jpg',
            type: MediaFileType.image,
            selected: true,
            fileExtension: 'JPG',
          ),
          isValid: true,
        );

        await tester.pumpWidget(
          _buildSummaryTestApp(
            validationCubit: validationCubit,
            startCubit: startCubit,
            pagingCubit: pagingCubit,
            orderId: '10000000-0000-4000-8000-000000000002',
          ),
        );
        await tester.pump();

        final submitFinder = find.byType(AppButton);
        await tester.ensureVisible(submitFinder);
        await tester.runAsync(() async {
          await tester.tap(submitFinder);
          await Future<void>.delayed(const Duration(milliseconds: 250));
        });
        await tester.pump();
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        expect(adapter.captured.length, 1);
        final fields = {
          for (final f in adapter.captured.single.rawFormData!.fields) f.key: f.value,
        };
        expect(fields['variance[deduct_data][amount]'], '40.00');
        expect(fields['invoice_data[tax_rate]'], '0');
        expect(
          fields.keys.where((k) => k.startsWith('variance[items]')),
          isEmpty,
        );
        _recordWidgetContract('qty_short_0', adapter.captured.single);
      },
    );

    testWidgets(
      'Submitting ReceiveOrderSummaryView with quality-only variance and 15% VAT sends VAT-inclusive 23.00 deduction without fabricating shortage items',
      (tester) async {
        final adapter = _RecordingMultipartAdapter();
        final dio = Dio(BaseOptions(baseUrl: 'https://test.assab.local/api/v1/'));
        dio.httpClientAdapter = adapter;
        final remote = ReceiveGoodsRemoteDataSource(
          dio,
          baseUrl: 'https://test.assab.local/api/v1/',
        );
        final startCubit = StartReceiveOrderCubit(ReceiveGoodsRepository(remote));
        final validationCubit = ValidationCubit(requiredFields: {});
        final pagingCubit = PagingCubit(totalSteps: 4, initialIndex: 3);

        tester.view.physicalSize = const Size(1170, 4800);
        tester.view.devicePixelRatio = 3.0;

        addTearDown(() async {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          await startCubit.close();
          await validationCubit.close();
          await pagingCubit.close();
        });

        validationCubit.validateFieldAndStoreList<ReceiveGoodsLocalItemModel>(
          fieldName: 'receiveGoodsItems',
          value: [
            ReceiveGoodsLocalItemModel(
              itemId: '22222222-2222-4222-8222-222222222221',
              productName: 'Milk',
              itemLogo: null,
              qtyOrdered: 5,
              qtyReceived: 5,
              unitPrice: 20.0,
              quality: ReceiveGoodsQualityEnum.poor,
              termperature: 12,
              unit: 'box',
              isVariance: true,
              expirationDate: '2026-12-31',
              vatRate: 15.0,
            ),
          ],
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'documentType',
          value: 'invoice',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'invoiceNumber',
          value: 'INV-WIDGET-QUAL-15',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'invoiceDate',
          value: '2026-11-26',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'dueDate',
          value: '2026-12-26',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'paymentTerms',
          value: 'Net 30 days',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<double>(
          fieldName: 'vatRate',
          value: 15.0,
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<double>(
          fieldName: 'amountBeforeTax',
          value: 100.0,
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<MediaFile?>(
          fieldName: 'file',
          value: MediaFile(
            path: invoiceFile.path,
            name: 'invoice_doc.jpg',
            type: MediaFileType.image,
            selected: true,
            fileExtension: 'JPG',
          ),
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'varianceRequiredAction',
          value: 'deduct_from_invoice',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<MediaFile?>(
          fieldName: 'varianceFile',
          value: MediaFile(
            path: varianceFile.path,
            name: 'variance_damage.jpg',
            type: MediaFileType.image,
            selected: true,
            fileExtension: 'JPG',
          ),
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'deductAmount',
          value: '20.00',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'varianceNote',
          value: 'Damaged cartons',
          isValid: true,
        );

        await tester.pumpWidget(
          _buildSummaryTestApp(
            validationCubit: validationCubit,
            startCubit: startCubit,
            pagingCubit: pagingCubit,
            orderId: '20000000-0000-4000-8000-000000000001',
          ),
        );
        await tester.pump();

        final submitFinder = find.byType(AppButton);
        await tester.ensureVisible(submitFinder);
        await tester.runAsync(() async {
          await tester.tap(submitFinder);
          await Future<void>.delayed(const Duration(milliseconds: 250));
        });
        await tester.pump();
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        expect(adapter.captured.length, 1);
        final fields = {
          for (final f in adapter.captured.single.rawFormData!.fields) f.key: f.value,
        };
        expect(fields['variance[action]'], 'deduct_from_invoice');
        expect(fields['variance[deduct_data][amount]'], '23.00');
        expect(fields['variance[deduct_data][reason]'], 'damaged_quality');
        expect(fields['invoice_data[tax_rate]'], '15');
        expect(
          fields.keys.where((k) => k.startsWith('variance[items]')),
          isEmpty,
        );
        _recordWidgetContract('quality_only_15', adapter.captured.single);
      },
    );

    testWidgets(
      'Submitting ReceiveOrderSummaryView with quality-only variance and 0% VAT sends 20.00 deduction without variance.items',
      (tester) async {
        final adapter = _RecordingMultipartAdapter();
        final dio = Dio(BaseOptions(baseUrl: 'https://test.assab.local/api/v1/'));
        dio.httpClientAdapter = adapter;
        final remote = ReceiveGoodsRemoteDataSource(
          dio,
          baseUrl: 'https://test.assab.local/api/v1/',
        );
        final startCubit = StartReceiveOrderCubit(ReceiveGoodsRepository(remote));
        final validationCubit = ValidationCubit(requiredFields: {});
        final pagingCubit = PagingCubit(totalSteps: 4, initialIndex: 3);

        tester.view.physicalSize = const Size(1170, 4800);
        tester.view.devicePixelRatio = 3.0;

        addTearDown(() async {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          await startCubit.close();
          await validationCubit.close();
          await pagingCubit.close();
        });

        validationCubit.validateFieldAndStoreList<ReceiveGoodsLocalItemModel>(
          fieldName: 'receiveGoodsItems',
          value: [
            ReceiveGoodsLocalItemModel(
              itemId: '22222222-2222-4222-8222-222222222222',
              productName: 'Milk',
              itemLogo: null,
              qtyOrdered: 5,
              qtyReceived: 5,
              unitPrice: 20.0,
              quality: ReceiveGoodsQualityEnum.poor,
              termperature: 12,
              unit: 'box',
              isVariance: true,
              expirationDate: '2026-12-31',
              vatRate: 0.0,
            ),
          ],
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'documentType',
          value: 'invoice',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'invoiceNumber',
          value: 'INV-WIDGET-QUAL-0',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'invoiceDate',
          value: '2026-11-26',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'dueDate',
          value: '2026-12-26',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'paymentTerms',
          value: 'Net 30 days',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<double>(
          fieldName: 'vatRate',
          value: 0.0,
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<double>(
          fieldName: 'amountBeforeTax',
          value: 100.0,
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<MediaFile?>(
          fieldName: 'file',
          value: MediaFile(
            path: invoiceFile.path,
            name: 'invoice_doc.jpg',
            type: MediaFileType.image,
            selected: true,
            fileExtension: 'JPG',
          ),
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'varianceRequiredAction',
          value: 'deduct_from_invoice',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreTypedValue<MediaFile?>(
          fieldName: 'varianceFile',
          value: MediaFile(
            path: varianceFile.path,
            name: 'variance_damage.jpg',
            type: MediaFileType.image,
            selected: true,
            fileExtension: 'JPG',
          ),
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'deductAmount',
          value: '20.00',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'varianceNote',
          value: 'Damaged cartons zero vat',
          isValid: true,
        );

        await tester.pumpWidget(
          _buildSummaryTestApp(
            validationCubit: validationCubit,
            startCubit: startCubit,
            pagingCubit: pagingCubit,
            orderId: '20000000-0000-4000-8000-000000000002',
          ),
        );
        await tester.pump();

        final submitFinder = find.byType(AppButton);
        await tester.ensureVisible(submitFinder);
        await tester.runAsync(() async {
          await tester.tap(submitFinder);
          await Future<void>.delayed(const Duration(milliseconds: 250));
        });
        await tester.pump();
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        expect(adapter.captured.length, 1);
        final fields = {
          for (final f in adapter.captured.single.rawFormData!.fields) f.key: f.value,
        };
        expect(fields['variance[action]'], 'deduct_from_invoice');
        expect(fields['variance[deduct_data][amount]'], '20.00');
        expect(fields['variance[deduct_data][reason]'], 'damaged_quality');
        expect(fields['invoice_data[tax_rate]'], '0');
        expect(
          fields.keys.where((k) => k.startsWith('variance[items]')),
          isEmpty,
        );
        _recordWidgetContract('quality_only_0', adapter.captured.single);
      },
    );

    testWidgets(
      'Submitting ReceiveOrderSummaryView with compensatory_order sends positive shortage variance items',
      (tester) async {
        final adapter = _RecordingMultipartAdapter();
        final dio = Dio(BaseOptions(baseUrl: 'https://test.assab.local/api/v1/'));
        dio.httpClientAdapter = adapter;
        final remote = ReceiveGoodsRemoteDataSource(
          dio,
          baseUrl: 'https://test.assab.local/api/v1/',
        );
        final startCubit = StartReceiveOrderCubit(ReceiveGoodsRepository(remote));
        final validationCubit = ValidationCubit(requiredFields: {});
        final pagingCubit = PagingCubit(totalSteps: 4, initialIndex: 3);

        tester.view.physicalSize = const Size(1170, 4800);
        tester.view.devicePixelRatio = 3.0;

        addTearDown(() async {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          await startCubit.close();
          await validationCubit.close();
          await pagingCubit.close();
        });

        validationCubit.validateFieldAndStoreList<ReceiveGoodsLocalItemModel>(
          fieldName: 'receiveGoodsItems',
          value: [
            ReceiveGoodsLocalItemModel(
              itemId: '33333333-3333-4333-8333-333333333331',
              productName: 'Sugar',
              itemLogo: null,
              qtyOrdered: 10,
              qtyReceived: 8,
              unitPrice: 20.0,
              quality: ReceiveGoodsQualityEnum.normal,
              termperature: 4,
              unit: 'kg',
              isVariance: true,
              expirationDate: '2026-12-31',
              vatRate: 15.0,
            ),
          ],
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'documentType',
          value: 'delivery_note',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'varianceRequiredAction',
          value: 'compensatory_order',
          isValid: true,
        );
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'varianceNote',
          value: 'Send replacement 2 kg',
          isValid: true,
        );

        await tester.pumpWidget(
          _buildSummaryTestApp(
            validationCubit: validationCubit,
            startCubit: startCubit,
            pagingCubit: pagingCubit,
            orderId: '30000000-0000-4000-8000-000000000001',
          ),
        );
        await tester.pump();

        final submitFinder = find.byType(AppButton);
        await tester.ensureVisible(submitFinder);
        await tester.runAsync(() async {
          await tester.tap(submitFinder);
          await Future<void>.delayed(const Duration(milliseconds: 250));
        });
        await tester.pump();
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        expect(adapter.captured.length, 1);
        final fields = {
          for (final f in adapter.captured.single.rawFormData!.fields) f.key: f.value,
        };
        expect(fields['variance[action]'], 'compensatory_order');
        expect(
          fields['variance[items][0][item_id]'],
          '33333333-3333-4333-8333-333333333331',
        );
        expect(fields['variance[items][0][quantity]'], '2.0');
      },
    );
  });
}
