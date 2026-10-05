import 'dart:io';

import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/cubits/media/media_state.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/file_preview_widget.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_start_track_order/supplier_start_track_order_state.dart';
import 'package:assab/features/supplier_requests/presentation/widgets/supplier_item_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/media_main_screen.dart';
import '../../data/models/supplier_orders_response.dart';
import '../../data/models/supplier_preparing_request.dart';
import '../cubit/supplier_start_track_order/supplier_start_track_order_cubit.dart';
import '../widgets/supplier_order_approved_bottom_sheet.dart';

class SupplierMarkAllAsPreparingScreen extends StatefulWidget {
  final String orderId;
  final List<SupplierOrderItem> items;

  const SupplierMarkAllAsPreparingScreen({
    super.key,
    required this.items,
    required this.orderId,
  });

  @override
  State<SupplierMarkAllAsPreparingScreen> createState() =>
      _SupplierMarkAllAsPreparingScreenState();
}

class _SupplierMarkAllAsPreparingScreenState
    extends State<SupplierMarkAllAsPreparingScreen> {
  final Map<String, File> _selectedFiles = {};

  @override
  void initState() {
    super.initState();

    _addDynamicValidationKey();
  }

  void _addDynamicValidationKey() {
    for (int i = 0; i < widget.items.length; i++) {
      context.read<ValidationCubit>().addDynamicFields({'file_${i + 1}'});
    }
  }

  void _openFilePicker(BuildContext context, MediaCubit mediaCubit) {
    NavigationService.I.push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: mediaCubit,
          child: const MediaMainScreen(selectSingleFile: true),
        ),
      ),
    );
  }

  void _supplierStartPreparingOrder(SupplierPreparingRequest body) {
    context.read<SupplierStartTrackOrderCubit>().supplierStartPreparingOrder(
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          AppPaddingWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.markAllAsPreparing,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                ),
                Text(
                  context.tr.orderWasJustApprovedProceedToMarkAsPreparing,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: AppPaddingWidget(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 63.h,
                          width: 4.w,
                          color: context.theme.primaryColor,
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: Text(
                            context
                                .tr
                                .toProceedPleaseUploadTheQualityCertificateToEnsureTransparency,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    32.verticalSpace,
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.items.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return BlocProvider(
                            create: (_) => getIt<MediaCubit>(),
                            child: Builder(
                              builder: (mediaContext) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: Border.all(
                                      color: context.customColor.border,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.r,
                                    vertical: 12.r,
                                  ),
                                  margin: EdgeInsets.only(bottom: 12.r),
                                  child: AppGestureDetectorButton(
                                    onTap: () {
                                      _openFilePicker(
                                        mediaContext,
                                        mediaContext.read<MediaCubit>(),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        SupplierItemPreviewWidget(
                                          itemName:
                                              widget.items[index].productName,
                                          bgColor: Colors.transparent,
                                        ),
                                        BlocSelector<
                                          MediaCubit,
                                          MediaState,
                                          MediaFile?
                                        >(
                                          selector: (state) {
                                            if (state is MediaLoaded) {
                                              final file = state.allFiles
                                                  .cast<MediaFile?>()
                                                  .firstWhere(
                                                    (f) => f!.selected,
                                                    orElse: () => null,
                                                  );

                                              if (file != null &&
                                                  _selectedFiles[widget
                                                          .items[index]
                                                          .id] ==
                                                      null) {
                                                _selectedFiles[widget
                                                        .items[index]
                                                        .id] =
                                                    file.toFile;
                                              } else if (file == null &&
                                                  _selectedFiles.length >
                                                      index) {
                                                _selectedFiles.remove(
                                                  widget.items[index].id,
                                                );
                                              }

                                              context
                                                  .read<ValidationCubit>()
                                                  .validateField(
                                                    'file_${index + 1}',
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
                                                  mediaContext
                                                      .read<MediaCubit>()
                                                      .unselectFile(state);
                                                },
                                                icon: AppAssets.trashSvg,
                                              );
                                            }

                                            return ContainerCustomTextField(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      context
                                                          .tr
                                                          .clickToUploadFile,
                                                      style: AppStyles.s12W400
                                                          .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text3,
                                                          ),
                                                    ),
                                                  ),
                                                  5.horizontalSpace,
                                                  AppSvg(
                                                    assetName: AppAssets.upload,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                          context
                                                              .theme
                                                              .primaryColor,
                                                          BlendMode.srcIn,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
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
                              title: context.tr.orderStatusUpdated,
                              titleDesc: context
                                  .tr
                                  .youHaveSuccessfullyMarkedOrderAsPreparing,
                              oldStatus: context.tr.preparing,
                              newStatus: context.tr.outForDelivery,
                              description: context
                                  .tr
                                  .addDeliveryDetailsBeforeDispatching,
                              assetName: AppAssets.transportDelivery,
                              iconColor: AppColors.orange,
                              dot1: context.tr.driverName,
                              dot2: context.tr.vehicleInformation,
                              dot3: context.tr.expectedDeliveryTime,
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

                        return Row(
                          children: [
                            Expanded(
                              child: CustomTextButton(
                                text: context.tr.cancel,
                                onTap: () {
                                  NavigationService.I.pop();
                                },
                                padding: EdgeInsets.symmetric(vertical: 18.r),
                                borderRadius: 15.r,
                                textColor: context.customColor.text1,
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child:
                                  BlocSelector<
                                    ValidationCubit,
                                    ValidationState,
                                    bool
                                  >(
                                    selector: (state) => state.enableButton,
                                    builder: (context, state) {
                                      return AppButton(
                                        onClick: () {
                                          _supplierStartPreparingOrder(
                                            SupplierPreparingRequest(
                                              orderId: widget.orderId,
                                              items: widget.items.map((item) {
                                                final file =
                                                    _selectedFiles[item.id]!;

                                                return SupplierPreparingItem(
                                                  id: item.id,
                                                  file: file,
                                                );
                                              }).toList(),
                                            ),
                                          );
                                        },
                                        text: context.tr.updateStatus,
                                        enabled: state,
                                        background: state
                                            ? context.customColor.dark
                                            : context.customColor.text2,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 18.r,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
