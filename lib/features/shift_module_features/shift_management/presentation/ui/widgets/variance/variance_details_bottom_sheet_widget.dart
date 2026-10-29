import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/utils/currency_normalizer.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/approve_responibility_sheet_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/variance_details.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/variance/variance_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/shift_row_title_and_amount.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/variance/show_variance_info_description_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/variance/variance_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/di/dependency_injection.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_asset_image.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../../core/widgets/label_text_field.dart';
import '../../../../../../branch_manager_requests/presentation/cubit/approve_or_reject_responsibility/approve_or_reject_responsibility_cubit.dart';
import '../../../../../../branch_manager_requests/presentation/cubit/get_responsibility_details/get_responsibility_details_cubit.dart';
import '../../../../../../branch_manager_requests/presentation/widgets/reject_responsibility_sheet_widget.dart';
import '../network_images_variance_widgets/variance_network_images_factory.dart';

class VarianceDetailsBottomSheetWidget extends StatefulWidget {
  const VarianceDetailsBottomSheetWidget({
    super.key,
    required this.handoverAmount,
    required this.varianceAmount,
    required this.shiftId,
    this.showButtons = false,
    this.successFunction,
    this.isResponsibilityRejected = false,
  });
  final String shiftId;
  final double handoverAmount;
  final num varianceAmount;
  final bool? showButtons;
  final bool isResponsibilityRejected;
  final Function()? successFunction;

  @override
  State<VarianceDetailsBottomSheetWidget> createState() =>
      _VarianceDetailsBottomSheetWidgetState();
}

class _VarianceDetailsBottomSheetWidgetState
    extends State<VarianceDetailsBottomSheetWidget> {
  @override
  void initState() {
    super.initState();
    context.read<VarianceCubit>().getVarianceDetails(widget.shiftId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VarianceCubit, VarianceState>(
      builder: (context, state) {
        if (state is VarianceLoading) {
          return const Center(child: AppLoadingWidget());
        } else if (state is VarianceError) {
          return Center(child: AppFailureWidget(failure: state.failure));
        } else if (state is VarianceLoaded) {
          final data = state.data;

          if (data == null) {
            return Center(
              child: Text(
                'No variance details available',
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppAssetImage(image: AppAssets.darkLogo, width: 57.w),
                        20.verticalSpace,
                        Text(
                          context.tr.varianceDetails,
                          style: AppStyles.s20W600.copyWith(
                            color: context.theme.primaryColor,
                          ),
                        ),
                        20.verticalSpace,
                        Text(
                          context.tr.anExplanationForVariance,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),

                        16.verticalSpace,
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: context.customColor.border,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            children: [
                              Text(
                                context.tr.varianceBreakdown,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              14.verticalSpace,
                              const CustomDivider(),
                              14.verticalSpace,
                              ShiftRowTitleAndAmount(
                                amount: 100.toString(),
                                title: context.tr.totalSales,
                              ),
                              14.verticalSpace,
                              const CustomDivider(),
                              14.verticalSpace,
                              ShiftRowTitleAndAmount(
                                amount: CurrencyNormalizer.formatSar(widget.handoverAmount),
                                title: context.tr.cashHandover,
                              ),
                              14.verticalSpace,
                              const CustomDivider(),
                              14.verticalSpace,
                              ShiftRowTitleAndAmount(
                                amount: CurrencyNormalizer.formatSar(widget.varianceAmount),
                                title: context.tr.varianceAmount,
                              ),
                              14.verticalSpace,
                              const CustomDivider(),
                              14.verticalSpace,
                              ShiftRowTitleAndAmount(
                                title: context.tr.varianceType,
                                showCurrencySymbol: false,
                                widget: VarianceTypeWidget(
                                  label: data.varianceType == VarianceType.over
                                      ? context.tr.over
                                      : context.tr.short,
                                  assetName:
                                      data.varianceType == VarianceType.over
                                      ? AppAssets.over
                                      : AppAssets.short,
                                ),
                              ),
                              14.verticalSpace,
                              const CustomDivider(),
                              14.verticalSpace,
                              const ShowVarianceInfoDescriptionWidget(),
                            ],
                          ),
                        ),
                        20.verticalSpace,
                        LabelTextField(text: context.tr.whatTheCauseOfVariance),
                        8.verticalSpace,

                        VarianceNetworkImagesFactory.create(
                          data.responsibilityType,
                          otherCashiers: data.otherCashiers,
                          reason: data.reason,
                          supportingFiles: data.supportingFiles,
                        ).buildUI(context),
                      ],
                    ),
                  ),
                ),
              ),

              if (widget.showButtons ?? false)
                widget.isResponsibilityRejected
                    ? ChangeYourMindButtonWidget(widget: widget)
                    : RejectAndApproveButtonsWidget(widget: widget),
            ],
          );
        }

        return const SizedBox.expand();
      },
    );
  }
}

