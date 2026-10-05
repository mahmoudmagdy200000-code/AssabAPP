import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/network_file_preview_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../widgets/order_confirmation_details_track_view.dart';
import '../../widgets/out_for_delivery_status_view.dart';
import '../../widgets/preparing_status_attachments_view.dart';
import '../../../features/supplier_requests/presentation/widgets/supplier_track_order_widget.dart';
import '../../../shared/models/order_track_response.dart';
import '../../constants/app_assets.dart';
import '../../errors/api_failure.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_styles.dart';
import '../../utils/app_bottom_sheet.dart';
import '../../widgets/variance_details_track_view.dart';

sealed class TrackOrderState extends Equatable {
  const TrackOrderState();

  @override
  List<Object> get props => [];

  Widget buildPreparing(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildOutToDelivery(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildDelivered(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildConfirmation(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildVariance(BuildContext context) {
    return const SizedBox.shrink();
  }
}

final class TrackOrderInitial extends TrackOrderState {
  const TrackOrderInitial();
}

final class TrackOrderLoading extends TrackOrderState {
  const TrackOrderLoading();
}

final class TrackOrderSuccess extends TrackOrderState {
  final OrderTrackResponse track;

  const TrackOrderSuccess(this.track);

  @override
  List<Object> get props => [track];

  @override
  Widget buildPreparing(BuildContext context) {
    if (track.data.stages.preparing == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SupplierTrackOrderWidget(
          assetName: AppAssets.preparing,
          title: context.tr.preparing,
          description:
              context.tr.uploadAllRequiredDocumentsBeforePreparingTheOrder,
          showButton: true,
          sectionAfterDetails: _sectionAfterDetails(
            context: context,
            text: context.tr.qualityCertificate,
          ),
          textButton: context.tr.viewAllAttachments,
          onClick: () {
            AppBottomSheet.show(
              context,
              (context) => PreparingStatusAttachmentsView(
                stage: track.data.stages.preparing!,
              ),
            );
          },
        ),
        12.verticalSpace,
      ],
    );
  }

  @override
  Widget buildOutToDelivery(BuildContext context) {
    if (track.data.stages.outForDelivery == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SupplierTrackOrderWidget(
          assetName: AppAssets.transportDelivery,
          title: context.tr.outForDelivery,
          description:
              context.tr.orderDetailsHaveBeenFinalizedAndTheDeliveryIsCurrently,
          showButton: true,
          textButton: context.tr.seeDeliveryDetails,
          onClick: () {
            AppBottomSheet.show(
              context,
              (context) => OutForDeliveryStatusView(
                stage: track.data.stages.outForDelivery!,
              ),
            );
          },
        ),
        12.verticalSpace,
      ],
    );
  }

  @override
  Widget buildDelivered(BuildContext context) {
    if (track.data.stages.delivered == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SupplierTrackOrderWidget(
          assetName: AppAssets.returnsManagement,
          iconColor: AppColors.lightGreen,
          title: context.tr.delivered,
          description: context.tr.uponDeliverySupplierWillUpload,
          sectionAfterDetails: _sectionAfterDetails(
            context: context,
            text: context.tr.invoice,
          ),
          customSection: Column(
            children: [
              3.verticalSpace,
              LabelTextField(
                text: context.tr.invoiceAttachment,
                isLabelOptional: true,
                isLabelRequired: false,
                customTextOption: track
                    .data
                    .stages
                    .delivered!
                    .deliveryPhotos
                    .length
                    .toString(),
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              NetworkFilePreviewWidget(
                attachmentModel:
                    track.data.stages.delivered!.deliveryPhotos.first,
              ),
            ],
          ),
        ),
        12.verticalSpace,
      ],
    );
  }

  @override
  Widget buildConfirmation(BuildContext context) {
    if (track.data.stages.orderConfirmation == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SupplierTrackOrderWidget(
          assetName: AppAssets.box,
          iconColor: context.theme.primaryColor,
          title: context.tr.orderConfirmation,
          description: context
              .tr
              .youWillUploadRequiredDocumentsAfterOrderArrivesToMarkPurchaseAsCompleted,
          customSection: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.invoice,
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              3.verticalSpace,
              Text(
                context.tr.varianceOrderIfAny,
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              3.verticalSpace,
              Text(
                context.tr.deliveryNote,
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              3.verticalSpace,
              Text(
                context.tr.receiptWithoutDocs,
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ],
          ),
          showButton: true,
          textButton: context.tr.seeReceiptDetails,
          onClick: () {
            AppBottomSheet.show(
              context,
              (context) => OrderConfirmationDetailsTrackView(
                stage: track.data.stages.orderConfirmation!,
              ),
            );
          },
        ),
        12.verticalSpace,
      ],
    );
  }

  @override
  Widget buildVariance(BuildContext context) {
    if (track.data.stages.varianceLogged == null) {
      return const SizedBox.shrink();
    }

    return SupplierTrackOrderWidget(
      assetName: AppAssets.warning,
      title: context.tr.varianceLogged,
      description: context.tr.supplierMustReviewAndRespond,
      sectionAfterDetails: _sectionAfterDetails(
        context: context,
        text: context.tr.varianceOrderIfAny,
      ),
      showButton: true,
      textButton: context.tr.viewVarianceDetailsAndVerdict,
      onClick: () {
        AppBottomSheet.show(
          context,
          (context) => VarianceDetailsTrackView(
            stage: track.data.stages.varianceLogged!,
          ),
        );
      },
    );
  }
}

final class TrackOrderFailure extends TrackOrderState {
  final ApiFailure failure;

  const TrackOrderFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

Widget _sectionAfterDetails({
  required BuildContext context,
  required String text,
}) {
  return Row(
    children: [
      5.horizontalSpace,
      Icon(Icons.circle, size: 3.r, color: context.customColor.text1),
      5.horizontalSpace,
      Text(
        text,
        style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
      ),
    ],
  );
}
