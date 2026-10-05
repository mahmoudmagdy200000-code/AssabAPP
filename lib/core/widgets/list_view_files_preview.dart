import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/media/media_cubit.dart';
import '../cubits/media/media_state.dart';
import '../models/media_file_model.dart';
import 'file_preview_widget.dart';

class ListViewFilesPreview extends StatelessWidget {
  final MediaCubit mediaCubit;
  final bool isSilver;
  final ScrollPhysics? physics;

  const ListViewFilesPreview({
    super.key,
    required this.mediaCubit,
    this.isSilver = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MediaCubit, MediaState, List<MediaFile>>(
      selector: (state) {
        if (state is MediaLoaded) {
          final files = state.allFiles.where((f) => f.selected).toList();

          context.read<ValidationCubit>().validateField(
            'photos',
            files.isNotEmpty,
          );

          return files;
        }

        return const [];
      },
      builder: (context, allFiles) {
        if (isSilver) {
          return SliverList.builder(
            itemCount: allFiles.length,
            itemBuilder: (context, index) => FilePreviewWidget(
              file: allFiles[index],
              icon: AppAssets.trashSvg,
              onTapIcon: () =>
                  context.read<MediaCubit>().removeFile(allFiles[index]),
            ),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: physics,
            itemCount: allFiles.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => FilePreviewWidget(
              file: allFiles[index],
              icon: AppAssets.trashSvg,
              onTapIcon: () {
                context.read<MediaCubit>().removeFile(allFiles[index]);
              },
            ),
          );
        }
      },
    );
  }
}
