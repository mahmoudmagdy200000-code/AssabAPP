import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/features/brand_owner_requests/data/models/brand_owner_requests_models.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../screens/brand_owner_sales_transfer_details_screen.dart';
import '../cubits/brand_owner_requests_custody_sales_transfers_cubit.dart';

class BrandOwnerCustodySalesTransfersViewItemListWidget
    extends StatelessWidget {
  final Border? border;
  final double margin;
  final BrandOwnerSalesTransferItemModel request;

  const BrandOwnerCustodySalesTransfersViewItemListWidget({
    super.key,
    this.border,
    required this.margin,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () async {
        final salesTransfersCubit = context
            .read<BrandOwnerRequestsCustodySalesTransfersCubit>();

        await NavigationService.I.push(
          MaterialPageRoute(
            builder: (context) {
              return BrandOwnerSalesTransferDetailsScreen(
                requestId: request.id,
                userTypeStrategy: BrandOwnerUserStrategy(),
                onListRefresh: () {
                  salesTransfersCubit
                      .getBrandOwnerRequestsCustodySalesTransfersView();
                },
              );
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(20.r),
          border: border,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
        margin: EdgeInsets.only(bottom: margin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSvg(
              assetName: AppAssets.custody,
              width: 20.r,
              height: 20.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text3,
                BlendMode.srcIn,
              ),
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.tr.cashSalesTransfer,
                          softWrap: true,
                          style: AppStyles.s12W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                      SaudiRiyalSvgWidget(color: context.customColor.text3),
                      3.horizontalSpace,
                      Text(
                        request.amount.toStringAsFixed(2),
                        style: AppStyles.s12WB.copyWith(
                          color: AppColors.lightGreen,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    request.submittedBy,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${DateFormatter.formatDateMDY(DateTime.tryParse(request.dateTime))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(request.dateTime))}',
                          style: AppStyles.s10W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      Text(
                        request.status.getLabel(context),
                        style: AppStyles.s10W500.copyWith(
                          color: request.status.getLabelColor(context),
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
    );
  }
}
