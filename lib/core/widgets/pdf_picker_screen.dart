import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_assets.dart';
import '../cubits/media/media_cubit.dart';
import '../cubits/media/media_state.dart';
import '../models/media_file_model.dart';
import '../styles/app_styles.dart';
import 'app_asset_image.dart';

class PdfPickerScreen extends StatelessWidget {
  const PdfPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MediaCubit, MediaState>(
        buildWhen: (previous, current) {
          // Only rebuild when necessary
          if (previous is MediaLoaded && current is MediaLoaded) {
            return previous.pdfFiles.length != current.pdfFiles.length ||
                previous.isLoadingMorePdfs != current.isLoadingMorePdfs ||
                _hasSelectionChanged(previous.pdfFiles, current.pdfFiles);
          }
          return true;
        },
        builder: (context, state) {
          // Handle permission denied state - parent handles this
          if (state is MediaPermissionDenied) {
            return const SizedBox.shrink();
          }

          // Handle loading state
          if (state is MediaLoading && state.isInitialLoad) {
            return const AppLoadingWidget();
          }

          // Handle failure state
          if (state is MediaFailure) {
            return Center(child: Text('${context.tr.error}: ${state.message}'));
          }

          // Get files from loaded state
          final files = state is MediaLoaded ? state.pdfFiles : <MediaFile>[];
          final isLoadingMore = state is MediaLoaded
              ? state.isLoadingMorePdfs
              : false;

          // Show empty state only when loading is complete
          if (files.isEmpty && !isLoadingMore && state is MediaLoaded) {
            return Center(
              child: Text(
                context.tr.noPdfFilesFound,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            );
          }

          return Column(
            children: [
              // Loading indicator while streaming more PDFs
              if (isLoadingMore)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.r,
                          color: context.theme.primaryColor,
                        ),
                      ),
                      SizedBox(width: 8.r),
                      Text(
                        'Loading PDFs... (${files.length})',
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),

              // PDF grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(20.r),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2.r,
                    crossAxisSpacing: 2.r,
                    childAspectRatio: 1.4.r,
                  ),
                  // Use cacheExtent for smoother scrolling
                  cacheExtent: 300,
                  itemCount: files.length,
                  itemBuilder: (_, i) {
                    final file = files[i];
                    return _PdfGridItem(
                      key: ValueKey(file.path),
                      file: file,
                      onTap: () =>
                          context.read<MediaCubit>().toggleSelection(file),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Check if selection state changed between two lists
  bool _hasSelectionChanged(List<MediaFile> previous, List<MediaFile> current) {
    if (previous.length != current.length) return true;
    for (int i = 0; i < previous.length; i++) {
      if (previous[i].selected != current[i].selected) return true;
    }
    return false;
  }
}

/// Optimized PDF grid item with minimal rebuilds
class _PdfGridItem extends StatelessWidget {
  final MediaFile file;
  final VoidCallback onTap;

  const _PdfGridItem({super.key, required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RepaintBoundary(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: file.selected
                    ? context.customColor.reversedTextColor
                    : context.customColor.text2,
                border: Border.all(
                  color: file.selected
                      ? context.theme.primaryColor
                      : context.customColor.text2,
                  width: 1.w,
                ),
              ),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppAssetImage(
                      image: AppAssets.pdf,
                      width: 40.w,
                      height: 40.w,
                      borderRadius: BorderRadius.zero,
                    ),
                    10.verticalSpace,
                    Text(
                      file.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.s12W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      file.formattedSize,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.s12W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (file.selected)
              Positioned(
                right: 0,
                child: Container(
                  width: 82.w,
                  height: 29.h,
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(20.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      context.tr.selected,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.reversedTextColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
