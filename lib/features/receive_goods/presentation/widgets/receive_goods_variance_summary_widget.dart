import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/choose_item/choose_item_state.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../data/models/receive_goods_local_item_model.dart';
import '../../domain/strategies/variance_required_actions_strategy.dart';

class ReceiveGoodsVarianceSummaryWidget extends StatelessWidget {
  const ReceiveGoodsVarianceSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => getIt<ChooseItemCubit>())],
      child: const _ReceiveGoodsVarianceSummaryWidget(),
    );
  }
}

class _ReceiveGoodsVarianceSummaryWidget extends StatefulWidget {
  const _ReceiveGoodsVarianceSummaryWidget();

  @override
  State<_ReceiveGoodsVarianceSummaryWidget> createState() =>
      _ReceiveGoodsVarianceSummaryWidgetState();
}

class _ReceiveGoodsVarianceSummaryWidgetState
    extends State<_ReceiveGoodsVarianceSummaryWidget> {
  late final ValidationCubit _validationCubit;
  @override
  void initState() {
    super.initState();

    _validationCubit = context.read<ValidationCubit>();

    _validationCubit.addDynamicFields({'varianceRequiredAction'});
  }

  @override
  void dispose() {
    _validationCubit.removeDynamicFields({'varianceRequiredAction'});
    super.dispose();
  }

  final List<VarianceRequiredActionsStrategy> _varianceOptions = [
    AcceptAsIsVarianceRequiredActionsStrategy(),
    CreateCompensatoryOrderVarianceRequiredActionsStrategy(),
    DeductFromInvoiceValueVarianceRequiredActionsStrategy(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ValidationCubit,
      ValidationState,
      List<ReceiveGoodsLocalItemModel>
    >(
      selector: (state) {
        return state.getListValue<ReceiveGoodsLocalItemModel>(
              'receiveGoodsItems',
            ) ??
            [];
      },
      builder: (context, items) {
        // Filter only items with variance
        final varianceItems = items.where((item) => item.isVariance).toList();

        return Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
          child: CustomScrollView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              Row(
                children: [
                  AppSvg(
                    assetName: AppAssets.warning,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      context.customColor.error,
                      BlendMode.srcIn,
                    ),
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.tr.varianceSummary,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                ],
              ).sliverBoxAdapter,
              8.verticalSpace.sliverBoxAdapter,
              SliverList.builder(
                itemCount: varianceItems.length,
                itemBuilder: (context, index) {
                  final item = varianceItems[index];
                  final variance = item.qtyOrdered - item.qtyReceived;
                  final unitText = item.unit;

                  return Container(
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.all(12.r),
                    margin: EdgeInsets.only(bottom: 8.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.productName}:',
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        4.verticalSpace,
                        Row(
                          children: [
                            5.horizontalSpace,
                            Icon(
                              Icons.circle,
                              size: 3.r,
                              color: context.customColor.text3,
                            ),
                            5.horizontalSpace,
                            Text(
                              context.tr.shortQuantityValue(
                                variance.toString(),
                                unitText,
                                (variance * item.unitPrice).toString(),
                              ),
                              style: AppStyles.s13W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              2.verticalSpace.sliverBoxAdapter,
              Container(
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.all(12.r),
                child: Column(
                  children: [
                    LabelTextField(text: context.tr.requiredAction),
                    ListView.separated(
                      itemCount: _varianceOptions.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) => 10.verticalSpace,
                      itemBuilder: (context, index) {
                        return AppGestureDetectorButton(
                          onTap: () {
                            context.read<ChooseItemCubit>().selectItem(index);
                            _validationCubit.validateFieldAndStoreValue(
                              fieldName: 'varianceRequiredAction',
                              value: _varianceOptions[index].value,
                              isValid: true,
                            );
                            _varianceOptions[index].addDynamicView(context);
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
                                  final option = _varianceOptions[index];

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: context.customColor.text2,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: context.customColor.border,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: context
                                                .customColor
                                                .reversedTextColor,
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? context.theme.primaryColor
                                                  : Colors.transparent,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12.r,
                                            horizontal: 16.r,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  option.actionLabel(context),
                                                  style: AppStyles.s14W500
                                                      .copyWith(
                                                        color: isSelected
                                                            ? context
                                                                  .theme
                                                                  .primaryColor
                                                            : context
                                                                  .customColor
                                                                  .text1,
                                                      ),
                                                ),
                                              ),
                                              8.horizontalSpace,
                                              SelectionCircule(
                                                isSelected: isSelected,
                                              ),
                                            ],
                                          ),
                                        ),
                                        _varianceOptions[index]
                                            .buildAmountDetailsWidget(
                                              context,
                                              isSelected,
                                            ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ).sliverBoxAdapter,
            ],
          ),
        );
      },
    );
  }
}
