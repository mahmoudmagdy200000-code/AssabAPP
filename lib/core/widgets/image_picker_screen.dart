import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_file_image.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/media/media_cubit.dart';
import '../cubits/media/media_state.dart';
import '../models/media_file_model.dart';
import '../styles/app_styles.dart';

class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MediaCubit, MediaState>(
        buildWhen: (previous, current) {
          // Only rebuild when necessary
          if (previous is MediaLoaded && current is MediaLoaded) {
            return previous.imageFiles.length != current.imageFiles.length ||
                previous.isLoadingMoreImages != current.isLoadingMoreImages ||
                _hasSelectionChanged(previous.imageFiles, current.imageFiles);
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
          final files = state is MediaLoaded ? state.imageFiles : <MediaFile>[];
          final isLoadingMore = state is MediaLoaded
              ? state.isLoadingMoreImages
              : false;

          // Show empty state only when loading is complete
          if (files.isEmpty && !isLoadingMore && state is MediaLoaded) {
            return Center(
              child: Text(
                context.tr.noImagesFound,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            );
          }

          return Column(
            children: [
              // Loading indicator while streaming more images
              if (isLoadingMore)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: const AppLoadingWidget(),
                      ),
                      SizedBox(width: 8.r),
                      Text(
                        'Loading images... (${files.length})',
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),

              // Image grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(20.r),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2.r,
                    crossAxisSpacing: 2.r,
                  ),
                  // Use cacheExtent for smoother scrolling
                  cacheExtent: 500,
                  itemCount: files.length,
                  itemBuilder: (_, i) {
                    final file = files[i];
                    return _ImageGridItem(
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

/// Optimized grid item with minimal rebuilds
class _ImageGridItem extends StatelessWidget {
  final MediaFile file;
  final VoidCallback onTap;

  const _ImageGridItem({super.key, required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Use RepaintBoundary to prevent unnecessary repaints
          RepaintBoundary(
            child: AppFileImage(
              image: file.path,
              borderRadius: BorderRadius.zero,
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
    );
  }
}
