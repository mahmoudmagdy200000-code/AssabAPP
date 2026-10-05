import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/dynamic_steps/dynamic_steps_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../branch_manager_requests/presentation/cubit/get_order_details/get_order_details_cubit.dart';
import '../../../branch_manager_requests/presentation/screens/request_details_screen.dart';
import '../../data/models/return_goods_details_response.dart';

class ItemReturnDetailsOriginalOrderInfoBottomSheetWidget
    extends StatelessWidget {
  const ItemReturnDetailsOriginalOrderInfoBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 15.r,
        child: BlocSelector<ValidationCubit, ValidationState, ReturnGoodsDetailsResponse?>(
          selector: (state) =>
              state.getTypedValue<ReturnGoodsDetailsResponse>('info'),
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.originalOrderInfo,
                          style: AppStyles.s20W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          context
                              .tr
                              .thisItemReturnRequestIsLinkedToAnOriginalClosed,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                        14.verticalSpace,
                        const CustomDivider(),
                        14.verticalSpace,
                        _buildText(context, context.tr.returnRequest),
                        12.verticalSpace,
                        _buildReturnRequestWidget(
                          context: context,
                          title: '${state?.data.returnNumber}',
                          date:
                              '${DateFormatter.formatDateMDY(state?.data.createdAt)} - ${DateFormatter.formatTimeHM(state?.data.createdAt)}',
                          details: state,
                        ),
                        12.verticalSpace,
                        _buildText(context, context.tr.originalOrder),
                        12.verticalSpace,
                        _buildOriginalOrderWidget(
                          context: context,
                          title:
                              '${state?.data.items.length} ${context.tr.itemsRequired}',
                          date:
                              '${DateFormatter.formatDateMDY(state?.data.createdAt)} - ${DateFormatter.formatTimeHM(state?.data.createdAt)}',
                          details: state,
                        ),
                      ],
                    ),
                  ),
                ),
                20.verticalSpace,
                ButtonTextIcon(
                  onTap: () {
                    NavigationService.I.push(
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => PagingCubit(totalSteps: 3),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  getIt<GetOrderDetailsCubit>(),
                            ),
                            BlocProvider(
                              create: (context) => DynamicStepsCubit(),
                            ),
                            BlocProvider(
                              create: (context) => ValidationCubit(
                                requiredFields: {'approval', 'timelines'},
                              ),
                            ),
                          ],
                          child: RequestDetailsScreen(
                            id: state?.data.purchaseOrder.id ?? '',
                            strategy: DirectSupplierPurchaseSourceStrategy(),
                          ),
                        ),
                      ),
                    );
                  },
                  label: context.tr.goToOriginalPruchaseOrderDetails,
                  reversed: true,
                  backgroundColor: context.theme.primaryColor,
                  textStyle: AppStyles.s14W500.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                  spaceBetweenTextAndIcon: 7.r,
                  icon: AppSvg(
                    assetName: AppAssets.arrowRight,
                    colorFilter: ColorFilter.mode(
                      context.customColor.reversedTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Text _buildText(BuildContext context, String text) {
    return Text(
      text,
      style: AppStyles.s14W600.copyWith(color: context.customColor.text3),
    );
  }

  Widget _buildReturnRequestWidget({
    required BuildContext context,
    required String title,
    required String date,
    required ReturnGoodsDetailsResponse? details,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.s13W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                4.verticalSpace,
                Row(
                  children: [
                    AppSvg(
                      assetName: AppAssets.returnsManagement,
                      width: 12.r,
                      colorFilter: ColorFilter.mode(
                        context.customColor.text3,
                        BlendMode.srcIn,
                      ),
                    ),
                    4.horizontalSpace,
                    Text(
                      context.tr.goodsReturns,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,
                Text(
                  date,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          details?.data.status.buildStatusWidget(context) ??
              const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildOriginalOrderWidget({
    required BuildContext context,
    required String title,
    required String date,
    required ReturnGoodsDetailsResponse? details,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.s13W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                4.verticalSpace,
                Row(
                  children: [
                    AppSvg(
                      assetName: AppAssets.returnsManagement,
                      width: 12.r,
                      colorFilter: ColorFilter.mode(
                        context.customColor.text3,
                        BlendMode.srcIn,
                      ),
                    ),
                    4.horizontalSpace,
                    Text(
                      context.tr.directSupplierOrder,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,
                Text(
                  date,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          details?.data.purchaseOrder.status.buildStatus(context) ??
              const SizedBox.shrink(),
        ],
      ),
    );
  }
}
