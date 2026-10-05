import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../domain/enums/brand_owner_expense_report_type.dart';
import '../cubit/export_expense_report_cubit.dart';
import '../cubit/export_expense_report_state.dart';

class BrandOwnerExportExpenseReportBottomSheet extends StatelessWidget {
  final VoidCallback? onExportSuccess;

  const BrandOwnerExportExpenseReportBottomSheet({super.key, this.onExportSuccess});

  void _selectType(BuildContext context, BrandOwnerExpenseReportType type) {
    context
        .read<ValidationCubit>()
        .validateFieldAndStoreTypedValue<BrandOwnerExpenseReportType>(
          fieldName: 'expenseType',
          value: type,
          isValid: true,
        );
  }

  void _selectMonth(BuildContext context, int month) {
    context.read<ValidationCubit>().validateFieldAndStoreTypedValue<int>(
      fieldName: 'monthNumber',
      value: month,
      isValid: true,
    );
  }

  void _selectYear(BuildContext context, int year) {
    context.read<ValidationCubit>().validateFieldAndStoreTypedValue<int>(
      fieldName: 'year',
      value: year,
      isValid: true,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Export Expense Report',
                    style: AppStyles.s20W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    'Choose your preferred file format and timeline to export expense analytics & Report:',
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  Text(
                    'Expense Type',
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  5.verticalSpace,
                  Row(
                    spacing: 10.w,
                    children: List.generate(2, (index) {
                      final texts = [
                        context.tr.quickCashExpense,
                        context.tr.invoice,
                      ];

                      final values = [
                        BrandOwnerExpenseReportType.quickCash,
                        BrandOwnerExpenseReportType.invoice,
                      ];

                      return Expanded(
                        child:
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              BrandOwnerExpenseReportType?
                            >(
                              selector: (state) => state
                                  .getTypedValue<BrandOwnerExpenseReportType>(
                                    'expenseType',
                                  ),
                              builder: (context, selectedType) {
                                final isSelected =
                                    selectedType == values[index];

                                return CustomTextButton(
                                  text: texts[index],
                                  onTap: () =>
                                      _selectType(context, values[index]),
                                  borderRadius: 1000.r,
                                  borderColor: isSelected
                                      ? context.theme.primaryColor
                                      : context.customColor.border,
                                  textColor: isSelected
                                      ? context.theme.primaryColor
                                      : context.customColor.text3,
                                  padding: EdgeInsets.symmetric(vertical: 10.r),
                                );
                              },
                            ),
                      );
                    }),
                  ),
                  10.verticalSpace,
                  Text(
                    context.tr.date,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  5.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown<int>(
                          items: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                          displayTextBuilder: (value) => value != null
                              ? value.toString()
                              : context.tr.selectMonth,
                          itemBuilder: (context, item, isSelected) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.r,
                                vertical: 10.r,
                              ),
                              child: Text(
                                item.toString(),
                                style: AppStyles.s13W500.copyWith(
                                  color: isSelected
                                      ? context.theme.primaryColor
                                      : context.customColor.text1,
                                ),
                              ),
                            );
                          },
                          onChanged: (value) {
                            _selectMonth(context, value);
                          },
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: CustomDropdown<int>(
                          items: List.generate(
                            10,
                            (index) => DateTime.now().year - index,
                          ),
                          displayTextBuilder: (value) => value != null
                              ? value.toString()
                              : context.tr.selectYear,
                          itemBuilder: (context, item, isSelected) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.r,
                                vertical: 10.r,
                              ),
                              child: Text(
                                item.toString(),
                                style: AppStyles.s13W500.copyWith(
                                  color: isSelected
                                      ? context.theme.primaryColor
                                      : context.customColor.text1,
                                ),
                              ),
                            );
                          },
                          onChanged: (value) {
                            _selectYear(context, value);
                          },
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
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
                                    state.getTypedValue<String>('formatType') ==
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
            20.verticalSpace,
            BlocConsumer<ExportExpenseReportCubit, ExportExpenseReportState>(
              listener: (context, state) async {
                if (state is ExportExpenseReportSuccess) {
                  NavigationService.I.pop();
                  getIt<DownloadService>().downloadFile(
                    url: state.fileUrl,
                    fileName: 'expense_report.${state.fileUrl.split('.').last}',
                  );
                } else if (state is ExportExpenseReportFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is ExportExpenseReportLoading) {
                  return const AppButtonLoading();
                }

                return BlocSelector<ValidationCubit, ValidationState, bool>(
                  selector: (state) {
                    return state.enableButton;
                  },
                  builder: (context, isValid) {
                    return AppButton(
                      onClick: () {
                        final validationState = context
                            .read<ValidationCubit>()
                            .state;
                        final year = validationState.getTypedValue<int>(
                          'year',
                        )!;
                        final month = validationState.getTypedValue<int>(
                          'monthNumber',
                        )!;
                        final format = validationState.getTypedValue<String>(
                          'formatType',
                        )!;
                        final expenseType = validationState
                            .getTypedValue<BrandOwnerExpenseReportType>(
                              'expenseType',
                            )!
                            .value;

                        context
                            .read<ExportExpenseReportCubit>()
                            .exportExpenseReport(
                              year: year,
                              monthNumber: month,
                              formatType: format,
                              expenseType: expenseType,
                              onSuccess: onExportSuccess,
                            );
                      },
                      enabled: isValid,
                      text: context.tr.exportReport,
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
