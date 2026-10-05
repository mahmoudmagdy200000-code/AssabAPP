import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/widgets/file_preview_widget.dart';

class GroupedInvoiceAttachments extends StatelessWidget {
  final String id;

  const GroupedInvoiceAttachments({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MediaCubit, MediaState, List<MediaFile>>(
      selector: (state) {
        if (state is MediaLoaded) {
          final files = state.allFiles.where((f) => f.selected).toList();

          context.read<ValidationCubit>().validateField(
            'photos_$id',
            files.isNotEmpty,
          );

          return files;
        }

        return const [];
      },
      builder: (context, allFiles) {
        return ListView.builder(
          itemCount: allFiles.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => FilePreviewWidget(
            file: allFiles[index],
            icon: AppAssets.eye,
            onTapIcon: () {},
          ),
        );
      },
    );
  }
}
