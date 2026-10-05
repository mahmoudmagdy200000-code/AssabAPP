import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/edit_and_resubmit_button.dart';
import '../../../../core/widgets/rejected_widget.dart';

class CustodyHandoverCashierDetailsScreenDetailsView extends StatelessWidget {
  const CustodyHandoverCashierDetailsScreenDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RejectedWidget(),
                14.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.tr.requestSummary,
                              style: AppStyles.s16W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          Text(
                            context.tr.pending,
                            style: AppStyles.s12W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildDetailRow(
                        context,
                        context.tr.recipient,
                        'Owner/Full Name',
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildDetailRow(
                        context,
                        context.tr.handoverAmount,
                        '20,000',
                        isCurrency: true,
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildDetailRow(
                        context,
                        context.tr.handoverMethod,
                        'Cash',
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildDetailRow(
                        context,
                        context.tr.handoverDate,
                        'June 6,2025 - 11:48 AM',
                      ),
                      8.verticalSpace,
                    ],
                  ),
                ),
                14.verticalSpace,
                Text(
                  context.tr.additionalNotes,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                4.verticalSpace,
                ContainerCustomTextField(
                  child: Text(
                    'Lorem ipsum dolor sit amet consectetur. Sit id viverra neque tortor vitae facilisis nulla volutpat id. Dis volutpat imperdiet diam in.',
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        const EditAndResubmitButton(),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isCurrency = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        if (isCurrency) const SaudiRiyalSvgWidget(),
        5.horizontalSpace,
        Text(
          value,
          style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
