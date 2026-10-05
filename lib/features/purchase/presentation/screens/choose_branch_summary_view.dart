import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/purchase/presentation/cubit/get_purchase_products_branch_details/get_purchase_products_branch_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../data/models/purchase_create_order_request.dart';
import '../../data/models/source_local_model.dart';
import '../widgets/choose_branch_summary_view_priority_section.dart';
import '../widgets/choose_branch_summary_view_product_details_section.dart';
import '../widgets/choose_branch_summary_view_request_summary_section.dart';
import '../widgets/choose_branch_summary_view_transport_details_section.dart';

class ChooseBranchSummaryView extends StatefulWidget {
  final SourceLocalModel branch;
  final PurchaseCreateOrderRequest createOrderRequest;

  const ChooseBranchSummaryView({
    super.key,
    required this.branch,
    required this.createOrderRequest,
  });

  @override
  State<ChooseBranchSummaryView> createState() =>
      _ChooseBranchSummaryViewState();
}

class _ChooseBranchSummaryViewState extends State<ChooseBranchSummaryView> {
  late final ValidationCubit _validationCubit;
  final PurchaseCreateOrderRequestBranch _branchRequest =
      PurchaseCreateOrderRequestBranch();

  @override
  void initState() {
    super.initState();

    _validationCubit = context.read<ValidationCubit>();
    _addDynamicFields();
    _getProductsForBranch();
  }

  @override
  void dispose() {
    _removeDynamicFields();
    super.dispose();
  }

  void _addDynamicFields() {
    final String branchId = widget.branch.sourceId;

    if (!_validationCubit.state.fieldsValue.containsKey('priority_$branchId') ||
        !_validationCubit.state.fieldsValue.containsKey(
          'justification_$branchId',
        )) {
      _validationCubit.addDynamicFields({
        'priority_$branchId',
        'justification_$branchId',
      });
    }
  }

  void _removeDynamicFields() {
    final String branchId = widget.branch.sourceId;
    _validationCubit.removeDynamicFields({
      'priority_$branchId',
      'justification_$branchId',
    });
  }

  void _getProductsForBranch() {
    context
        .read<GetPurchaseProductsBranchDetailsCubit>()
        .getPurchaseProductsBranchDetails(branchId: widget.branch.sourceId);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        LabelTextField(text: context.tr.requestJustification).sliverBoxAdapter,
        ContainerCustomTextField(
          child: CustomTextField(
            hintText: context
                .tr
                .egUnexpectedIncreaseInDemandDuringWeekendHolidayCurrentStock,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            onChanged: (value) {
              context.read<ValidationCubit>().validateFieldAndStoreValue(
                fieldName: 'justification_${widget.branch.sourceId}',
                value: value,
                isValid: value.isNotEmpty,
              );

              _branchRequest.updateJustification(value);
            },
          ),
        ).sliverBoxAdapter,
        12.verticalSpace.sliverBoxAdapter,
        ChooseBranchSummaryViewPrioritySection(
          fieldName: 'priority_${widget.branch.sourceId}',
          branchRequest: _branchRequest,
        ).sliverBoxAdapter,
        12.verticalSpace.sliverBoxAdapter,
        ChooseBranchSummaryViewRequestSummarySection(
          branch: widget.branch,
        ).sliverBoxAdapter,
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
        ChooseBranchSummaryViewProductDetailsSection(
          branch: widget.branch,
          createOrderRequest: widget.createOrderRequest,
          branchRequest: _branchRequest,
        ),
        ChooseBranchSummaryViewTransportDetailsSection(branch: widget.branch),
      ],
    );
  }
}
