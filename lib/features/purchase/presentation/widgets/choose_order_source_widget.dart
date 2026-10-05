import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/enums/purchase_sources_types.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/selection_circule.dart';
import '../../data/models/purchase_branch_items_response.dart';
import '../cubit/compare_price/compare_price_cubit.dart';
import '../cubit/save_compare_price/save_compare_price_cubit.dart';
import '../cubit/save_compare_price/save_compare_price_state.dart';
import '../screens/compare_prices_screen.dart';

class ChooseOrderSourceWidget extends StatelessWidget {
  final String title;
  final String desc1;
  final String desc2;
  final String desc3;
  final String assetName;
  final VoidCallback onChoose;
  final PurchaseSourcesTypes sourceType;
  final String sourceTypeFieldName;
  final String itemId;
  final String sourceIdFieldName;
  final String sourceNameFieldName;
  final String choosedSourceItemIdFieldName;
  final PurchaseBranchItemData item;
  final int quantity;
  final String addedItemMainId;

  const ChooseOrderSourceWidget({
    super.key,
    required this.title,
    required this.desc1,
    required this.desc2,
    required this.desc3,
    required this.assetName,
    required this.onChoose,
    required this.sourceType,
    required this.sourceTypeFieldName,
    required this.itemId,
    required this.sourceIdFieldName,
    required this.sourceNameFieldName,
    required this.choosedSourceItemIdFieldName,
    required this.item,
    required this.quantity,
    required this.addedItemMainId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 16.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(assetName: assetName, width: 20.w, height: 20.w),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                _descRow(context, desc1),
                _descRow(context, desc2),
                _descRow(context, desc3),
                8.verticalSpace,
                AppButton(
                  onClick: onChoose,
                  enabled: true,
                  text: context.tr.chooseThisOption,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.r,
                    horizontal: 16.r,
                  ),
                  margin: EdgeInsets.only(top: 8.r),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSvg(
                        assetName: AppAssets.star,
                        width: 20.w,
                        height: 20.w,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.smartTip,
                              style: AppStyles.s14W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            8.verticalSpace,
                            Text(
                              context
                                  .tr
                                  .weSuggestOrderingThroughDirectSupplierForTheBestValue,
                              softWrap: true,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                            8.verticalSpace,
                            ButtonTextIcon(
                              onTap: () {
                                final validationCubit = context
                                    .read<ValidationCubit>();

                                NavigationService.I.push(
                                  MaterialPageRoute(
                                    builder: (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) =>
                                              getIt<ComparePriceCubit>(),
                                        ),
                                        BlocProvider(
                                          create: (context) =>
                                              getIt<SaveComparePriceCubit>(),
                                        ),
                                        BlocProvider.value(
                                          value: validationCubit,
                                        ),
                                      ],
                                      child: ComparePricesScreen(
                                        itemId: itemId,
                                        choosedSourceItemIdFieldName:
                                            choosedSourceItemIdFieldName,
                                        sourceIdFieldName: sourceIdFieldName,
                                        sourceNameFieldName:
                                            sourceNameFieldName,
                                        sourceTypeFieldName:
                                            sourceTypeFieldName,
                                        item: item,
                                        quantity: quantity,
                                        addedItemMainId: addedItemMainId,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              label: context.tr.comparePrices,
                              icon: AppSvg(
                                assetName: AppAssets.comparePrices,
                                width: 20.w,
                                height: 20.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          12.horizontalSpace,
          BlocSelector<ValidationCubit, ValidationState, bool>(
            selector: (state) =>
                state.fieldsValue[sourceTypeFieldName] == sourceType.toString(),
            builder: (context, state) {
              return SelectionCircule(isSelected: state);
            },
          ),
        ],
      ),
    );
  }

  Widget _descRow(BuildContext context, String text) {
    return Row(
      children: [
        Icon(Icons.circle, size: 4.r, color: context.customColor.text3),
        5.horizontalSpace,
        Text(
          text,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
      ],
    );
  }
}
