import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/widgets.dart';

import '../../data/models/brand_owner_requests_models.dart';

class BrandOwnerSalesTransferDetailsScreenApprovalView extends StatelessWidget {
  final List<BrandOwnerSalesTransferApproverModel> approvers;

  const BrandOwnerSalesTransferDetailsScreenApprovalView({
    super.key,
    required this.approvers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.customColor.text2,
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Text(
            'Your custody request requires approval from one of the following individuals. Only one approval is needed to proceed.',
            style: AppStyles.s14W400.copyWith(color: context.customColor.text4),
            textAlign: TextAlign.center,
          ),
          20.verticalSpace,
          ListView.builder(
            shrinkWrap: true,
            itemCount: approvers.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final approver = approvers[index];

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: context.customColor.reversedTextColor,
                ),
                padding: EdgeInsets.all(12.r),
                margin: EdgeInsets.only(bottom: 12.r),
                child: Row(
                  children: [
                    const ProfileImageWidget(),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            approver.name,
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          Text(
                            approver.role,
                            style: AppStyles.s12W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          Text(
                            approver.status.getLabel(context),
                            style: AppStyles.s12W400.copyWith(
                              color: approver.status.getLabelColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
