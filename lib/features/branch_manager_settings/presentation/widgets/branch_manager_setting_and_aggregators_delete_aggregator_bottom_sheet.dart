import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../domain/entities/branch_manager_setting_and_aggregators_entity.dart';
import '../cubits/branch_manager_setting_and_aggregators_cubit.dart';

class BranchManagerSettingAndAggregatorsDeleteAggregatorBottomSheet
    extends StatelessWidget {
  final BranchManagerAggregatorEntity aggregator;

  const BranchManagerSettingAndAggregatorsDeleteAggregatorBottomSheet({
    super.key,
    required this.aggregator,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSvg(
                    assetName: AppAssets.trashSvg,
                    width: 24.r,
                    colorFilter: ColorFilter.mode(
                      context.customColor.error,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'Delete Aggregator?',
                    style: AppStyles.s20W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    'This will remove the aggregator from your active records. Cashiers won’t be able to use it unless re-added manually.',
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 80.h,
                        color: context.theme.primaryColor,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Note:',
                              style: AppStyles.s20W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            Text(
                              'Previous records linked to this aggregator will remain intact and unaffected.',
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  30.verticalSpace,
                  Row(
                    children: [
                      AppNetworkImage(
                        image: aggregator.logoUrl,
                        width: 35.r,
                        height: 35.r,
                        borderRadius: BorderRadius.zero,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Text(
                          aggregator.name,
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.cancel,
                    onTap: () {
                      NavigationService.I.pop();
                    },
                    textColor: context.customColor.text1,
                    backgroundColor: context.customColor.reversedTextColor,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.delete,
                    onTap: () {
                      context
                          .read<BranchManagerSettingAndAggregatorsCubit>()
                          .deleteAggregator(aggregatorId: aggregator.id);
                      NavigationService.I.pop();
                    },
                    textColor: context.customColor.reversedTextColor,
                    backgroundColor: context.customColor.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
