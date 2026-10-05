import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/custody/presentation/cubit/select_export_account_statement_as_pdf/select_export_account_statement_as_pdf_cubit.dart';
import 'package:assab/features/custody/presentation/cubit/select_export_account_statement_as_pdf/select_export_account_statement_as_pdf_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/custody_export_account_statement_export_format_enum.dart';
import '../../../../core/enums/time_keys.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/selection_circule.dart';
import '../cubit/export_personal_balance_as_pdf/export_personal_balance_as_pdf_cubit.dart';
import '../cubit/export_personal_balance_as_pdf/export_personal_balance_as_pdf_state.dart';
import 'package:url_launcher/url_launcher.dart';

class CustodyExportAsPdfBottomSheetWidget extends StatelessWidget {
  const CustodyExportAsPdfBottomSheetWidget({super.key});

  Future<void> _openReportUrl(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {}
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppPaddingWidget(
        top: 0,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppSvg(
                        assetName: AppAssets.pdfSvg,
                        width: 20.w,
                        colorFilter: ColorFilter.mode(
                          context.customColor.error,
                          BlendMode.srcIn,
                        ),
                      ),
                      10.horizontalSpace,
                      Text(
                        context.tr.exportAccountStatement,
                        style: AppStyles.s20W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  Text(
                    context
                        .tr
                        .chooseYourPreferredFileFormatAndSelectATimeframeTo,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  16.verticalSpace,
                  const CustomDivider(),
                  16.verticalSpace,
                  _buildText(context, context.tr.exportFormat),
                  8.verticalSpace,
                  Row(
                    children: List.generate(2, (index) {
                      final texts = [
                        context.tr.dailyView,
                        context.tr.detailedView,
                      ];

                      final frames = [
                        CustodyExportAccountStatementExportFormatEnum.dailyView,
                        CustodyExportAccountStatementExportFormatEnum
                            .detailedView,
                      ];

                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child:
                                  BlocSelector<
                                    SelectExportAccountStatementAsPdfCubit,
                                    SelectExportAccountStatementAsPdfState,
                                    bool
                                  >(
                                    selector: (state) =>
                                        state.exportFormat == frames[index],
                                    builder: (context, state) {
                                      return CustomTextButton(
                                        text: texts[index],
                                        borderRadius: 1000.r,
                                        borderColor: state
                                            ? context.theme.primaryColor
                                            : context.customColor.border,
                                        textColor: state
                                            ? context.theme.primaryColor
                                            : context.customColor.text3,
                                        onTap: () {
                                          context
                                              .read<
                                                SelectExportAccountStatementAsPdfCubit
                                              >()
                                              .setExportFormat(frames[index]);
                                        },
                                      );
                                    },
                                  ),
                            ),
                            if (index == 0) 10.horizontalSpace,
                          ],
                        ),
                      );
                    }),
                  ),
                  16.verticalSpace,
                  _buildText(context, context.tr.exportTimeFrame),
                  8.verticalSpace,
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: context.customColor.border),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.r,
                        vertical: 12.r,
                      ),
                      child: ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final texts = [
                            context.tr.last24Hours,
                            context.tr.last7Days,
                            context.tr.last30Days,
                            context.tr.last6Months,
                            // context.tr.custom,
                          ];

                          final sortOptions = [
                            TimeKeys.last24Hours,
                            TimeKeys.last7Days,
                            TimeKeys.last30Days,
                            TimeKeys.last6Months,
                            // TimeKeys.custom,
                          ];

                          final selectedTime = sortOptions[index];

                          return AppGestureDetectorButton(
                            onTap: () {
                              context
                                  .read<
                                    SelectExportAccountStatementAsPdfCubit
                                  >()
                                  .setExportTimeFrame(selectedTime);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: index != texts.length - 1
                                      ? BorderSide(
                                          color: context.customColor.border,
                                        )
                                      : BorderSide.none,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 13.r),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      texts[index],
                                      style: AppStyles.s13W400.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                  ),
                                  12.horizontalSpace,
                                  BlocSelector<
                                    SelectExportAccountStatementAsPdfCubit,
                                    SelectExportAccountStatementAsPdfState,
                                    bool
                                  >(
                                    selector: (state) =>
                                        state.timeFrame == selectedTime,
                                    builder: (context, state) {
                                      return SelectionCircule(
                                        isSelected: state,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            BlocConsumer<
              ExportPersonalBalanceAsPdfCubit,
              ExportPersonalBalanceAsPdfState
            >(
              listener: (context, state) async {
                if (state is ExportPersonalBalanceAsPdfSuccess) {
                  NavigationService.I.pop();

                  await _openReportUrl(state.fileUrl);
                } else if (state is ExportPersonalBalanceAsPdfFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is ExportPersonalBalanceAsPdfLoading) {
                  return const AppButtonLoading();
                }

                return BlocSelector<
                  SelectExportAccountStatementAsPdfCubit,
                  SelectExportAccountStatementAsPdfState,
                  bool
                >(
                  selector: (state) =>
                      state.exportFormat !=
                          CustodyExportAccountStatementExportFormatEnum.non &&
                      state.timeFrame != TimeKeys.non,
                  builder: (context, state) {
                    return AppButton(
                      onClick: () {
                        context
                            .read<ExportPersonalBalanceAsPdfCubit>()
                            .exportPersonalBalanceAsPdf(
                              timePeriod: context
                                  .read<
                                    SelectExportAccountStatementAsPdfCubit
                                  >()
                                  .state
                                  .timeFrame
                                  .key,
                              type: context
                                  .read<
                                    SelectExportAccountStatementAsPdfCubit
                                  >()
                                  .state
                                  .exportFormat
                                  .value,
                            );
                      },
                      enabled: state,
                      borderRadius: BorderRadius.circular(18.r),
                      text: context.tr.exportAccountStatement,
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

  Widget _buildText(BuildContext context, String text) {
    return Text(
      text,
      style: AppStyles.s14W500.copyWith(color: context.customColor.text3),
    );
  }
}
