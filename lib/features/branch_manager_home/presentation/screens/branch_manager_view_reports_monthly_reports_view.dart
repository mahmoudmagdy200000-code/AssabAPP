import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/download_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/app_svg_button.dart';
import '../../../brand_owner_reports_and_analytics/domain/entities/brand_owner_export_history_entity.dart';
import '../../../brand_owner_reports_and_analytics/domain/entities/brand_owner_report_entity.dart';
import '../../../brand_owner_reports_and_analytics/domain/entities/brand_owner_reports_and_analytics_entity.dart';
import '../../../brand_owner_reports_and_analytics/presentation/cubit/brand_owner_reports_and_analytics_cubit.dart';
import '../../../brand_owner_reports_and_analytics/presentation/cubit/brand_owner_reports_and_analytics_state.dart';
import '../../../custody/presentation/widgets/custody_empty_widget.dart';

class BranchManagerViewReportsMonthlyReportsView extends StatelessWidget {
  const BranchManagerViewReportsMonthlyReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BrandOwnerReportsAndAnalyticsCubit,
      BrandOwnerReportsAndAnalyticsState
    >(
      builder: (context, state) {
        return switch (state) {
          BrandOwnerReportsAndAnalyticsInitial() ||
          BrandOwnerReportsAndAnalyticsLoading() => const AppLoadingWidget(),
          BrandOwnerReportsAndAnalyticsFailure(:final failure) =>
            AppFailureWidget(
              failure: failure,
              onRetry: () => context
                  .read<BrandOwnerReportsAndAnalyticsCubit>()
                  .loadReportsAndAnalytics(),
            ),
          BrandOwnerReportsAndAnalyticsSuccess(:final data) => _buildContent(
            context,
            data,
          ),
        };
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    BrandOwnerReportsAndAnalyticsEntity data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, context.tr.reports, data.reports.length),
        10.verticalSpace,
        _buildReportsList(context, data.reports),
        10.verticalSpace,
        _buildSectionHeader(
          context,
          context.tr.exportHistory,
          data.exportHistory.length,
        ),
        10.verticalSpace,
        _buildExportHistoryList(context, data.exportHistory),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Text(
      '$title ($count)',
      style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
    );
  }

  Widget _buildReportsList(
    BuildContext context,
    List<BrandOwnerReportEntity> reports,
  ) {
    if (reports.isEmpty) {
      return Expanded(
        child: CustodyEmptyWidget(
          asset: AppAssets.viewReportsPng,
          title: context.tr.noReportsAvailable,
          desc: context.tr.reportsHaventBeenGeneratedYet,
          isScrollable: true,
        ),
      );
    }

    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.customColor.text2,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r.r),
          child: ListView.builder(
            itemCount: reports.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return _buildReportItem(context, reports[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReportItem(BuildContext context, BrandOwnerReportEntity report) {
    return AppGestureDetectorButton(
      onTap: () => report.type.onTap(
        context,
        report.id,
        onExportSuccess: () {
          context
              .read<BrandOwnerReportsAndAnalyticsCubit>()
              .loadReportsAndAnalytics();
        },
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.only(bottom: 8.r),
        padding: EdgeInsets.all(10.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSvg(
              assetName: report.type.icon,
              width: 18.w,
              colorFilter: ColorFilter.mode(
                context.customColor.text3,
                BlendMode.srcIn,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.type.title(context),
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          '${DateFormatter.formatDateMDY(DateTime.tryParse(report.periodLabel))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(report.periodLabel))}',
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.horizontalSpace,
                  AppSvg(
                    assetName: AppAssets.arrowRight,
                    width: 14.w,
                    colorFilter: ColorFilter.mode(
                      context.customColor.text1,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportHistoryList(
    BuildContext context,
    List<BrandOwnerExportHistoryEntity> exportHistory,
  ) {
    if (exportHistory.isEmpty) {
      return Expanded(
        child: CustodyEmptyWidget(
          asset: AppAssets.downloadPng,
          title: context.tr.noReportsExportedYet,
          desc: context.tr.noReportsExportedYetDesc,
          isScrollable: true,
        ),
      );
    }

    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.customColor.text2,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r.r),
          child: ListView.builder(
            itemCount: exportHistory.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return _buildExportHistoryItem(context, exportHistory[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExportHistoryItem(
    BuildContext context,
    BrandOwnerExportHistoryEntity item,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.only(bottom: 8.r),
      padding: EdgeInsets.all(10.r),
      child: Row(
        children: [
          AppSvg(
            assetName: item.type == 'pdf'
                ? AppAssets.pdfSvg
                : AppAssets.excelSvg,
            width: 30.r,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Text(
                  '${DateFormatter.formatDateMDY(DateTime.tryParse(item.createdAtLabel))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(item.createdAtLabel))}',
                  style: AppStyles.s11W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          AppSvgButton(
            assetName: AppAssets.download,
            onTap: () {
              getIt<DownloadService>().downloadFile(
                url: item.downloadUrl,
                fileName: item.title,
              );
            },
          ),
        ],
      ),
    );
  }
}
