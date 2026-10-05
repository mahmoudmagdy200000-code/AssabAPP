import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/media/media_cubit.dart';
import '../services/navigation/navigation_service.dart';
import 'button_text_icon.dart';
import 'media_main_screen.dart';

class UploadExpenseInvoiceReceipt extends StatelessWidget {
  final bool singleSelectionMode;
  final bool isFlexible;

  const UploadExpenseInvoiceReceipt({
    super.key,
    this.singleSelectionMode = false,
    this.isFlexible = false,
  });

  void _openFilePicker(BuildContext context) {
    final mediaCubit = context.read<MediaCubit>();

    NavigationService.I.push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: mediaCubit,
          child: MediaMainScreen(selectSingleFile: singleSelectionMode),
        ),
      ),
    );
  }

  void _captureImage(BuildContext context) {
    context.read<MediaCubit>().captureImage();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        Expanded(
          child: ButtonTextIcon(
            label: context.tr.takeAPhoto,
            icon: Icon(
              Icons.camera_alt,
              size: 18.r,
              color: context.theme.primaryColor,
            ),
            onTap: () => _captureImage(context),
            isFlexible: isFlexible,
          ),
        ),
        Expanded(
          child: ButtonTextIcon(
            onTap: () => _openFilePicker(context),
            label: context.tr.fromFiles,
            icon: Icon(
              Icons.image_rounded,
              size: 18.r,
              color: context.theme.primaryColor,
            ),
            isFlexible: isFlexible,
          ),
        ),
      ],
    );
  }
}
