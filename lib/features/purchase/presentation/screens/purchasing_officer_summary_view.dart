import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../recurring_orders/domain/strategies/create_recurring_order_strategy.dart';
import '../../../recurring_orders/presentation/screens/recurring_order_setting_screen.dart';
import '../../data/models/purchase_create_order_request.dart';
import '../../data/models/source_local_model.dart';
import '../cubit/get_purchase_products_officer_details/get_purchase_products_officer_details_cubit.dart';
import '../cubit/get_purchase_products_officer_details/get_purchase_products_officer_details_state.dart';
import '../widgets/purchasing_officer_summary_view_product_details_section.dart';
import '../widgets/purchasing_officer_summary_view_purchasing_officer_benefits_section.dart';
import '../widgets/purchasing_officer_summary_view_request_summary_section.dart';

class PurchasingOfficerSummaryView extends StatefulWidget {
  final SourceLocalModel source;
  final PurchaseCreateOrderRequest createOrderRequest;
  final int sourceIndex;
  final PurchaseSourceStrategy sourceType;

  const PurchasingOfficerSummaryView({
    super.key,
    required this.source,
    required this.createOrderRequest,
    required this.sourceIndex,
    required this.sourceType,
  });

  @override
  State<PurchasingOfficerSummaryView> createState() =>
      _PurchasingOfficerSummaryViewState();
}

class _PurchasingOfficerSummaryViewState
    extends State<PurchasingOfficerSummaryView> {
  late final ValueNotifier<double> _totalSavingsNotifier;

  @override
  void initState() {
    super.initState();
    _totalSavingsNotifier = ValueNotifier<double>(0);

    context
        .read<GetPurchaseProductsOfficerDetailsCubit>()
        .getPurchaseProductOfficerDetails();
  }

  @override
  void dispose() {
    _totalSavingsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const PurchasingOfficerSummaryViewRequestSummarySection()
            .sliverBoxAdapter,
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
        PurchasingOfficerSummaryViewProductDetailsSection(
          source: widget.source,
          totalSavings: (total) {
            _totalSavingsNotifier.value = total;
          },
          createOrderRequest: widget.createOrderRequest,
        ),
        const PurchasingOfficerSummaryViewPurchasingOfficerBenefitsSection(),
        8.verticalSpace.sliverBoxAdapter,
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffE51B92),
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 20.r),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.tr.totalExpectedSavings,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                ),
              ),
              10.horizontalSpace,
              SaudiRiyalSvgWidget(color: context.customColor.reversedTextColor),
              ValueListenableBuilder<double>(
                valueListenable: _totalSavingsNotifier,
                builder: (context, value, child) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: AppStyles.s13WB.copyWith(
                      color: context.customColor.reversedTextColor,
                    ),
                  );
                },
              ),
            ],
          ),
        ).sliverBoxAdapter,
        20.verticalSpace.sliverBoxAdapter,
        BlocSelector<
              GetPurchaseProductsOfficerDetailsCubit,
              GetPurchaseProductsOfficerDetailsState,
              bool
            >(
              selector: (state) =>
                  state is GetPurchaseProductsOfficerDetailsSuccess,
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
            )
            .sliverBoxAdapter,
      ],
    );
  }
}
