import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/choose_item/choose_item_state.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/enums/purchase_sources_types.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/profile_image_widget.dart';
import '../../data/models/purchase_branch_items_response.dart';
import '../../data/models/purchase_branches_response.dart';

class ChooseBranchListViewWidget extends StatelessWidget {
  final PurchaseBranchData branch;
  final PurchaseBranchItemData item;
  final int quantity;
  final int selectedIndex;
  final String sourceTypeFieldName;
  final String sourceIdFieldName;
  final String sourceNameFieldName;
  final String choosedSourceItemIdFieldName;

  const ChooseBranchListViewWidget({
    super.key,
    required this.branch,
    required this.item,
    required this.quantity,
    required this.selectedIndex,
    required this.sourceTypeFieldName,
    required this.sourceIdFieldName,
    required this.sourceNameFieldName,
    required this.choosedSourceItemIdFieldName,
  });

  String _getPercentageText(double percentage) {
    String text = 'Fast';

    if (percentage >= 75) {
      text = 'Fast';
    } else if (percentage >= 50) {
      text = 'Normal';
    } else if (percentage >= 25) {
      text = 'Slow';
    }

    return text;
  }

  int _calculateStars(double rate) {
    int length = rate.toInt();

    if (length < rate) {
      length += 1;
    }

    return length;
  }

  bool _isHalfStar(double rate) {
    int length = rate.toInt();
    return rate - length > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(bottom: 12.r),
      child: Column(
        children: [
          Row(
            children: [
              ProfileImageWidget(image: branch.branch.image),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.branch.name,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${context.tr.manager}:',
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                        4.horizontalSpace,
                        Text(
                          branch.branchManager.name,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              10.horizontalSpace,
              BlocSelector<ChooseItemCubit, ChooseItemState, bool>(
                selector: (state) => state.selectedIndex == selectedIndex,
                builder: (context, state) {
                  return SelectionCircule(isSelected: state);
                },
              ),
            ],
          ),
          16.verticalSpace,
          PurchaseItemPreviewWidget(
            itemName: item.itemTitle,
            itemQuantity: quantity,
            itemPrice: item.itemPrice,
            itemImage: item.itemLogo,
            itemUnit: item.itemUnit,
          ),
          8.verticalSpace,
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: context.customColor.border),
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
            child: Row(
              children: [
                Text(
                  context.tr.availableInBranch,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${branch.availableQuantity} ${item.itemUnit}',
                    textAlign: TextAlign.end,
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                5.horizontalSpace,
                AppSvg(assetName: AppAssets.check, width: 10.w),
              ],
            ),
          ),
          8.verticalSpace,
          Text(
            context.tr.storeDetails,
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: context.customColor.border),
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
            child: Column(
              children: [
                _buildStoreDetailRow(
                  context: context,
                  label: context.tr.distance,
                  value:
                      '${branch.distance.distanceKm} ${context.tr.km} (${branch.distance.estimatedHours} ${context.tr.hours})',
                ),
                12.verticalSpace,
                _buildStoreDetailRow(
                  context: context,
                  label: context.tr.responseRate,
                  value:
                      '${branch.availabilityPercentage}% ${_getPercentageText(branch.availabilityPercentage.toDouble())}',
                ),
                12.verticalSpace,
                _buildStoreDetailRow(
                  context: context,
                  label: context.tr.lastUpdate,
                  value: DateFormatter.timeAgo(
                    DateTime.tryParse(branch.lastUpdate),
                  ),
                ),
                12.verticalSpace,
                _buildStoreDetailRow(
                  context: context,
                  label: context.tr.rating,
                  customValue: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      _calculateStars(branch.rating?.toDouble() ?? 0),
                      (index) {
                        final length = _calculateStars(
                          branch.rating?.toDouble() ?? 0,
                        );

                        return Row(
                          children: [
                            5.horizontalSpace,
                            AppSvg(
                              assetName:
                                  (_isHalfStar(
                                        branch.rating?.toDouble() ?? 0,
                                      ) &&
                                      index == length - 1)
                                  ? AppAssets.halfStar
                                  : AppAssets.star,
                              width: 20.w,
                              height: 20.w,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          8.verticalSpace,
          AppButton(
            onClick: () {
              context.read<ChooseItemCubit>().selectItem(selectedIndex);

              context.read<ValidationCubit>().validateFieldAndStoreValue(
                fieldName: sourceTypeFieldName,
                value: PurchaseSourcesTypes.branch.toString(),
                isValid: true,
              );

              context.read<ValidationCubit>().validateFieldAndStoreValue(
                fieldName: sourceIdFieldName,
                value: branch.branchId,
                isValid: true,
              );

              context.read<ValidationCubit>().validateFieldAndStoreValue(
                fieldName: choosedSourceItemIdFieldName,
                value: branch.itemId,
                isValid: true,
              );

              context.read<ValidationCubit>().validateFieldAndStoreValue(
                fieldName: sourceNameFieldName,
                value: branch.branch.name,
                isValid: true,
              );

              NavigationService.I.pop();
            },
            enabled: true,
            text: context.tr.selectThisStore,
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDetailRow({
    required BuildContext context,
    required String label,
    String? value,
    Widget? customValue,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        Expanded(
          child:
              customValue ??
              Text(
                value!,
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
