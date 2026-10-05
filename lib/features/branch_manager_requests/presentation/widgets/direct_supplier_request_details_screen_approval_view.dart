import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../shared/models/supplier_details_response.dart';

class DirectSupplierRequestDetailsScreenApprovalView extends StatelessWidget {
  const DirectSupplierRequestDetailsScreenApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: SingleChildScrollView(
        child:
            BlocSelector<
              ValidationCubit,
              ValidationState,
              SupplierDetailsResponse?
            >(
              selector: (state) =>
                  state.getTypedValue<SupplierDetailsResponse>('approval'),
              builder: (context, supplier) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ProfileImageWidget(
                                  image: supplier?.image,
                                  width: 150.w,
                                  height: 150.w,
                                ),
                                Positioned(
                                  bottom: 0,
                                  child:
                                      supplier?.status.buildStatusWidget(
                                        context,
                                      ) ??
                                      const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          12.verticalSpace,
                          const CustomDivider(),
                          12.verticalSpace,
                          _buildRowDetails(
                            context: context,
                            assetName: AppAssets.personSvg,
                            title: '${context.tr.name}:',
                            value: supplier?.name ?? '',
                          ),
                          10.verticalSpace,
                          _buildRowDetails(
                            context: context,
                            icon: false,
                            title: context.tr.availableOn,
                            valueWidget: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                supplier?.contactMethods.length ?? 0,
                                (index) => Text(
                                  '${supplier?.contactMethods[index]} -',
                                  style: AppStyles.s13W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    4.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${context.tr.responseStatistics}:',
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          8.verticalSpace,
                          const CustomDivider(),
                          8.verticalSpace,
                          _buildRowDetails(
                            context: context,
                            icon: false,
                            title: '${context.tr.name}:',
                            value:
                                '${supplier?.averageResponseTimeHours ?? ''} ${context.tr.hours}',
                          ),
                          10.verticalSpace,
                          _buildRowDetails(
                            context: context,
                            icon: false,
                            title: '${context.tr.responseRate}:',
                            value: '${supplier?.responseRatePercentage ?? ''}%',
                          ),
                          16.verticalSpace,
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                            ),
                            padding: EdgeInsets.all(20.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr.whatsNext,
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                                6.verticalSpace,
                                _buildDotText(
                                  context: context,
                                  text: context.tr.expectResponseWithin,
                                ),
                                _buildDotText(
                                  context: context,
                                  text: context
                                      .tr
                                      .youllReceiveNotificationsForAnyUpdates,
                                ),
                                _buildDotText(
                                  context: context,
                                  text: context.tr.trackStatusFromMyOrders,
                                ),
                                _buildDotText(
                                  context: context,
                                  text:
                                      context.tr.automaticReminderIfNoResponse,
                                ),
                                _buildDotText(
                                  context: context,
                                  text: context.tr.within24Hours,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
      ),
    );
  }

  Widget _buildRowDetails({
    required BuildContext context,
    String? assetName,
    required String title,
    String? value,
    Widget? valueWidget,
    bool icon = true,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon) AppSvg(assetName: assetName ?? '', width: 16.r, height: 16.r),
        if (icon) 5.horizontalSpace,
        Text(
          title,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        5.horizontalSpace,
        Expanded(
          child:
              valueWidget ??
              Text(
                value ?? '',
                textAlign: TextAlign.end,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildDotText({required BuildContext context, required String text}) {
    return Row(
      children: [
        Icon(Icons.circle, size: 3.r, color: context.customColor.text3),
        5.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
      ],
    );
  }
}
