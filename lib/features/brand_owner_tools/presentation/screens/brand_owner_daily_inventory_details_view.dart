import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/network_file_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/profile_image_widget.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../inventory/domain/strategies/daily_inventory_status_strategy.dart';
import '../../data/models/brand_owner_daily_inventory_details_response.dart';
import '../cubit/brand_owner_daily_inventory_details/brand_owner_daily_inventory_details_cubit.dart';
import '../cubit/brand_owner_daily_inventory_details/brand_owner_daily_inventory_details_state.dart';
import '../cubit/brand_owner_daily_inventory_requests/brand_owner_daily_inventory_requests_cubit.dart';
import '../../../branch_manager_expenses/data/models/attachment_model.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../widgets/brand_owner_inventory_general_actions_bottom_sheet.dart';

class BrandOwnerDailyInventoryDetailsView extends StatelessWidget {
  final BrandOwnerDailyInventoryDetailsResponse details;

  const BrandOwnerDailyInventoryDetailsView({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSvg(
                            assetName: AppAssets.waste,
                            width: 20.w,
                            height: 20.h,
                            colorFilter: ColorFilter.mode(
                              context.customColor.text1,
                              BlendMode.srcIn,
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr.reportSummary,
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                                Text(
                                  context.tr.reportSubmittedForReview(
                                    details.branchName,
                                  ),
                                  style: AppStyles.s12W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          10.horizontalSpace,
                          AppIconButton(
                            icon: Icons.keyboard_arrow_up_outlined,
                            onPressed: () {},
                            iconColor: context.customColor.text1,
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: context.customColor.reversedTextColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${context.tr.executiveSummary}:',
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context,
                              context.tr.productsInventoried,
                              assetName: AppAssets.box,
                              value: details.summary.productsInventoried,
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context,
                              context.tr.productsWithDiscrepancies,
                              assetName: AppAssets.warning,
                              value: details.summary.productsWithDiscrepancies,
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context,
                              context.tr.matchingProducts,
                              assetName: AppAssets.receipt,
                              value: details.summary.matchingProducts,
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context,
                              context.tr.totalDiscrepancyValue,
                              assetName: AppAssets.expenseSvg,
                              value: details.summary.totalDiscrepancyValue,
                              isCurrency: true,
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context,
                              context.tr.discrepancyType,
                              assetName: AppAssets.box,
                              value: details.summary.discrepancyType,
                            ),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: context.customColor.reversedTextColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                AppNetworkImage(
                                  image: details.branchImageUrl,
                                  height: 110.h,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    color:
                                        context.customColor.reversedTextColor,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.r,
                                      vertical: 4.r,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppSvg(
                                          assetName: AppAssets.branchStoreSvg,
                                          colorFilter: ColorFilter.mode(
                                            context.customColor.text1,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        5.horizontalSpace,
                                        Flexible(
                                          child: Text(
                                            '${context.tr.opens}: ${details.branchOpenHours}',
                                            style: AppStyles.s12W400.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            10.verticalSpace,
                            ProfileImageWidget(
                              width: 160.r,
                              height: 160.r,
                              image: details.reporterImageUrl,
                            ),
                            10.verticalSpace,
                            Text(
                              details.reporterName,
                              style: AppStyles.s16W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            10.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1000.r),
                                    border: Border.all(
                                      color: context.customColor.border,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.r,
                                    vertical: 4.r,
                                  ),
                                  child: Row(
                                    children: [
                                      AppSvg(
                                        assetName: AppAssets.checkWithContainer,
                                        colorFilter: ColorFilter.mode(
                                          context.theme.primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        context.tr.brandManager,
                                        style: AppStyles.s12W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${context.tr.recordedItemDetails}:',
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      10.verticalSpace,
                      ListView.separated(
                        itemCount: details.items.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => 10.verticalSpace,
                        itemBuilder: (context, index) {
                          final item = details.items[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: context.customColor.reversedTextColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.all(12.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    PurchaseItemImage(image: item.imageUrl),
                                    10.horizontalSpace,
                                    Expanded(
                                      child: Text(
                                        item.productName,
                                        style: AppStyles.s14W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                10.verticalSpace,
                                const CustomDivider(),
                                10.verticalSpace,
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    context.tr.productInformation,
                                    style: AppStyles.s14W500.copyWith(
                                      color: context.customColor.text3,
                                    ),
                                  ),
                                ),
                                10.verticalSpace,
                                const CustomDivider(),
                                10.verticalSpace,
                                _buildRow(
                                  context,
                                  context.tr.expectedBalance,
                                  value: item.expectedBalance,
                                ),
                                10.verticalSpace,
                                const CustomDivider(),
                                10.verticalSpace,
                                _buildRow(
                                  context,
                                  context.tr.actualBalance,
                                  value: item.actualBalance,
                                ),
                                10.verticalSpace,
                                const CustomDivider(),
                                10.verticalSpace,
                                _buildRow(
                                  context,
                                  context.tr.difference,
                                  value: item.difference,
                                ),
                                if (item.justificationNote != null) ...[
                                  10.verticalSpace,
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: context.customColor.border,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(12.r),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.tr.justificationNote,
                                          style: AppStyles.s14W500.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                        5.verticalSpace,
                                        Text(
                                          item.justificationNote ?? '',
                                          style: AppStyles.s13W400.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                if (item.explanatoryPhotoUrl != null) ...[
                                  10.verticalSpace,
                                  Text(
                                    context.tr.explanatoryPhoto,
                                    style: AppStyles.s14W500.copyWith(
                                      color: context.customColor.text3,
                                    ),
                                  ),
                                  5.verticalSpace,
                                  NetworkFilePreviewWidget(
                                    attachmentModel: AttachmentModel(
                                      id: '',
                                      url: item.explanatoryPhotoUrl!,
                                      fileName:
                                          item.explanatoryPhotoName ?? '-',
                                      fileType: 'jpg',
                                      fileSize: 1024 * 1024 * 2,
                                      uploadedAt: DateTime.now()
                                          .toIso8601String(),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        10.verticalSpace,
        BlocListener<
          BrandOwnerDailyInventoryDetailsCubit,
          BrandOwnerDailyInventoryDetailsState
        >(
          listener: (context, state) {
            if (state is BrandOwnerDailyInventoryDetailsActionSuccess) {
              context.read<BrandOwnerDailyInventoryDetailsCubit>().load(
                requestId: details.id,
              );
              context.read<BrandOwnerDailyInventoryRequestsCubit>().load();
            } else if (state is BrandOwnerDailyInventoryDetailsActionFailure) {
              AppDialog.showErrorDialog(
                context: context,
                failure: state.failure,
              );
            }
          },
          child:
              BlocBuilder<
                BrandOwnerDailyInventoryDetailsCubit,
                BrandOwnerDailyInventoryDetailsState
              >(
                builder: (context, state) {
                  final canShowActions =
                      details.status is PendingDailyInventoryStatusStrategy;

                  if (!canShowActions) {
                    return const SizedBox.shrink();
                  }

                  if (state is BrandOwnerDailyInventoryDetailsActionLoading) {
                    return const AppButtonLoading();
                  }

                  return ButtonTextIcon(
                    label: context.tr.generalActionsAndLinks,
                    onTap: () {
                      final brandOwnerDailyInventoryDetailsCubit = context
                          .read<BrandOwnerDailyInventoryDetailsCubit>();

                      AppBottomSheet.showModal(
                        context,
                        isScrollControlled: true,
                        (
                          context,
                        ) => BrandOwnerInventoryGeneralActionsBottomSheet(
                          id: details.id,
                          approveDesc:
                              'You’re confirming all selected reports as valid items.\n\nEach item will be deducted from inventory and logged as a non-liability cost.',
                          rejectDesc:
                              'You’re rejecting this items.\nThe item will still be deducted from inventory, but its value will be recorded as a personal liability on the staff’s account.',
                          itemNames: details.items
                              .map((item) => item.productName)
                              .toList(),
                          itemsImages: details.items
                              .map((item) => item.imageUrl)
                              .toList(),
                          onApproveAll: () {
                            NavigationService.I.pop();

                            brandOwnerDailyInventoryDetailsCubit.approve(
                              requestId: details.id,
                            );
                          },
                          rejectAllOnTap: () {
                            NavigationService.I.pop();
                            brandOwnerDailyInventoryDetailsCubit.reject(
                              requestId: details.id,
                            );
                          },
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      color: context.customColor.reversedTextColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.r),
                    backgroundColor: context.theme.primaryColor,
                    borderRadius: BorderRadius.circular(15.r),
                    borderColor: Colors.transparent,
                    textColor: context.customColor.reversedTextColor,
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget _buildRow(
    BuildContext context,
    String title, {
    String? assetName,
    String? value,
    Widget? customValueWidget,
    bool isCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (assetName != null) ...[
                AppSvg(
                  assetName: assetName,
                  width: 15.r,
                  colorFilter: ColorFilter.mode(
                    context.customColor.text3,
                    BlendMode.srcIn,
                  ),
                ),
                5.horizontalSpace,
              ],
              Flexible(
                child: Text(
                  title,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ],
          ),
        ),
        5.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isCurrency) const SaudiRiyalSvgWidget(),
              Flexible(
                child:
                    customValueWidget ??
                    Text(
                      value ?? '-',
                      style: AppStyles.s13W500.copyWith(
                        color: context.customColor.text1,
                      ),
                      textAlign: TextAlign.end,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