class RejectAndApproveButtonsWidget extends StatelessWidget {
  const RejectAndApproveButtonsWidget({super.key, required this.widget});

  final VarianceDetailsBottomSheetWidget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 20.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        boxShadow: [
          BoxShadow(
            color: context.customColor.border,
            blurRadius: 10.r,
            offset: const Offset(0, -10),
            spreadRadius: 0.r,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              onClick: () {
                AppBottomSheet.showModal(
                  context,
                  (sheetContext) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (sheetContext) =>
                            getIt<ApproveOrRejectResponsibilityCubit>(),
                      ),

                      BlocProvider(
                        create: (sheetContext) =>
                            getIt<GetResponsibilityDetailsCubit>(),
                      ),
                    ],

                    child: RejectResponsibilitySheetWidget(
                      shiftId: widget.shiftId,
                      successFunction: widget.successFunction ?? () {},
                    ),
                  ),
                  isScrollControlled: true,
                );
              },
              textColor: context.customColor.error,
              borderColor: context.customColor.border,
              isTransparent: true,
              enabled: true,
              borderRadius: BorderRadius.circular(12.r),
              text: context.tr.reject,
            ),
          ),

          12.horizontalSpace,
          Expanded(
            child: AppButton(
              onClick: () {
                AppBottomSheet.showModal(
                  context,
                  (sheetContext) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (sheetContext) =>
                            getIt<ApproveOrRejectResponsibilityCubit>(),
                      ),

                      BlocProvider(
                        create: (sheetContext) =>
                            getIt<GetResponsibilityDetailsCubit>(),
                      ),
                    ],

                    child: ApproveResponsibilitySheetWidget(
                      shiftId: widget.shiftId,
                      successFunction: widget.successFunction ?? () {},
                    ),
                  ),
                  isScrollControlled: true,
                );
              },
              textColor: context.customColor.reversedTextColor,
              enabled: true,
              borderRadius: BorderRadius.circular(12.r),
              text: context.tr.approve,
            ),
          ),
        ],
      ),
    );
  }
}

class ChangeYourMindButtonWidget extends StatelessWidget {
  const ChangeYourMindButtonWidget({super.key, required this.widget});

  final VarianceDetailsBottomSheetWidget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 20.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        boxShadow: [
          BoxShadow(
            color: context.customColor.border,
            blurRadius: 10.r,
            offset: const Offset(0, -10),
            spreadRadius: 0.r,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.tr.changeYourMind,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
          5.verticalSpace,
          Text(
            context.tr.youPreviouslyRejectedThisVariance,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),

          10.verticalSpace,

          AppButton(
            onClick: () {
              AppBottomSheet.showModal(
                context,
                (sheetContext) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (sheetContext) =>
                          getIt<ApproveOrRejectResponsibilityCubit>(),
                    ),

                    BlocProvider(
                      create: (sheetContext) =>
                          getIt<GetResponsibilityDetailsCubit>(),
                    ),
                  ],

                  child: ApproveResponsibilitySheetWidget(
                    shiftId: widget.shiftId,
                    successFunction: widget.successFunction ?? () {},
                  ),
                ),
                isScrollControlled: true,
              );
            },
            enabled: true,
            borderRadius: BorderRadius.circular(12.r),
            text: context.tr.approve,
          ),
        ],
      ),
    );
  }
}
