import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/variance_details/variance_other_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/network_images_variance_widgets/variance_network_images_factory.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../../data/model/cashier_model.dart';
import '../../../../domain/entity/cashier_entity.dart';
import '../../../../domain/entity/network_image_item.dart';
import '../add_cashier/details_summarize_widget.dart';
import '../variance/selected_responsible_employee_widget.dart';
import '../variance/variance_network_images_preiview_widget.dart';

class IWasResponsibleVarianceNetworkImageStrategyUi
    extends VarianceNetworkImagesUiStrategy {
  @override
  Widget buildUI(BuildContext context) {
    return Column(
      children: [
        10.verticalSpace,
        SummarizeCardWidget(
          height: 160.h,
          children: [
            Row(
              children: [
                AppSvg(
                  assetName: AppAssets.personSvg,
                  width: 15.h,
                  height: 15.h,
                ),
                5.horizontalSpace,
                Text(
                  context.tr.varianceBreakdown,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),

            const CustomDivider(),

            Text(context.tr.iWasResponsible, style: AppStyles.s13W500),

            Text(
              context.tr.iWasResponsibleDesc,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MeAndOrOtherVarianceNetworkImageStrategyUi
    extends VarianceNetworkImagesUiStrategy {
  final List<VarianceOtherCashierEntity> otherCashiers;

  MeAndOrOtherVarianceNetworkImageStrategyUi({required this.otherCashiers});

  @override
  Widget buildUI(BuildContext context) {
    return Column(
      children: [
        10.verticalSpace,
        SummarizeCardWidget(
          height: 160.h,
          children: [
            Row(
              children: [
                AppSvg(
                  assetName: AppAssets.personSvg,
                  width: 15.h,
                  height: 15.h,
                ),
                5.horizontalSpace,
                Text(
                  context.tr.varianceBreakdown,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),

            const CustomDivider(),

            Text(context.tr.meAndOrOtherEmployees, style: AppStyles.s13W500),

            Text(
              context.tr.meAndOrOtherEmployeesDesc,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
        ),

        10.verticalSpace,
        if (otherCashiers.isNotEmpty ?? false) ...[
          SizedBox(
            width: double.maxFinite,
            child: Text(
              context.tr.countEmployeesSelected(otherCashiers.length),
              style: AppStyles.s14W500,
            ),
          ),

          10.verticalSpace,

          SummarizeCardWidget(
            children: [
              Column(
                children: List.generate(otherCashiers.length, (index) {
                  final cashier = otherCashiers[index];

                  return SelectedResponsibleEmployeeWidget(
                    index: index,
                    cashier: CashierEntity(
                      id: cashier.cashierId,
                      name: cashier.cashierName,
                      email: '',
                      phone: '',
                      branch: BranchEntity(id: '', name: ''),
                      status: CashierStatus.active,
                      shiftsCount: 1,
                    ),
                    varianceAmount: cashier.amount,
                    removeIcon: false,
                    length: otherCashiers.length,
                  );
                }),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class OtherFactorVarianceNetworkImageStrategyUi
    extends VarianceNetworkImagesUiStrategy {
  final List<VarianceOtherCashierEntity> otherCashiers;
  final String? reason;
  final List<String> supportingFiles;

  OtherFactorVarianceNetworkImageStrategyUi({
    required this.otherCashiers,
    required this.reason,
    required this.supportingFiles,
  });

  @override
  Widget buildUI(BuildContext context) {
    return Column(
      children: [
        10.verticalSpace,
        SummarizeCardWidget(
          height: 160.h,
          children: [
            Row(
              children: [
                AppSvg(
                  assetName: AppAssets.personSvg,
                  width: 15.h,
                  height: 15.h,
                ),
                5.horizontalSpace,
                Text(
                  context.tr.varianceBreakdown,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),

            const CustomDivider(),

            Text(context.tr.otherFactor, style: AppStyles.s13W500),

            Text(
              context.tr.otherFactorDesc,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
        ),

        if (reason?.isNotEmpty ?? false) ...[
          10.verticalSpace,
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),

            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: context.customColor.border, width: 1.w),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr.additionalNote, style: AppStyles.s14W500),

                15.verticalSpace,
                Text(reason!, style: AppStyles.s13W400),
              ],
            ),
          ),
        ],

        if (supportingFiles.isNotEmpty ?? false) ...[
          10.verticalSpace,
          SizedBox(
            width: double.maxFinite,
            child: Text(context.tr.attachments, style: AppStyles.s14W500),
          ),
          5.verticalSpace,
          VarianceNetworkImagesPreviewWidget(
            images: supportingFiles
                .map((e) => NetworkImageItem(url: e, name: e.split('/').last))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class MixedFactorVarianceNetworkImageStrategyUi
    extends VarianceNetworkImagesUiStrategy {
  final List<VarianceOtherCashierEntity> otherCashiers;
  final String? reason;
  final List<String> supportingFiles;

  MixedFactorVarianceNetworkImageStrategyUi({
    required this.otherCashiers,
    required this.reason,
    required this.supportingFiles,
  });

  @override
  Widget buildUI(BuildContext context) {
    return Column(
      children: [
        10.verticalSpace,
        SummarizeCardWidget(
          height: 160.h,
          children: [
            Row(
              children: [
                AppSvg(
                  assetName: AppAssets.personSvg,
                  width: 15.h,
                  height: 15.h,
                ),
                5.horizontalSpace,
                Text(
                  context.tr.varianceBreakdown,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),

            const CustomDivider(),

            Text(context.tr.mixeFactors, style: AppStyles.s13W500),

            Text(
              context.tr.mixedFactorsDesc,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
        ),

        10.verticalSpace,
        if (otherCashiers.isNotEmpty) ...[
          SizedBox(
            width: double.maxFinite,
            child: Text(
              context.tr.countEmployeesSelected(otherCashiers.length),
              style: AppStyles.s14W500,
            ),
          ),

          10.verticalSpace,

          SummarizeCardWidget(
            children: [
              Column(
                children: List.generate(otherCashiers.length, (index) {
                  final cashier = otherCashiers[index];

                  return SelectedResponsibleEmployeeWidget(
                    index: index,
                    cashier: CashierEntity(
                      id: cashier.cashierId,
                      name: cashier.cashierName,
                      email: '',
                      phone: '',
                      branch: BranchEntity(id: '', name: ''),
                      status: CashierStatus.active,
                      shiftsCount: 1,
                    ),
                    varianceAmount: cashier.amount,
                    removeIcon: false,
                    length: otherCashiers.length,
                  );
                }),
              ),
            ],
          ),
        ],

        if (reason?.isNotEmpty ?? false) ...[
          10.verticalSpace,
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),

            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: context.customColor.border, width: 1.w),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr.additionalNote, style: AppStyles.s14W500),

                15.verticalSpace,
                Text(reason!, style: AppStyles.s13W400),
              ],
            ),
          ),
        ],

        if (supportingFiles.isNotEmpty ?? false) ...[
          10.verticalSpace,
          SizedBox(
            width: double.maxFinite,
            child: Text(context.tr.attachments, style: AppStyles.s14W500),
          ),
          5.verticalSpace,
          VarianceNetworkImagesPreviewWidget(
            images: supportingFiles
                .map((e) => NetworkImageItem(url: e, name: e.split('/').last))
                .toList(),
          ),
        ],
      ],
    );
  }
}
