import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/enums/purchase_sources_types.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/purchase/presentation/cubit/create_purchase_order/create_purchase_order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../data/models/purchase_create_order_request.dart';
import '../../data/models/source_local_model.dart';
import '../../domain/strategies/create_order_strategy.dart';
import '../cubit/create_purchase_order/create_purchase_order_state.dart';
import '../widgets/purchase_app_bar.dart';

class NewPurchaseOrderSummaryScreen extends StatefulWidget {
  final List<SourceLocalModel> sources;
  final CreateOrderStrategy strategy;

  const NewPurchaseOrderSummaryScreen({
    super.key,
    required this.sources,
    required this.strategy,
  });

  @override
  State<NewPurchaseOrderSummaryScreen> createState() =>
      _NewPurchaseOrderSummaryScreenState();
}

class _NewPurchaseOrderSummaryScreenState
    extends State<NewPurchaseOrderSummaryScreen> {
  late final ValueNotifier<bool> _isEmergencyOrder;
  late final PurchaseCreateOrderRequest _createOrderRequest;

  @override
  void initState() {
    super.initState();

    _isEmergencyOrder = ValueNotifier(false);
    _createOrderRequest = PurchaseCreateOrderRequest();
  }

  @override
  void dispose() {
    _isEmergencyOrder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.newPurchaseOrder,
            subtitle: context.tr.chooseProductsOrderSources,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 20.r),
              child: Column(
                children: [
                  if (widget.sources.length == 1)
                    Expanded(
                      child:
                          PurchaseSourcesTypes.getStrategy(
                            widget.sources[0].type,
                          ).buildSummary(
                            context,
                            widget.sources[0],
                            _createOrderRequest,
                            0,
                          ),
                    )
                  else ...[
                    Text(
                      '${widget.sources.fold<int>(0, (sum, source) => sum + source.choosedItemSourceIds.length)} orders with ${widget.sources.length} Different sources',
                      style: AppStyles.s16W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    8.verticalSpace,
                    SizedBox(
                      height: 40.r,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: widget.sources.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return BlocSelector<PagingCubit, PagingState, bool>(
                            selector: (state) => state.currentIndex == index,
                            builder: (context, isSelected) {
                              return CustomTextButton(
                                text:
                                    '${widget.sources[index].sourceName} ${widget.sources[index].choosedItemSourceIds.length}',
                                borderRadius: 1000.r,
                                textColor: isSelected
                                    ? context.theme.primaryColor
                                    : context.customColor.text1,
                                borderColor: isSelected
                                    ? context.theme.primaryColor
                                    : context.customColor.border,
                                onTap: () {
                                  context.read<PagingCubit>().goToStep(index);
                                },
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            10.horizontalSpace,
                      ),
                    ),
                    12.verticalSpace,
                    const CustomDivider(),
                    12.verticalSpace,
                    BlocSelector<PagingCubit, PagingState, int>(
                      selector: (state) => state.currentIndex,
                      builder: (context, state) {
                        return Expanded(
                          child: IndexedStack(
                            index: state,
                            children: List.generate(widget.sources.length, (
                              index,
                            ) {
                              return PurchaseSourcesTypes.getStrategy(
                                widget.sources[index].type,
                              ).buildSummary(
                                context,
                                widget.sources[index],
                                _createOrderRequest,
                                index,
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ],
                  20.verticalSpace,
                  BlocBuilder<ValidationCubit, ValidationState>(
                    builder: (context, validationState) {
                      return BlocConsumer<
                        CreatePurchaseOrderCubit,
                        CreatePurchaseOrderState
                      >(
                        listener: (context, state) {
                          if (state is CreatePurchaseOrderSuccess) {
                            NavigationService.I.popToFirst();

                            NavigationService.I.pushNamed(
                              AppRouteName.createPurchaseOrderSuccessScreen,
                            );
                          } else if (state is CreatePurchaseOrderFailure) {
                            AppDialog.showErrorDialog(
                              context: context,
                              failure: state.failure,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is CreatePurchaseOrderLoading) {
                            return const AppButtonLoading();
                          }

                          return Column(
                            children: [
                              Row(
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: _isEmergencyOrder,
                                    builder: (context, value, child) {
                                      return AppCheckBox(
                                        onChanged: (value) {
                                          _isEmergencyOrder.value = value;

                                          _createOrderRequest
                                              .updateIsEmergencyOrder(value);
                                        },
                                        value: _isEmergencyOrder.value,
                                      );
                                    },
                                  ),
                                  8.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      context.tr.emergencyOrder,
                                      style: AppStyles.s14W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              20.verticalSpace,
                              widget.strategy.buildButtons(
                                context,
                                _createOrderRequest,
                              ),
                            ],
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
}
