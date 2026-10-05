import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/features/branch_manager_home/domain/entities/branch_manager_price_comparison_entity.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_export_price_comparison/branch_manager_export_price_comparison_cubit.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_export_price_comparison/branch_manager_export_price_comparison_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/selection_circule.dart';

class BranchManagerViewReportsExportPriceComparisonBottomSheet
    extends StatelessWidget {
  final String comparisonId;

  const BranchManagerViewReportsExportPriceComparisonBottomSheet({
    super.key,
    required this.comparisonId,
  });

  void _export(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    final exportCubit = context.read<BranchManagerExportPriceComparisonCubit>();

    final formatType = validationCubit.getTypedValue<String>('formatType');

    if (formatType == null) return;

    exportCubit.exportPriceComparison(
      comparisonId: comparisonId,
      formatType: formatType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export Price comparison data',
                      style: AppStyles.s20W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      'Choose your preferred file format and timeline to export this Price Comparison Data:',
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    20.verticalSpace,
                    Text(
                      'data Duration:',
                      style: AppStyles.s16W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    2.verticalSpace,
                    ContainerCustomTextField(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Last 3 months',
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Export Format',
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    5.verticalSpace,
                    Column(
                      spacing: 10.h,
                      children: List.generate(2, (index) {
                        final formats = ['PDF', 'Excel'];
                        final icons = [AppAssets.pdfSvg, AppAssets.excelSvg];

                        return AppGestureDetectorButton(
                          onTap: () {
                            context
                                .read<ValidationCubit>()
                                .validateFieldAndStoreTypedValue<String>(
                                  fieldName: 'formatType',
                                  value: formats[index],
                                  isValid: true,
                                );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 18.r,
                            ),
                            child: Row(
                              children: [
                                AppSvg(assetName: icons[index], width: 30.r),
                                10.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    formats[index],
                                    style: AppStyles.s14W500.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                ),
                                10.horizontalSpace,
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  bool
                                >(
                                  selector: (state) =>
                                      state.getTypedValue<String>(
                                        'formatType',
                                      ) ==
                                      formats[index],
                                  builder: (context, state) {
                                    return SelectionCircule(isSelected: state);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            BlocConsumer<
              BranchManagerExportPriceComparisonCubit,
              BranchManagerExportPriceComparisonState
            >(
              listener: (context, state) {
                if (state is BranchManagerExportPriceComparisonSuccess) {
                  NavigationService.I.pop();

                  getIt<DownloadService>().downloadFile(
                    url: state.fileUrl,
                    fileName: state.fileUrl.split('/').last,
                  );

                  AppSnackBar.showSuccess(
                    context,
                    'Exported successfully. Downloading file...',
                  );
                } else if (state is BranchManagerExportPriceComparisonFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                return state is BranchManagerExportPriceComparisonLoading
                    ? const AppButtonLoading()
                    : BlocSelector<ValidationCubit, ValidationState, bool>(
                        selector: (state) {
                          return state.fieldsValidity['formatType'] == true;
                        },
                        builder: (context, isValid) {
                          return AppButton(
                            onClick: () => _export(context),
                            enabled: isValid,
                            text: 'Export Data',
                          );
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
