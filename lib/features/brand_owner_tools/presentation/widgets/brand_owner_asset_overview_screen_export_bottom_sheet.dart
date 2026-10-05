import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/selection_circule.dart';
import '../cubit/brand_owner_asset_overview_export/brand_owner_asset_overview_export_cubit.dart';
import '../cubit/brand_owner_asset_overview_export/brand_owner_asset_overview_export_state.dart';

class BrandOwnerAssetOverviewScreenExportBottomSheet extends StatefulWidget {
  final String branchId;
  final String branchName;

  const BrandOwnerAssetOverviewScreenExportBottomSheet({
    super.key,
    required this.branchId,
    required this.branchName,
  });

  @override
  State<BrandOwnerAssetOverviewScreenExportBottomSheet> createState() =>
      _BrandOwnerAssetOverviewScreenExportBottomSheetState();
}

class _BrandOwnerAssetOverviewScreenExportBottomSheetState
    extends State<BrandOwnerAssetOverviewScreenExportBottomSheet> {
  Map<int, bool> _selected = {};
  String? _selectedFormat;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BrandOwnerAssetOverviewExportCubit>(),
      child: Scaffold(
        body: AppPaddingWidget(
          top: 30.r,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export Report',
                      style: AppStyles.s20W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      'Branch: ${widget.branchName}',
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    10.verticalSpace,
                    Column(
                      spacing: 10.h,
                      children: List.generate(2, (index) {
                        final formats = ['PDF', 'Excel'];
                        final icons = [AppAssets.pdfSvg, AppAssets.excelSvg];

                        return AppGestureDetectorButton(
                          onTap: () {
                            setState(() {
                              _selected = {index: !(_selected[index] ?? false)};
                              _selectedFormat = formats[index];
                            });
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
                                SelectionCircule(
                                  isSelected: _selected[index] ?? false,
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
              10.verticalSpace,
              BlocListener<
                BrandOwnerAssetOverviewExportCubit,
                BrandOwnerAssetOverviewExportState
              >(
                listener: (context, state) {
                  if (state is BrandOwnerAssetOverviewExportSuccess) {
                    AppSnackBar.showSuccess(
                      context,
                      'Report exported successfully',
                    );

                    // getIt<DownloadService>().downloadFile(url: state.response., fileName: fileName)

                    NavigationService.I.pop();
                  } else if (state is BrandOwnerAssetOverviewExportFailure) {
                    AppDialog.showErrorDialog(
                      context: context,
                      failure: state.failure,
                    );
                  }
                },
                child:
                    BlocBuilder<
                      BrandOwnerAssetOverviewExportCubit,
                      BrandOwnerAssetOverviewExportState
                    >(
                      builder: (context, state) {
                        if (state is BrandOwnerAssetOverviewExportLoading) {
                          return const AppButtonLoading();
                        }

                        return AppButton(
                          onClick: () {
                            context
                                .read<BrandOwnerAssetOverviewExportCubit>()
                                .export(
                                  branchId: widget.branchId,
                                  format: _selectedFormat!,
                                );
                          },
                          text: 'Export Report',
                          enabled: _selectedFormat != null,
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
