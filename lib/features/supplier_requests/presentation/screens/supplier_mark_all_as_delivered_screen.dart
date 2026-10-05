import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/file_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/media_main_screen.dart';
import '../cubit/supplier_start_track_order/supplier_start_track_order_cubit.dart';
import '../cubit/supplier_start_track_order/supplier_start_track_order_state.dart';
import '../widgets/supplier_order_approved_bottom_sheet.dart';

class SupplierMarkAllAsDeliveredScreen extends StatelessWidget {
  final String orderId;

  const SupplierMarkAllAsDeliveredScreen({super.key, required this.orderId});

  void _openFilePicker(BuildContext context) {
    final mediaCubit = context.read<MediaCubit>();

    NavigationService.I.push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: mediaCubit,
          child: const MediaMainScreen(selectSingleFile: true),
        ),
      ),
    );
  }

  void _supplierMarkOrderDelivered(BuildContext context) {
    final mediaCubit = context.read<MediaCubit>();

    context.read<SupplierStartTrackOrderCubit>().supplierMarkOrderDelivered(
      orderId: orderId,
      body: mediaCubit.allFilesSelected.first.toFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.markAllAsDelivered,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    context
                        .tr
                        .thisActionIsIrreversibleSoPleaseEnsureTheGoodsHave,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  20.verticalSpace,
                  Text(
                    context
                        .tr
                        .toCompleteTheProcessUploadTheFinalInvoiceOrDelivery,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  16.verticalSpace,
                  const CustomDivider(),
                  16.verticalSpace,
                  Row(
                    children: [
                      Text(
                        context.tr.uploadInvoiceReceipt,
                        style: AppStyles.s14W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      5.horizontalSpace,
                      Text(
                        '(Pdf/Png/Jpeg)',
                        style: AppStyles.s14W400.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ],
                  ),
                  5.verticalSpace,
                  BlocSelector<MediaCubit, MediaState, MediaFile?>(
                    selector: (state) {
                      if (state is MediaLoaded) {
                        final file = state.allFiles
                            .cast<MediaFile?>()
                            .firstWhere((f) => f!.selected, orElse: () => null);

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

                      return AppGestureDetectorButton(
                        onTap: () {
                          _openFilePicker(context);
                        },
                        child: ContainerCustomTextField(
                          child: Column(
                            children: [
                              double.infinity.horizontalSpace,
                              AppSvg(assetName: AppAssets.upload, width: 20.r),
                              12.verticalSpace,
                              Text(
                                context.tr.tapToUploadFromDevice,
                                style: AppStyles.s14W400.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              12.verticalSpace,
                              Text(
                                '${context.tr.maxSize}: 5GB',
                                style: AppStyles.s12W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            BlocConsumer<
              SupplierStartTrackOrderCubit,
              SupplierStartTrackOrderState
            >(
              listener: (context, state) {
                if (state is SupplierStartTrackOrderSuccess) {
                  NavigationService.I.popToFirst();

                  AppBottomSheet.customPageRoute(
                    context,
                    (context) => SupplierOrderApprovedBottomSheet(
                      title: context.tr.orderDelivered,
                      titleDesc: context
                          .tr
                          .youHaveSuccessfullyMarkedOrderAsDeliveredHasBeenNotified,
                      customStatus: Text(
                        context.tr.orderConfirmation,
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      description: context
                          .tr
                          .afterDeliveryIsCompleteTheRequesterMustConfirmReceiptOf,
                      assetName: AppAssets.box,
                      iconColor: context.theme.primaryColor,
                    ),
                  );
                } else if (state is SupplierStartTrackOrderFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is SupplierStartTrackOrderLoading) {
                  return const AppButtonLoading();
                }

                return BlocSelector<ValidationCubit, ValidationState, bool>(
                  selector: (state) => state.enableButton,
                  builder: (context, state) {
                    return AppButton(
                      onClick: () {
                        _supplierMarkOrderDelivered(context);
                      },
                      text: context.tr.updateStatus,
                      enabled: state,
                      background: state
                          ? AppColors.lightGreen
                          : context.customColor.text2,
                      borderRadius: BorderRadius.circular(12.r),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
