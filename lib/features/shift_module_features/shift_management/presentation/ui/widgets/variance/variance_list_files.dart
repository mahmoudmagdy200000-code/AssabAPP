import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/cubits/media/media_cubit.dart';
import '../../../../../../../core/cubits/media/media_state.dart';
import '../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../core/models/media_file_model.dart';
import '../../../../../../../core/widgets/file_preview_widget.dart';

class VarianceListFiles extends StatelessWidget {
  const VarianceListFiles({
    super.key,
    this.padding,
    this.showRemoveIcon = true,
  });
  final EdgeInsets? padding;
  final bool showRemoveIcon;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<MediaCubit, MediaState, List<MediaFile>>(
      selector: (state) {
        if (state is MediaLoaded) {
          final files = state.allFiles.where((f) => f.selected).toList();

          context.read<ValidationCubit>().validateField(
            'attachments',
            files.isNotEmpty,
          );

          return files;
        }

        return const [];
      },
      builder: (context, allFiles) {
        context.read<ValidationCubit>().validateField(
          'reason',
          allFiles.isNotEmpty,
        );
        return ListView.builder(
          itemCount: allFiles.length,
          padding: padding,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => FilePreviewWidget(
            file: allFiles[index],
            icon: AppAssets.trashSvg,
            onTapIcon: () =>
                context.read<MediaCubit>().removeFile(allFiles[index]),
            showRemoveIcon: showRemoveIcon,
          ),
        );
      },
    );
  }
}
