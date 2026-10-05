import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/enums/receive_goods_quality_enum.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/widgets/app_check_box.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/file_preview_widget.dart';
import '../../../../core/widgets/media_main_screen.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../../core/widgets/selected_image_preview.dart';
import '../../../branch_manager_requests/data/models/direct_supplier_order_details_response.dart';

class CreateReturnReturnDetailsSectionItemListView extends StatefulWidget {
  final DirectSupplierOrderDetailsProductDetail item;

  const CreateReturnReturnDetailsSectionItemListView({
    super.key,
    required this.item,
  });

  @override
  State<CreateReturnReturnDetailsSectionItemListView> createState() =>
      _CreateReturnReturnDetailsSectionItemListViewState();
}

class _CreateReturnReturnDetailsSectionItemListViewState
    extends State<CreateReturnReturnDetailsSectionItemListView> {
  late final ValueNotifier<bool> _isCheckedNotifier;

  List<ReceiveGoodsQualityEnum> get _qualities => [
    ReceiveGoodsQualityEnum.excellent,
    ReceiveGoodsQualityEnum.normal,
    ReceiveGoodsQualityEnum.poor,
  ];

  @override
  void initState() {
    super.initState();

    _isCheckedNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _isCheckedNotifier.dispose();
    super.dispose();
  }

  void _addDynamicFields() {
    context.read<ValidationCubit>().addDynamicFields({
      'return_quantity_${widget.item.id}',
      'reason_quality_${widget.item.id}',
      'files_${widget.item.id}',
    });
  }

  void _removeDynamicFields() {
    context.read<ValidationCubit>().removeDynamicFields({
      'return_quantity_${widget.item.id}',
      'reason_quality_${widget.item.id}',
      'files_${widget.item.id}',
    });
  }

  void _openFilePicker(BuildContext context) {
    final mediaCubit = context.read<MediaCubit>();

    NavigationService.I.push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: mediaCubit,
          child: const MediaMainScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MediaCubit>(),
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.text2,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 10.r),
        margin: EdgeInsets.only(bottom: 8.r),
        child: Column(
          children: [
            Row(
              children: [
                PurchaseItemImage(
                  bgColor: context.customColor.reversedTextColor,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    widget.item.itemName,
                    style: AppStyles.s14W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                5.horizontalSpace,
                ValueListenableBuilder<bool>(
                  valueListenable: _isCheckedNotifier,
                  builder: (context, isCheckedNotifierValue, child) {
                    return AppCheckBox(
                      onChanged: (value) {
                        _isCheckedNotifier.value = value;

                        if (value) {
                          _addDynamicFields();
                        } else {
                          _removeDynamicFields();
                        }
                      },
                      value: isCheckedNotifierValue,
                    );
                  },
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: ValueListenableBuilder<bool>(
                valueListenable: _isCheckedNotifier,
                builder: (context, value, child) {
                  if (!value) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      8.verticalSpace,
                      CustomDivider(color: context.customColor.border),
                      8.verticalSpace,
                      _buildRowWidget(
                        context: context,
                        title: context.tr.returnQuantity,
                        customValue: ContainerCustomTextField(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.r,
                            vertical: 5.r,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          backgroundColor:
                              context.customColor.reversedTextColor,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  hintText: '0',
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    context
                                        .read<ValidationCubit>()
                                        .validateFieldAndStoreValue(
                                          fieldName:
                                              'return_quantity_${widget.item.id}',
                                          value: value,
                                          isValid:
                                              value.isNotEmpty &&
                                              (int.tryParse(value) ?? 0) > 0,
                                        );
                                  },
                                ),
                              ),
                              2.horizontalSpace,
                              Text(
                                '/${widget.item.itemUnit}',
                                style: AppStyles.s10W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ),
                              4.horizontalSpace,
                              AppSvg(
                                assetName: AppAssets.edit,
                                width: 10.r,
                                colorFilter: ColorFilter.mode(
                                  context.theme.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      8.verticalSpace,
                      CustomDivider(color: context.customColor.border),
                      8.verticalSpace,
                      _buildRowWidget(
                        context: context,
                        title: context.tr.reasonQuality,
                        customValue: CustomDropdown<ReceiveGoodsQualityEnum>(
                          items: _qualities,
                          displayTextBuilder: (value) =>
                              value?.getString(context) ??
                              context.tr.selectQuality,
                          displayTextSize: 12.r,
                          displayTextWeight: FontWeight.w500,
                          hint: context.tr.selectQuality,
                          dropdownHeight: 150.r,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.r,
                            vertical: 5.r,
                          ),
                          backgroundColor:
                              context.customColor.reversedTextColor,
                          iconSize: 15.r,
                          borderRadius: 10.r,
                          onChanged: (value) {
                            context
                                .read<ValidationCubit>()
                                .validateFieldAndStoreValue(
                                  fieldName: 'reason_quality_${widget.item.id}',
                                  value: value.toString(),
                                  isValid: true,
                                );
                          },
                          itemBuilder: (context, item, isSelected) {
                            return Container(
                              padding: EdgeInsets.all(16.r),
                              child: Text(
                                item.getString(context),
                                style: AppStyles.s12W500.copyWith(
                                  color: isSelected
                                      ? context.theme.primaryColor
                                      : context.customColor.text1,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      8.verticalSpace,
                      CustomDivider(color: context.customColor.border),
                      8.verticalSpace,
                      _buildRowWidget(
                        context: context,
                        title: context.tr.value,
                        customValue: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SaudiRiyalSvgWidget(
                              color: context.customColor.text1,
                            ),
                            Text(
                              widget.item.itemPrice.toStringAsFixed(2),
                              textAlign: TextAlign.end,
                              style: AppStyles.s13W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      8.verticalSpace,
                      CustomDivider(color: context.customColor.border),
                      8.verticalSpace,
                      BlocSelector<MediaCubit, MediaState, List<MediaFile>>(
                        selector: (state) {
                          if (state is MediaLoaded) {
                            final file = state.allFiles
                                .where((file) => file.selected)
                                .toList();

                            return file;
                          }

                          return <MediaFile>[];
                        },
                        builder: (context, state) {
                          return Row(
                            children: [
                              Expanded(
                                child: LabelTextField(
                                  text: context.tr.attachEvidences,
                                ),
                              ),
                              10.horizontalSpace,
                              if (state.length > 1)
                                ButtonTextIcon(
                                  onTap: () {
                                    _openFilePicker(context);
                                  },
                                  label: context.tr.addFile,
                                  icon: AppSvg(
                                    assetName: AppAssets.upload,
                                    width: 12.r,
                                    colorFilter: ColorFilter.mode(
                                      context.theme.primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  spaceBetweenTextAndIcon: 7.r,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.r,
                                    vertical: 8.r,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderColor: context.theme.primaryColor,
                                  textColor: context.theme.primaryColor,
                                ),
                            ],
                          );
                        },
                      ),
                      8.verticalSpace,
                      BlocSelector<MediaCubit, MediaState, List<MediaFile>>(
                        selector: (state) {
                          if (state is MediaLoaded) {
                            final file = state.allFiles
                                .where((file) => file.selected)
                                .toList();

                            context
                                .read<ValidationCubit>()
                                .validateFieldAndStoreList<MediaFile>(
                                  fieldName: 'files_${widget.item.id}',
                                  value: file,
                                  isValid: file.isNotEmpty,
                                );

                            return file;
                          }

                          return <MediaFile>[];
                        },
                        builder: (context, state) {
                          if (state.isNotEmpty) {
                            if (state.length == 1) {
                              return SelectedImagePreview(
                                mediaFile: state.first,
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  color: context.customColor.reversedTextColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.r,
                                  vertical: 10.r,
                                ),
                                child: ListView.builder(
                                  itemCount: state.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) =>
                                      FilePreviewWidget(
                                        file: state[index],
                                        icon: AppAssets.trashSvg,
                                        borderColor: Colors.transparent,
                                        onTapIcon: () {
                                          context.read<MediaCubit>().removeFile(
                                            state[index],
                                          );
                                        },
                                      ),
                                ),
                              );
                            }
                          }

                          return const UploadExpenseInvoiceReceipt();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowWidget({
    required BuildContext context,
    required String title,
    String? value,
    Widget? customValue,
  }) {
    return Row(
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
}
