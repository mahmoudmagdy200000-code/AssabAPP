import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/enums/receive_goods_quality_enum.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/features/receive_goods/data/models/receive_goods_local_item_model.dart';
import 'package:assab/features/receive_goods/domain/strategies/variance_required_actions_strategy.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithApp(ValidationCubit cubit, Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: LightTheme.extension),
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider.value(
        value: cubit,
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets(
    'CreateCompensatoryOrder hides amountToDeduct while DeductFromInvoice shows 46.00',
    (tester) async {
      final cubit = ValidationCubit(requiredFields: {'vatRate'});
      cubit.validateFieldAndStoreValue(
        fieldName: 'vatRate',
        value: '0.15',
        isValid: true,
      );
      cubit.validateFieldAndStoreTypedValue<List<ReceiveGoodsLocalItemModel>>(
        fieldName: 'receiveGoodsItems',
        value: [
          ReceiveGoodsLocalItemModel(
            itemId: 'item-1',
            productName: 'Tomato',
            itemLogo: null,
            unit: 'kg',
            qtyOrdered: 10,
            qtyReceived: 8,
            unitPrice: 20,
            quality: ReceiveGoodsQualityEnum.excellent,
            termperature: 4,
            isVariance: true,
            expirationDate: '2026-11-30',
          ),
        ],
        isValid: true,
      );

      final comp = CreateCompensatoryOrderVarianceRequiredActionsStrategy();
      final ded = DeductFromInvoiceValueVarianceRequiredActionsStrategy();

      await tester.pumpWidget(
        wrapWithApp(
          cubit,
          Builder(
            builder: (context) {
              AppResponsive.init(context, designWidth: 390, designHeight: 844);
              return Column(
                children: [
                  comp.buildAmountDetailsWidget(context, true),
                  ded.buildAmountDetailsWidget(context, true),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('46.00'), findsOneWidget);
      expect(find.text('Amount to Deduct'), findsOneWidget);
    },
  );
}
