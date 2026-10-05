import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/dynamic_steps/dynamic_steps_cubit.dart';
import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/widgets/file_preview_widget.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/enums/document_type_enum.dart';
import '../../data/models/receive_goods_local_item_model.dart';
import '../../presentation/screens/receive_goods_invoice_document_type_view.dart';
import '../../presentation/screens/receive_goods_variance_view.dart';

abstract class DocumentTypeStrategy {
  String get value;

  int get insertIndex => 2;

  void addDynamicView(BuildContext context) {
    final dynamicStepsCubit = context.read<DynamicStepsCubit>();

    // Remove only the variance and required action steps, not the summary
    while (dynamicStepsCubit.state.builders.length > insertIndex + 1) {
      dynamicStepsCubit.removeStep(insertIndex);
    }
  }

  Widget buildMiddleSectionInVarianceView(BuildContext context) {
    return const SizedBox.shrink();
  }

  String typeLabel(BuildContext context) {
    return value;
  }
}

class InvoiceDocumentTypeStrategy extends DocumentTypeStrategy {
  @override
  String get value => DocumentTypeEnum.invoice.value;

  @override
  void addDynamicView(BuildContext context) {
    super.addDynamicView(context);

    final dynamicStepsCubit = context.read<DynamicStepsCubit>();

    dynamicStepsCubit.insertStep(
      insertIndex,
      () => BlocProvider(
        create: (context) => getIt<MediaCubit>(),
        child: const ReceiveGoodsInvoiceDocumentTypeView(),
      ),
      context.tr.invoice,
    );
  }

  @override
  String typeLabel(BuildContext context) {
    return context.tr.invoice;
  }
}

class DeliveryNoteDocumentTypeStrategy extends DocumentTypeStrategy {
  @override
  String get value => DocumentTypeEnum.deliveryNote.value;

  @override
  void addDynamicView(BuildContext context) {
    super.addDynamicView(context);

    final dynamicStepsCubit = context.read<DynamicStepsCubit>();

    final validationCubit = context.read<ValidationCubit>();
    final items =
        validationCubit.getListValue<ReceiveGoodsLocalItemModel>(
          'receiveGoodsItems',
        ) ??
        [];

    final hasVariance = items.any((item) => item.isVariance);

    if (hasVariance) {
      dynamicStepsCubit.insertStep(
        insertIndex,
        () => ReceiveGoodsVarianceView(strategy: this),
        context.tr.variance_v,
      );
    }
  }

  @override
  String typeLabel(BuildContext context) {
    return context.tr.deliveryNote;
  }
}

class ReturnDocumentTypeStrategy extends DocumentTypeStrategy {
  @override
  String get value => DocumentTypeEnum.receiptWithoutDocuments.value;

  @override
  void addDynamicView(BuildContext context) {
    super.addDynamicView(context);

    final dynamicStepsCubit = context.read<DynamicStepsCubit>();

    final validationCubit = context.read<ValidationCubit>();
    final items =
        validationCubit.getListValue<ReceiveGoodsLocalItemModel>(
          'receiveGoodsItems',
        ) ??
        [];

    final hasVariance = items.any((item) => item.isVariance);

    if (hasVariance) {
      dynamicStepsCubit.insertStep(
        insertIndex,
        () => BlocProvider(
          create: (context) => getIt<MediaCubit>(),
          child: ReceiveGoodsVarianceView(strategy: this),
        ),
        context.tr.variance_v,
      );
    }
  }

  @override
  Widget buildMiddleSectionInVarianceView(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.addDynamicFields({'file'});

    return Column(
      children: [
        LabelTextField(
          text: context.tr.uploadPhoto,
          isLabelOptional: true,
          isLabelRequired: false,
        ),
        5.verticalSpace,
        BlocSelector<MediaCubit, MediaState, MediaFile?>(
          selector: (state) {
            if (state is MediaLoaded) {
              final file = state.allFiles.cast<MediaFile?>().firstWhere(
                (f) => f!.selected,
                orElse: () => null,
              );

              context.read<ValidationCubit>().validateField(
                'file',
                file != null,
              );

              return file;
            }

            return null;
          },
          builder: (context, state) {
            if (state != null) {
              return FilePreviewWidget(
                file: state,
                onTapIcon: () {
                  context.read<MediaCubit>().unselectFile(state);
                },
                icon: AppAssets.trashSvg,
              );
            }

            return const UploadExpenseInvoiceReceipt();
          },
        ),
        10.verticalSpace,
      ],
    );
  }

  @override
  String typeLabel(BuildContext context) {
    return context.tr.receiptWithoutDocuments;
  }
}
