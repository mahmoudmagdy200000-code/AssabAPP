import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../data/models/fixed_asset_preview_asset_history_response.dart';
import '../../data/models/fixed_asset_preview_generate_report_response.dart';
import '../cubit/generate_fixed_assets_preview_history_asset_report/generate_fixed_assets_preview_history_asset_report_cubit.dart';
import '../cubit/generate_fixed_assets_preview_history_asset_report/generate_fixed_assets_preview_history_asset_report_state.dart';
import '../cubit/get_fixed_assets_preview_history_asset/get_fixed_assets_preview_history_asset_cubit.dart';
import '../cubit/get_fixed_assets_preview_history_asset/get_fixed_assets_preview_history_asset_state.dart';

class FixedAssetsPreviewHistoryAssetScreen extends StatefulWidget {
  final String assetId;

  const FixedAssetsPreviewHistoryAssetScreen({
    super.key,
    required this.assetId,
  });

  @override
  State<FixedAssetsPreviewHistoryAssetScreen> createState() =>
      _FixedAssetsPreviewHistoryAssetScreenState();
}

class _FixedAssetsPreviewHistoryAssetScreenState
    extends State<FixedAssetsPreviewHistoryAssetScreen> {
  late final GetFixedAssetsPreviewHistoryAssetCubit _historyCubit;
  late final GenerateFixedAssetsPreviewHistoryAssetReportCubit _reportCubit;
  late final Map<String, bool> _sectionStates;

  @override
  void initState() {
    super.initState();
    _historyCubit = getIt<GetFixedAssetsPreviewHistoryAssetCubit>();
    _reportCubit = getIt<GenerateFixedAssetsPreviewHistoryAssetReportCubit>();
    _sectionStates = {
      'historical_photos': true,
      'status_history': true,
      'transfer_history': true,
      'custody_history': true,
      'financial_info': true,
    };
    _historyCubit.getHistory(assetId: widget.assetId);
  }

  @override
  void dispose() {
    _historyCubit.close();
    _reportCubit.close();
    super.dispose();
  }

  void _toggleSection(String key) {
    setState(() {
      _sectionStates[key] = !(_sectionStates[key] ?? true);
    });
  }

  Future<void> _downloadReport(
    FixedAssetPreviewGenerateReportResponse response,
  ) async {
    final result = await getIt<DownloadService>().downloadFile(
      url: response.downloadUrl,
      fileName: response.fileName,
    );

    if (!mounted) {
      return;
    }

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Download failed')),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr.reportSaved)));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _historyCubit),
        BlocProvider.value(value: _reportCubit),
      ],
      child:
          BlocListener<
            GenerateFixedAssetsPreviewHistoryAssetReportCubit,
            GenerateFixedAssetsPreviewHistoryAssetReportState
          >(
            listener: (context, state) {
              if (state
                  is GenerateFixedAssetsPreviewHistoryAssetReportFailure) {
                AppDialog.showErrorDialog(
                  context: context,
                  failure: state.failure,
                );
                return;
              }

              if (state
                  is GenerateFixedAssetsPreviewHistoryAssetReportSuccess) {
                _downloadReport(state.response);
              }
            },
            child: Scaffold(
              backgroundColor: context.customColor.text5,
              body: SafeArea(
                child: Column(
                  children: [
                    const _Header(),
                    Expanded(
                      child:
                          BlocBuilder<
                            GetFixedAssetsPreviewHistoryAssetCubit,
                            GetFixedAssetsPreviewHistoryAssetState
                          >(
                            builder: (context, state) {
                              if (state
                                  is GetFixedAssetsPreviewHistoryAssetLoading) {
                                return const AppLoadingWidget();
                              }

                              if (state
                                  is GetFixedAssetsPreviewHistoryAssetFailure) {
                                return AppFailureWidget(
                                  failure: state.failure,
                                  onRetry: () => _historyCubit.getHistory(
                                    assetId: widget.assetId,
                                  ),
                                );
                              }

                              if (state
                                  is! GetFixedAssetsPreviewHistoryAssetSuccess) {
                                return AppLocalFailure(
                                  onRetry: () => _historyCubit.getHistory(
                                    assetId: widget.assetId,
                                  ),
                                );
                              }

                              final response = state.response;

                              return ListView(
                                padding: EdgeInsets.only(bottom: 100.h),
                                children: [
                                  _AssetSummaryCard(response: response),
                                  _HistoricalPhotosSection(
                                    section: response.photos,
                                    isOpen:
                                        _sectionStates['historical_photos'] ??
                                        true,
                                    onToggle: () =>
                                        _toggleSection('historical_photos'),
                                  ),
                                  _StatusHistorySection(
                                    section: response.statusHistory,
                                    isOpen:
                                        _sectionStates['status_history'] ??
                                        true,
                                    onToggle: () =>
                                        _toggleSection('status_history'),
                                  ),
                                  _TransferHistorySection(
                                    section: response.transfers,
                                    isOpen:
                                        _sectionStates['transfer_history'] ??
                                        true,
                                    onToggle: () =>
                                        _toggleSection('transfer_history'),
                                  ),
                                  _CustodyHistorySection(
                                    section: response.custody,
                                    isOpen:
                                        _sectionStates['custody_history'] ??
                                        true,
                                    onToggle: () =>
                                        _toggleSection('custody_history'),
                                  ),
                                  _FinancialSection(
                                    section: response.financial,
                                    isOpen:
                                        _sectionStates['financial_info'] ??
                                        true,
                                    onToggle: () =>
                                        _toggleSection('financial_info'),
                                  ),
                                ],
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar:
                  BlocBuilder<
                    GenerateFixedAssetsPreviewHistoryAssetReportCubit,
                    GenerateFixedAssetsPreviewHistoryAssetReportState
                  >(
                    builder: (context, state) {
                      final isLoading =
                          state
                              is GenerateFixedAssetsPreviewHistoryAssetReportLoading;

                      return _BottomBar(
                        isLoading: isLoading,
                        onGenerateReport: () {
                          if (!isLoading) {
                            _reportCubit.generateReport(
                              assetId: widget.assetId,
                            );
                          }
                        },
                      );
                    },
                  ),
            ),
          ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      child: Row(
        children: [
          const AppBackButton(),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr.fullAssetHistoryView, style: AppStyles.s16W600),
                2.verticalSpace,
                Text(
                  context.tr.reviewDetailsTimelineAndChangesBelow,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
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

class _AssetSummaryCard extends StatelessWidget {
  final FixedAssetPreviewAssetHistoryResponse response;

  const _AssetSummaryCard({required this.response});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: _cardDecoration(context),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                AppNetworkImage(
                  image: response.assetImage.isNotEmpty
                      ? response.assetImage
                      : 'assets/images/coffee_machine.jpg',
                  height: 80.r,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                Positioned(
                  left: 4.w,
                  bottom: 4.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      context.tr.currentImage,
                      style: AppStyles.s10W500.copyWith(
                        color: context.customColor.reversedTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(response.assetName, style: AppStyles.s14W600),
                4.verticalSpace,
                Text(
                  '${response.assetCode} • ${response.location}',
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
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

class _CollapsibleSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool isOpen;
  final VoidCallback onToggle;

  const _CollapsibleSection({
    required this.title,
    required this.subtitle,
    required this.children,
    required this.isOpen,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppStyles.s14W600),
                        2.verticalSpace,
                        Text(
                          subtitle,
                          style: AppStyles.s11W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isOpen ? Icons.expand_less : Icons.expand_more,
                    color: context.customColor.text3,
                    size: 24.f,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              child: Column(children: children),
            ),
        ],
      ),
    );
  }
}

class _HistoricalPhotosSection extends StatelessWidget {
  final FixedAssetPreviewPhotosSection? section;
  final VoidCallback onToggle;
  final bool isOpen;

  const _HistoricalPhotosSection({
    required this.section,
    required this.onToggle,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final photos = section?.photos ?? const <FixedAssetPreviewPhoto>[];

    return _CollapsibleSection(
      title: context.tr.historicalPhotos,
      subtitle: context.tr.tapArrowToCloseTimelinesAndChanges,
      isOpen: isOpen,
      onToggle: onToggle,
      children: [
        if (photos.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'No historical photos available',
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          )
        else ...[
          ...photos.map((photo) => _PhotoCard(photo: photo)),
          if ((section?.totalCount ?? 0) > 0) ...[
            12.verticalSpace,
            CustomTextButton(
              text: context.tr.showAllPhotos(section!.totalCount),
              onTap: () {},
              textColor: context.theme.primaryColor,
              borderColor: context.theme.primaryColor.withAlpha(100),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              borderRadius: 12.r,
            ),
          ],
        ],
      ],
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final FixedAssetPreviewPhoto photo;

  const _PhotoCard({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              AppNetworkImage(
                image: photo.imageUrl.isNotEmpty
                    ? photo.imageUrl
                    : 'assets/images/coffee_machine.jpg',
                width: double.infinity,
                height: 150.r,
                borderRadius: BorderRadius.circular(12.r),
              ),
              if (photo.isCurrent)
                Positioned(
                  left: 8.w,
                  top: 8.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      context.tr.currentImage,
                      style: AppStyles.s10W500.copyWith(
                        color: context.customColor.reversedTextColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              children: [
                _KVRow(
                  k: context.tr.updatedBy,
                  v: photo.updatedBy,
                  avatar: true,
                ),
                6.verticalSpace,
                _KVRow(k: context.tr.dateAndTime, v: photo.date),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KVRow extends StatelessWidget {
  final String k;
  final String v;
  final bool avatar;

  const _KVRow({required this.k, required this.v, this.avatar = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          k,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
        ),
        Row(
          children: [
            if (avatar)
              Container(
                width: 18.w,
                height: 18.h,
                margin: EdgeInsets.only(right: 6.w),
                decoration: BoxDecoration(
                  color: context.customColor.text5,
                  shape: BoxShape.circle,
                ),
              ),
            Text(v, style: AppStyles.s12W400),
          ],
        ),
      ],
    );
  }
}

class _StatusHistorySection extends StatelessWidget {
  final FixedAssetPreviewStatusSection? section;
  final VoidCallback onToggle;
  final bool isOpen;

  const _StatusHistorySection({
    required this.section,
    required this.onToggle,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = section?.statuses ?? const <FixedAssetPreviewStatus>[];

    return _CollapsibleSection(
      title: context.tr.statusHistory,
      subtitle: context.tr.tapArrowToCloseTimelinesAndChanges,
      isOpen: isOpen,
      onToggle: onToggle,
      children: [
        if (statuses.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'No status history available',
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          )
        else ...[
          ...statuses.map((status) => _StatusRow(status: status)),
          12.verticalSpace,
          CustomTextButton(
            text: context.tr.showMoreDetailedTimeline,
            onTap: () {},
            textColor: context.theme.primaryColor,
            borderColor: context.theme.primaryColor.withAlpha(100),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            borderRadius: 12.r,
          ),
        ],
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  final FixedAssetPreviewStatus status;

  const _StatusRow({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: _rowDecoration(context),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status.date, style: AppStyles.s12W400),
                2.verticalSpace,
                Text(
                  '(${status.note})',
                  style: AppStyles.s11W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          Text(status.status, style: AppStyles.s12W400),
          6.horizontalSpace,
          Icon(Icons.circle, size: 10.f, color: _parseStatusColor(status)),
        ],
      ),
    );
  }
}

class _TransferHistorySection extends StatelessWidget {
  final FixedAssetPreviewTransfersSection? section;
  final VoidCallback onToggle;
  final bool isOpen;

  const _TransferHistorySection({
    required this.section,
    required this.onToggle,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final transfers = section?.transfers ?? const <FixedAssetPreviewTransfer>[];

    return _CollapsibleSection(
      title: context.tr.transferMovementHistory,
      subtitle: context.tr.tapArrowToCloseTimelinesAndChanges,
      isOpen: isOpen,
      onToggle: onToggle,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              '${context.tr.totalMovements}: ${section?.totalCount ?? 0}',
              style: AppStyles.s13W600,
            ),
          ),
        ),
        if (transfers.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'No transfer history available',
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          )
        else ...[
          ...transfers.map((transfer) => _MovementRow(transfer: transfer)),
          12.verticalSpace,
          ButtonTextIcon(
            onTap: () {},
            label: context.tr.locationHistoryMap,
            icon: Icon(
              Icons.location_on_outlined,
              size: 18.f,
              color: context.customColor.reversedTextColor,
            ),
            isTransparent: false,
            backgroundColor: AppColors.sBlack,
            textColor: context.customColor.reversedTextColor,
            borderRadius: BorderRadius.circular(12.r),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          ),
        ],
      ],
    );
  }
}

class _MovementRow extends StatelessWidget {
  final FixedAssetPreviewTransfer transfer;

  const _MovementRow({required this.transfer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: _rowDecoration(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(transfer.date, style: AppStyles.s12W400),
          Text(transfer.label, style: AppStyles.s12W400),
        ],
      ),
    );
  }
}

class _CustodyHistorySection extends StatelessWidget {
  final FixedAssetPreviewCustodySection? section;
  final VoidCallback onToggle;
  final bool isOpen;

  const _CustodyHistorySection({
    required this.section,
    required this.onToggle,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return _CollapsibleSection(
      title: context.tr.custodyHistory,
      subtitle: context.tr.tapArrowToCloseTimelinesAndChanges,
      isOpen: isOpen,
      onToggle: onToggle,
      children: [
        if (section == null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'No custody history available',
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          )
        else ...[
          _InfoRow(
            label: '${context.tr.currentCustody}:',
            value: section!.currentCustody == null
                ? '-'
                : '${section!.currentCustody!.custodianName} (${section!.currentCustody!.duration})',
          ),
          _InfoRow(
            label: '${context.tr.previousCustody}:',
            value: section!.previousCustody.isEmpty
                ? '-'
                : section!.previousCustody.first.custodianName,
          ),
          _InfoRow(
            label: '${context.tr.performanceScore}:',
            value: section!.performanceScore.isEmpty
                ? '-'
                : section!.performanceScore,
            valueColor: _parsePerformanceColor(section!.performanceScore),
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: _rowDecoration(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          Text(
            value,
            style: AppStyles.s12W400.copyWith(
              color: valueColor ?? context.customColor.text1,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinancialSection extends StatelessWidget {
  final FixedAssetPreviewFinancialSection? section;
  final VoidCallback onToggle;
  final bool isOpen;

  const _FinancialSection({
    required this.section,
    required this.onToggle,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final items = section?.items ?? const <FixedAssetPreviewFinancial>[];

    return _CollapsibleSection(
      title: context.tr.financialInformation,
      subtitle: context.tr.tapArrowToCloseTimelinesAndChanges,
      isOpen: isOpen,
      onToggle: onToggle,
      children: [
        if (items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'No financial information available',
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          )
        else ...[
          ...items.map(
            (item) => _InfoRow(label: item.label, value: item.value),
          ),
          12.verticalSpace,
          ButtonTextIcon(
            onTap: () {},
            label: context.tr.viewPurchaseInvoice,
            icon: Icon(
              Icons.description_outlined,
              size: 18.f,
              color: context.customColor.reversedTextColor,
            ),
            isTransparent: false,
            backgroundColor: AppColors.sBlack,
            textColor: context.customColor.reversedTextColor,
            borderRadius: BorderRadius.circular(12.r),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          ),
        ],
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onGenerateReport;

  const _BottomBar({required this.isLoading, required this.onGenerateReport});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SafeArea(child: AppButtonLoading());
    }

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          border: Border(top: BorderSide(color: context.customColor.border)),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.customColor.border),
              ),
              child: Icon(
                Icons.more_horiz,
                size: 20.f,
                color: context.customColor.text3,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: ButtonTextIcon(
                onTap: onGenerateReport,
                label: context.tr.generateReport,
                icon: isLoading
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.customColor.reversedTextColor,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.bar_chart,
                        size: 18.f,
                        color: context.customColor.reversedTextColor,
                      ),
                isTransparent: false,
                backgroundColor: context.theme.primaryColor,
                textColor: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration(BuildContext context) => BoxDecoration(
  color: AppColors.lightBackground,
  borderRadius: BorderRadius.circular(16.r),
  border: Border.all(color: context.customColor.border),
);

BoxDecoration _rowDecoration(BuildContext context) => BoxDecoration(
  color: AppColors.lightBackground,
  borderRadius: BorderRadius.circular(12.r),
  border: Border.all(color: context.customColor.border),
);

Color _parseStatusColor(FixedAssetPreviewStatus status) {
  final rawValue = status.statusColor.trim();
  final lowerStatus = status.status.toLowerCase();

  if (rawValue.isNotEmpty) {
    final cleaned = rawValue
        .replaceFirst('#', '')
        .replaceFirst('0x', '')
        .replaceFirst('FF', '')
        .replaceFirst('ff', '');
    final value = int.tryParse('ff$cleaned', radix: 16);
    if (value != null) {
      return Color(value);
    }
  }

  if (lowerStatus.contains('problem')) {
    return AppColors.red;
  }
  if (lowerStatus.contains('attention')) {
    return AppColors.darkYellow;
  }
  return AppColors.darkGreen;
}

Color _parsePerformanceColor(String performanceScore) {
  final score = int.tryParse(
    performanceScore.replaceAll(RegExp(r'[^0-9]'), ''),
  );

  if (score == null) {
    return AppColors.darkGreen;
  }

  if (score >= 90) {
    return AppColors.darkGreen;
  }
  if (score >= 70) {
    return AppColors.darkYellow;
  }
  return AppColors.red;
}
