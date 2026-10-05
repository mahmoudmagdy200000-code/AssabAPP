import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../../recurring_orders/domain/strategies/create_recurring_order_strategy.dart';
import '../../../recurring_orders/presentation/screens/recurring_order_setting_screen.dart';
import '../../data/models/purchase_create_order_request.dart';
import '../../data/models/source_local_model.dart';
import '../cubit/get_purchase_products_supplier_details/get_purchase_products_supplier_details_cubit.dart';
import '../cubit/get_purchase_products_supplier_details/get_purchase_products_supplier_details_state.dart';
import '../widgets/direct_supplier_summary_view_contact_modes_section.dart';
import '../widgets/direct_supplier_summary_view_product_details_section.dart';
import '../widgets/direct_supplier_summary_view_request_summary_section.dart';

class DirectSupplierSummaryView extends StatefulWidget {
  final SourceLocalModel source;
  final PurchaseCreateOrderRequest createOrderRequest;
  final int sourceIndex;
  final PurchaseSourceStrategy sourceType;

  const DirectSupplierSummaryView({
    super.key,
    required this.source,
    required this.createOrderRequest,
    required this.sourceIndex,
    required this.sourceType,
  });

  @override
  State<DirectSupplierSummaryView> createState() =>
      _DirectSupplierSummaryViewState();
}

class _DirectSupplierSummaryViewState extends State<DirectSupplierSummaryView> {
  late final ValueNotifier<Map<int, bool>> _selectedNotifiedIndexNotifier;
  late final ValidationCubit _validationCubit;
  final PurchaseCreateOrderRequestDirectSupplier _supplier =
      PurchaseCreateOrderRequestDirectSupplier();

  @override
  void initState() {
    super.initState();

    _validationCubit = context.read<ValidationCubit>();

    _getPurchaseProductsSupplierDetails();

    _selectedNotifiedIndexNotifier = ValueNotifier<Map<int, bool>>({
      0: false,
      1: false,
      2: false,
      3: false,
    });

    _syncDynamicField();
  }

  @override
  void dispose() {
    _removeDynamicFields();
    _selectedNotifiedIndexNotifier.dispose();
    super.dispose();
  }

  void _getPurchaseProductsSupplierDetails() {
    context
        .read<GetPurchaseProductsSupplierDetailsCubit>()
        .getPurchaseProductsSupplierDetails(supplierId: widget.source.sourceId);
  }

  void _syncDynamicField() {
    _validationCubit.addDynamicFields({
      'notificationOptions_${widget.source.sourceId}',
      'email_${widget.source.sourceId}',
      'whatsapp_${widget.source.sourceId}',
      'inAppNotification_${widget.source.sourceId}',
      'sms_${widget.source.sourceId}',
    });

    _validationCubit.toggleFieldRequirement(
      'email_${widget.source.sourceId}',
      isRequired: false,
    );
    _validationCubit.toggleFieldRequirement(
      'whatsapp_${widget.source.sourceId}',
      isRequired: false,
    );
    _validationCubit.toggleFieldRequirement(
      'inAppNotification_${widget.source.sourceId}',
      isRequired: false,
    );
    _validationCubit.toggleFieldRequirement(
      'sms_${widget.source.sourceId}',
      isRequired: false,
    );
  }

  void _removeDynamicFields() {
    _validationCubit.removeDynamicFields({
      'notificationOptions_${widget.source.sourceId}',
      'email_${widget.source.sourceId}',
      'whatsapp_${widget.source.sourceId}',
      'inAppNotification_${widget.source.sourceId}',
      'sms_${widget.source.sourceId}',
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetPurchaseProductsSupplierDetailsCubit,
      GetPurchaseProductsSupplierDetailsState
    >(
      builder: (context, state) {
        if (state is GetPurchaseProductsSupplierDetailsLoading) {
          return const AppLoadingWidget();
        } else if (state is GetPurchaseProductsSupplierDetailsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: _getPurchaseProductsSupplierDetails,
            withBorder: false,
          );
        } else if (state is GetPurchaseProductsSupplierDetailsSuccess) {
          final choosedIds = widget.source.choosedItemSourceIds.toSet();

          final filteredProducts = state.details.data
              .where((item) => choosedIds.contains(item.itemId))
              .toList();

          // Build a map from itemId → requestedQty for correct alignment
          // regardless of API vs. selection order.
          final qtyByItemId = <String, String>{};
          for (int i = 0; i < widget.source.choosedItemSourceIds.length; i++) {
            qtyByItemId[widget.source.choosedItemSourceIds[i]] =
                widget.source.requestedQty[i];
          }

          final total = filteredProducts.fold<double>(0, (sum, product) {
            final qty =
                double.tryParse(qtyByItemId[product.itemId] ?? '0') ?? 0;
            return sum + product.itemPrice * qty;
          });

          return CustomScrollView(
            slivers: [
              DirectSupplierSummaryViewRequestSummarySection(
                totalAmount: total.toStringAsFixed(2),
                supplier: state.details.supplier,
              ).sliverBoxAdapter,
              12.verticalSpace.sliverBoxAdapter,
              LabelTextField(
                text: context.tr.howShouldSupplierBeNotified,
              ).sliverBoxAdapter,
              5.verticalSpace.sliverBoxAdapter,
              DirectSupplierSummaryViewContactModesSection(
                selectedNotifiedIndexNotifier: _selectedNotifiedIndexNotifier,
                supplierId: widget.source.sourceId,
                supplier: _supplier,
              ),
              12.verticalSpace.sliverBoxAdapter,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr.productDetails,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  AppSvgButton(
                    assetName: AppAssets.edit,
                    withBorder: false,
                    onTap: () {},
                  ),
                ],
              ).sliverBoxAdapter,
              10.verticalSpace.sliverBoxAdapter,
              const CustomDivider().sliverBoxAdapter,
              10.verticalSpace.sliverBoxAdapter,
              DirectSupplierSummaryViewProductDetailsSection(
                source: widget.source,
                productsDetails: filteredProducts,
                createOrderRequest: widget.createOrderRequest,
                supplier: _supplier,
              ),
              10.verticalSpace.sliverBoxAdapter,
              BlocSelector<ValidationCubit, ValidationState, bool>(
                selector: (state) => state.enableButton,
                builder: (context, state) {
                  return AppButton(
                    text: context.tr.createAsShcedule,
                    onClick: () {
                      AppBottomSheet.customPageRoute(
                        context,
                        (context) => RecurringOrderSettingScreen(
                          strategy: CreateNewCreateRecurringOrderStrategy(),
                          createOrderRequest: widget.createOrderRequest,
                          source: widget.sourceType,
                          sourceIndex: widget.sourceIndex,
                        ),
                      );
                    },
                    enabled: state,
                    background: context.customColor.dark,
                  );
                },
              ).sliverBoxAdapter,
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
