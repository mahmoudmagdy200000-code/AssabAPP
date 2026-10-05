import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/cubits/media/media_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/pdf_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'image_picker_screen.dart';

class MediaMainScreen extends StatefulWidget {
  final bool selectSingleFile;

  const MediaMainScreen({super.key, this.selectSingleFile = false});

  @override
  State<MediaMainScreen> createState() => _MediaMainScreenState();
}

class _MediaMainScreenState extends State<MediaMainScreen> {
  late final ValueNotifier<int> _currentIndexNotifier;

  late final MediaCubit _cubit;

  void _onTabChange(BuildContext context, int index) {
    _currentIndexNotifier.value = index;
  }

  @override
  void initState() {
    _currentIndexNotifier = ValueNotifier<int>(0);
    _cubit = context.read<MediaCubit>();
    _cubit.singleSelectionMode = widget.selectSingleFile;
    _cubit.loadAllMedia();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.discardTempSelection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = context.watch<MediaCubit>().selectedCount;

    return Scaffold(
      body: Column(
        children: [
          50.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(1000.r),
            ),
            padding: EdgeInsets.all(6.r),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppGestureDetectorButton(
                  onTap: () => _onTabChange(context, 0),
                  child: ValueListenableBuilder(
                    valueListenable: _currentIndexNotifier,
                    builder: (context, currentIndex, child) {
                      return Container(
                        decoration: BoxDecoration(
                          color: currentIndex == 0
                              ? context.customColor.reversedTextColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(1000.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 7.r,
                          horizontal: 20.r,
                        ),
                        child: Text(
                          context.tr.photos,
                          style: AppStyles.s13W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                10.horizontalSpace,
                AppGestureDetectorButton(
                  onTap: () => _onTabChange(context, 1),
                  child: ValueListenableBuilder(
                    valueListenable: _currentIndexNotifier,
                    builder: (context, currentIndex, child) {
                      return Container(
                        decoration: BoxDecoration(
                          color: currentIndex == 1
                              ? context.customColor.reversedTextColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(1000.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 7.r,
                          horizontal: 20.r,
                        ),
                        child: Text(
                          context.tr.files,
                          style: AppStyles.s13W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          12.verticalSpace,
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, child) {
                return BlocSelector<MediaCubit, MediaState, bool>(
                  selector: (state) => state is MediaPermissionDenied,
                  builder: (context, isPermissionDenied) {
                    if (isPermissionDenied) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_off_outlined,
                              size: 64.r,
                              color: context.customColor.text3,
                            ),
                            20.verticalSpace,
                            Text(
                              context.tr.permissionRequired,
                              style: AppStyles.s20W500.copyWith(
                                color: context.customColor.text1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            10.verticalSpace,
                            Text(
                              'Please grant storage permission to access your photos and files',
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            30.verticalSpace,
                            // Open Settings Button
                            AppGestureDetectorButton(
                              onTap: () async {
                                await context
                                    .read<MediaCubit>()
                                    .openPermissionSettings();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 14.r,
                                  horizontal: 24.r,
                                ),
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Open Settings',
                                  style: AppStyles.s15W500.copyWith(
                                    color:
                                        context.customColor.reversedTextColor,
                                  ),
                                ),
                              ),
                            ),
                            16.verticalSpace,
                            // Try Again Button
                            AppGestureDetectorButton(
                              onTap: () =>
                                  context.read<MediaCubit>().loadAllMedia(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 14.r,
                                  horizontal: 24.r,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: context.customColor.border,
                                  ),
                                ),
                                child: Text(
                                  'Try Again',
                                  style: AppStyles.s15W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return IndexedStack(
                      index: currentIndex,
                      children: const [ImagePickerScreen(), PdfPickerScreen()],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(selectedCount),
    );
  }

  Widget _buildBottomNavBar(int selectedCount) {
    return Container(
      color: context.customColor.reversedTextColor,
      padding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 20.r),
      child: Row(
        children: [
          if (selectedCount != 0)
            AppGestureDetectorButton(
              onTap: () => context.read<MediaCubit>().clearSelection(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.symmetric(vertical: 18.r, horizontal: 20.r),
                child: Text(
                  context.tr.unselectAll,
                  textAlign: TextAlign.center,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ),
          10.horizontalSpace,
          Expanded(
            child: AppGestureDetectorButton(
              onTap: selectedCount == 0
                  ? () {}
                  : () {
                      context.read<MediaCubit>().confirmSelection();
                      NavigationService.I.pop();
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: selectedCount == 0
                      ? context.customColor.text2
                      : context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 18.r, horizontal: 20.r),
                child: Text(
                  '${context.tr.confirm} $selectedCount ${context.tr.selection}',
                  textAlign: TextAlign.center,
                  style: AppStyles.s14W400.copyWith(
                    color: selectedCount == 0
                        ? context.customColor.text3
                        : context.customColor.reversedTextColor,
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
