import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/widgets.dart';

import '../../data/models/custody_request_details_response.dart';

class CustodyRequestDetailsScreenApprovalView extends StatelessWidget {
  final CustodyRequestDetailsApproval? approval;

  const CustodyRequestDetailsScreenApprovalView({super.key, this.approval});

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
          if (approval != null)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: context.customColor.reversedTextColor,
              ),
              padding: EdgeInsets.all(12.r),
              margin: EdgeInsets.only(bottom: 12.r),
              child: Row(
                children: [
                  ProfileImageWidget(image: approval?.profileImage),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          approval?.approvedBy ?? '-',
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          approval?.status.getLabel(context) ?? '-',
                          style: AppStyles.s12W400.copyWith(
                            color: approval?.status.getLabelColor(context),
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
    );
  }
}
