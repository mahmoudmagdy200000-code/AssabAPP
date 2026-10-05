import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_file_image.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../supplier_requests/presentation/widgets/supplier_item_preview_widget.dart';
import '../../data/models/receive_goods_local_item_model.dart';

class ReceiveOrderOrderView extends StatefulWidget {
  const ReceiveOrderOrderView({super.key});

  @override
  State<ReceiveOrderOrderView> createState() => _ReceiveOrderOrderViewState();
}

class _ReceiveOrderOrderViewState extends State<ReceiveOrderOrderView> {
  late final ValidationCubit _validationCubit;
  @override
  void initState() {
    super.initState();
    _validationCubit = context.read<ValidationCubit>();
  }

  @override
  void dispose() {
    // Clean up any dynamic fields added for this view
    _validationCubit.removeDynamicFields(
      _validationCubit.state.fieldsValue.keys
          .where(
            (key) =>
                key.startsWith('qtyToReorder_') ||
                key.startsWith('order_quality_'),
          )
          .toSet(),
    );

    super.dispose();
  }

  void _addDynamicFieldListViewItems(List<ReceiveGoodsLocalItemModel> items) {
    for (final good in items) {
      _validationCubit.addDynamicFields({
        'qtyToReorder_${good.itemId}',
        'order_quality_${good.itemId}',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              Text(
                context.tr.fillOutCompensatoryOrderDetails,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text1,
                ),
              ).sliverBoxAdapter,
              12.verticalSpace.sliverBoxAdapter,
              const CustomDivider().sliverBoxAdapter,
              12.verticalSpace.sliverBoxAdapter,
              BlocSelector<
                ValidationCubit,
                ValidationState,
                List<ReceiveGoodsLocalItemModel>
              >(
                selector: (state) {
                  final itemsWithVariance =
                      (state.getListValue<ReceiveGoodsLocalItemModel>(
                                'receiveGoodsItems',
                              ) ??
                              [])
                          .where((item) => item.isVariance)
                          .toList();

                  _addDynamicFieldListViewItems(itemsWithVariance);

                  return itemsWithVariance;
                },
                builder: (context, items) {
                  return SliverList.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final unitText = item.unit;

                      _validationCubit.validateFieldAndStoreTypedValue<int>(
                        fieldName: 'qtyToReorder_${item.itemId}',
                        value: item.qtyOrdered - item.qtyReceived,
                        isValid: true,
                      );

                      _validationCubit.validateFieldAndStoreValue(
                        fieldName: 'order_quality_${item.itemId}',
                        value: item.quality.toString(),
                        isValid: true,
                      );

                      return _buildItemCard(context, item, unitText);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        20.verticalSpace,
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                text: context.tr.back,
                onTap: () {
                  context.read<PagingCubit>().previousStep();
                },
                padding: EdgeInsets.symmetric(vertical: 18.r),
                textColor: context.customColor.text1,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: BlocSelector<ValidationCubit, ValidationState, bool>(
                selector: (state) {
                  final dynamicFieldKeys = state.fieldsValidity.keys
                      .where(
                        (key) =>
                            key.startsWith('qtyToReorder_') ||
                            key.startsWith('order_quality_'),
                      )
                      .toList();

                  return dynamicFieldKeys.every(
                    (key) => state.fieldsValidity[key] == true,
                  );
                },
                builder: (context, state) {
                  return AppButton(
                    onClick: () {
                      context.read<PagingCubit>().nextStep();
                    },
                    enabled: state,
                    text: context.tr.viewSummary,
                    borderRadius: BorderRadius.circular(15.r),
                    padding: EdgeInsets.symmetric(vertical: 18.r),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    ReceiveGoodsLocalItemModel item,
    String unitText,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      margin: EdgeInsets.only(bottom: 10.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SupplierItemPreviewWidget(
            itemName: item.productName,
            itemImageUrl: item.itemLogo,
          ),
          5.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.qtyToReorder,
            value: '${item.qtyOrdered - item.qtyReceived} $unitText',
          ),
          10.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.quality,
            value: item.quality.getString(context),
          ),
          10.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.reorderSource,
            value:
                context
                    .read<ValidationCubit>()
                    .state
                    .fieldsValue['supplierName'] ??
                '-',
          ),
          12.verticalSpace,
          _buildItemImageWidget(context, item.selectedImage!),
          12.verticalSpace,
          _buildAdditionalNoteWidget(context, item.note),
        ],
      ),
    );
  }

  Widget _buildItemImageWidget(BuildContext context, MediaFile imageFile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(text: context.tr.attachPhotoEvidence),
        4.verticalSpace,
        AppFileImage(
          image: imageFile.path,
          borderRadius: BorderRadius.circular(12.r),
          height: 200.r,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildRowWidget({
    required BuildContext context,
    required String title,
    String? value,
    Widget? customValue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Expanded(
          child:
              customValue ??
              Text(
                value ?? '',
                textAlign: TextAlign.end,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildAdditionalNoteWidget(BuildContext context, String? note) {
    if (note == null || note.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        LabelTextField(text: context.tr.additionalNote),
        4.verticalSpace,
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.customColor.reversedTextColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
          child: Text(
            note,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text1),
          ),
        ),
        10.verticalSpace,
      ],
    );
  }
}
