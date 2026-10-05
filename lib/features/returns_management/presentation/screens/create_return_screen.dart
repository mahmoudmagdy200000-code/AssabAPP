import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:assab/features/returns_management/presentation/cubit/create_return/create_return_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/enums/craete_return_requird_action_enum.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/strategies/requests_order_status_strategy.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../branch_manager_requests/data/models/direct_supplier_order_details_response.dart';
import '../../data/models/create_return_request.dart';
import '../cubit/create_return/create_return_cubit.dart';
import '../widgets/create_return_return_details_section_item_list_view.dart';
import 'return_success_screen.dart';

class CreateReturnScreen extends StatelessWidget {
  final DirectSupplierOrderDetailsResponse details;

  const CreateReturnScreen({super.key, required this.details});

  CreateReturnRequest _body(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    final items = details.productDetails
        .where((element) => element.status is CloseStatusStrategyImpl)
        .where(
          (item) => validationCubit
              .getFieldValue('return_quantity_${item.id}')
              .isNotEmpty,
        )
        .map((item) {
          final quantityStr = validationCubit.getFieldValue(
            'return_quantity_${item.id}',
          );
          final quantity = double.tryParse(quantityStr) ?? 0;
          final reason = validationCubit.getFieldValue(
            'reason_quality_${item.id}',
          );
          final files = validationCubit.getListValue<MediaFile>(
            'files_${item.id}',
          );

          return ReturnItem(
            purchaseOrderItemId: item.id,
            returnQuantity: quantity,
            qualityReason: reason,
            files: files?.map((e) => e.toFile).toList() ?? [],
          );
        })
        .toList();

    return CreateReturnRequest(
      purchaseOrderId: details.requestSummary.id,
      requiredAction: validationCubit.getFieldValue('requiredAction'),
      additionalNotes: validationCubit.getFieldValue('note'),
      items: items,
    );
  }

  Future<void> _createReturn(BuildContext context) async {
    await context.read<CreateReturnCubit>().createReturnRequest(
      body: _body(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.dark,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.createSupplierReturn,
            subtitle: context.tr.chooseItemsFromThisOrderDetailsToReturn,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: context.customColor.border,
                            ),
                          ),
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            children: [
                              _buildRowWidget(
                                context: context,
                                title: context.tr.supplier,
                                value: details.requestSummary.supplierName,
                              ),
                              8.verticalSpace,
                              const CustomDivider(),
                              8.verticalSpace,
                              _buildRowWidget(
                                context: context,
                                title: context.tr.relatedOrder,
                                value: details.requestSummary.orderNumber,
                              ),
                              8.verticalSpace,
                              const CustomDivider(),
                              8.verticalSpace,
                              _buildRowWidget(
                                context: context,
                                title: context.tr.returnDate,
                                value: DateFormatter.formatDateMDY(
                                  DateTime.now(),
                                ),
                              ),
                            ],
                          ),
                        ).sliverBoxAdapter,
                        12.verticalSpace.sliverBoxAdapter,
                        LabelTextField(
                          text: context.tr.returnDetails,
                        ).sliverBoxAdapter,
                        SliverList.builder(
                          itemCount: details.productDetails
                              .where(
                                (element) =>
                                    element.status is CloseStatusStrategyImpl,
                              )
                              .toList()
                              .length,
                          itemBuilder: (context, index) {
                            return CreateReturnReturnDetailsSectionItemListView(
                              item: details.productDetails[index],
                            );
                          },
                        ),
                        LabelTextField(
                          text: context.tr.requiredAction,
                        ).sliverBoxAdapter,
                        SliverList.separated(
                          itemCount: 3,
                          separatorBuilder: (context, index) =>
                              12.verticalSpace,
                          itemBuilder: (context, index) {
                            final action =
                                CraeteReturnRequirdActionEnum.values[index];

                            return AppGestureDetectorButton(
                              onTap: () {
                                context.read<ChooseItemCubit>().selectItem(
                                  index,
                                );

                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreValue(
                                      fieldName: 'requiredAction',
                                      value: action.value,
                                      isValid: true,
                                    );
                              },
                              child:
                                  BlocSelector<
                                    ChooseItemCubit,
                                    ChooseItemState,
                                    int?
                                  >(
                                    selector: (state) => state.selectedIndex,
                                    builder: (context, state) {
                                      final isSelected = state == index;

                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? context.theme.primaryColor
                                                : context.customColor.border,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.r,
                                          vertical: 12.r,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                action.displayName(context),
                                                style: AppStyles.s14W500
                                                    .copyWith(
                                                      color: isSelected
                                                          ? context
                                                                .theme
                                                                .primaryColor
                                                          : context
                                                                .customColor
                                                                .text4,
                                                    ),
                                              ),
                                            ),
                                            5.horizontalSpace,
                                            SelectionCircule(
                                              isSelected: isSelected,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                            );
                          },
                        ),
                        8.verticalSpace.sliverBoxAdapter,
                        ContainerCustomTextField(
                          label: context.tr.additionalNote,
                          isLabelOptional: true,
                          isLabelRequired: false,
                          child: CustomTextField(
                            hintText: context
                                .tr
                                .egDamagedDiscoveredDuringDetailedInspectionProductsDoNotMeet,
                            maxLines: 5,
                            onChanged: (value) {
                              context
                                  .read<ValidationCubit>()
                                  .validateFieldAndStoreValue(
                                    fieldName: 'note',
                                    value: value,
                                    isValid: value.isNotEmpty,
                                  );
                            },
                          ),
                        ).sliverBoxAdapter,
                      ],
                    ),
                  ),
                  20.verticalSpace,
                  BlocConsumer<CreateReturnCubit, CreateReturnState>(
                    listener: (context, state) {
                      if (state is CreateReturnSuccess) {
                        NavigationService.I.pop();

                        AppBottomSheet.customPageRoute(context, (context) {
                          return ReturnSuccessScreen(
                            supplierName: details.requestSummary.supplierName,
                          );
                        });
                      } else if (state is CreateReturnFailure) {
                        AppDialog.showErrorDialog(
                          context: context,
                          failure: state.failure,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CreateReturnLoading) {
                        return const AppButtonLoading();
                      }

                      return BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        bool
                      >(
                        selector: (state) {
                          return state.enableButton &&
                              details.productDetails.any(
                                (item) => state.fieldsValidity.keys.any(
                                  (key) => key.contains(item.id),
                                ),
                              );
                        },
                        builder: (context, state) {
                          return AppButton(
                            onClick: () async {
                              await _createReturn(context);
                            },
                            text: context.tr.sendReturnRequest,
                            enabled: state,
                            borderRadius: BorderRadius.circular(20.r),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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
