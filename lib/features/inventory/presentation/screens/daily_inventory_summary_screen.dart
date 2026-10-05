import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/inventory/presentation/screens/inventory_success_screen.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/daily_inventory_type_enum.dart';
import '../../../../core/helpers/shared_preferences_helper.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../data/models/daily_inventory_items_response.dart';
import '../../data/models/daily_inventory_request.dart';
import '../../domain/strategies/inventory_user_type.dart';
import '../cubit/create_inventory/create_inventory_cubit.dart';
import '../cubit/create_inventory/create_inventory_state.dart';

class DailyInventorySummaryScreen extends StatelessWidget {
  final List<DailyInventoryItem> items;
  final InventoryUserType userType;

  const DailyInventorySummaryScreen({
    super.key,
    required this.items,
    required this.userType,
  });

  DailyInventoryRequest _dailyInventoryRequest(BuildContext context) {
    return DailyInventoryRequest(
      assignedToType: DailyInventoryTypeEnum.personal,
      items: items
          .map(
            (item) => DailyInventoryItemRequest(
              itemId: item.itemId,
              quantity:
                  double.tryParse(
                    context
                            .read<ValidationCubit>()
                            .state
                            .fieldsValue['quantity_${item.id}'] ??
                        '0',
                  ) ??
                  0,
              note: context
                  .read<ValidationCubit>()
                  .state
                  .fieldsValue['note_${item.id}'],
            ),
          )
          .toList(),
      inventoryDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      startTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime.parse(
          context
                  .read<ValidationCubit>()
                  .state
                  .fieldsValue['inventory_start_time'] ??
              '',
        ),
      ),
    );
  }

  void _createDailyInventory(BuildContext context) {
    context.read<CreateInventoryCubit>().createDailyInventory(
      id: '',
      request: _dailyInventoryRequest(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.dailyQuickInventory,
            subtitle:
                '${DateFormatter.formatDateMDY(DateTime.now())} | ${getIt<SharedPreferencesHelper>().getString('u_name')} (${context.tr.branch})',
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.dailyInventorySummary,
                              style: AppStyles.s20W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              context.tr.reviewInventoryCountDetails,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                            12.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                color: context.customColor.text2,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              padding: EdgeInsets.all(16.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr.sessionSummary,
                                    style: AppStyles.s16W600.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          context.customColor.reversedTextColor,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    padding: EdgeInsets.all(16.r),
                                    child: Column(
                                      children: [
                                        _buildSessionSummaryRow(
                                          context: context,
                                          title: context.tr.inventoryDate,
                                          asset: AppAssets.calendar,
                                          value: DateFormatter.formatDateMDY(
                                            DateTime.now(),
                                          ),
                                        ),
                                        10.verticalSpace,
                                        BlocSelector<
                                          ValidationCubit,
                                          ValidationState,
                                          String
                                        >(
                                          selector: (state) =>
                                              state
                                                  .fieldsValue['inventory_start_time'] ??
                                              '-',
                                          builder: (context, state) {
                                            return _buildSessionSummaryRow(
                                              context: context,
                                              title: context.tr.startTime,
                                              asset: AppAssets.clockSvg,
                                              value: DateFormatter.formatTimeHM(
                                                DateTime.tryParse(state),
                                              ),
                                            );
                                          },
                                        ),
                                        10.verticalSpace,
                                        BlocSelector<
                                          ValidationCubit,
                                          ValidationState,
                                          String
                                        >(
                                          selector: (state) =>
                                              state
                                                  .fieldsValue['inventory_time_taken'] ??
                                              '0',
                                          builder: (context, state) {
                                            final seconds =
                                                int.tryParse(state) ?? 0;
                                            final formattedTime =
                                                _formatDuration(seconds);
                                            return _buildSessionSummaryRow(
                                              context: context,
                                              title: context.tr.timeTaken,
                                              asset: AppAssets.clockSvg,
                                              value: formattedTime,
                                            );
                                          },
                                        ),

                                        10.verticalSpace,
                                        _buildSessionSummaryRow(
                                          context: context,
                                          title: context.tr.performedBy,
                                          asset: AppAssets.personSvg,
                                          value:
                                              '${getIt<SharedPreferencesHelper>().getString('u_name')} (${context.tr.branchManager})',
                                        ),
                                        10.verticalSpace,
                                        _buildSessionSummaryRow(
                                          context: context,
                                          title: context.tr.completedProducts,
                                          asset: AppAssets.box,
                                          value:
                                              '${items.length}/${items.length} (100%)',
                                          valueColor: AppColors.lightGreen,
                                        ),
                                      ],
                                    ),
                                  ),
                                  10.verticalSpace,
                                  Text(
                                    context.tr.allInventoriedProductsCount(
                                      items.length,
                                    ),
                                    style: AppStyles.s16W600.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                  12.verticalSpace,
                                  ListView.builder(
                                    itemCount: items.length,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final item = items[index];

                                      return Container(
                                        decoration: BoxDecoration(
                                          color: context
                                              .customColor
                                              .reversedTextColor,
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(16.r),
                                        margin: EdgeInsets.only(bottom: 12.r),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const PurchaseItemImage(),
                                                10.horizontalSpace,
                                                Expanded(
                                                  child: Text(
                                                    item.itemName,
                                                    style: AppStyles.s14W500
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text1,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            10.verticalSpace,
                                            const CustomDivider(),
                                            10.verticalSpace,
                                            _buildSessionSummaryRow(
                                              context: context,
                                              title: context.tr.quantity,
                                              customValueWidget: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  BlocSelector<
                                                    ValidationCubit,
                                                    ValidationState,
                                                    String
                                                  >(
                                                    selector: (state) =>
                                                        state
                                                            .fieldsValue['quantity_${item.id}'] ??
                                                        '0',
                                                    builder: (context, state) {
                                                      return Text(
                                                        state,
                                                        style: AppStyles.s13W500
                                                            .copyWith(
                                                              color: context
                                                                  .customColor
                                                                  .text1,
                                                            ),
                                                      );
                                                    },
                                                  ),
                                                  5.horizontalSpace,
                                                  AppGestureDetectorButton(
                                                    onTap: () {
                                                      NavigationService.I.pop();
                                                    },
                                                    child: AppSvg(
                                                      assetName: AppAssets.edit,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                            context
                                                                .theme
                                                                .primaryColor,
                                                            BlendMode.srcIn,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            BlocSelector<
                                              ValidationCubit,
                                              ValidationState,
                                              String?
                                            >(
                                              selector: (state) => state
                                                  .fieldsValue['note_${item.id}'],
                                              builder: (context, state) {
                                                if (state == null ||
                                                    state.isEmpty) {
                                                  return const SizedBox.shrink();
                                                }

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    10.verticalSpace,
                                                    Text(
                                                      context.tr.additionalNote,
                                                      style: AppStyles.s14W600
                                                          .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text3,
                                                          ),
                                                    ),
                                                    5.verticalSpace,
                                                    Text(
                                                      state,
                                                      style: AppStyles.s14W400
                                                          .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text1,
                                                          ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            12.verticalSpace,
                            Text(
                              context.tr.finalCheckpoints,
                              style: AppStyles.s16W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            12.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: context.customColor.border,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.r,
                                vertical: 16.r,
                              ),
                              child: Column(
                                children: [
                                  _buildFinalCheckpointItem(
                                    context: context,
                                    title: context.tr.allProductsInventoried,
                                  ),
                                  10.verticalSpace,
                                  _buildFinalCheckpointItem(
                                    context: context,
                                    title: context
                                        .tr
                                        .quantitiesAccurateAndReviewed,
                                  ),
                                  10.verticalSpace,
                                  _buildFinalCheckpointItem(
                                    context: context,
                                    title: context.tr.noInputErrors,
                                  ),
                                  10.verticalSpace,
                                  _buildFinalCheckpointItem(
                                    context: context,
                                    title: context.tr.specialNotesRecorded,
                                  ),
                                ],
                              ),
                            ),
                            12.verticalSpace,
                            Text(
                              context.tr.nextSteps,
                              style: AppStyles.s16W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            12.verticalSpace,
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: context.customColor.border,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.r,
                                vertical: 16.r,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr.sendDataToAccountant,
                                    style: AppStyles.s13W400.copyWith(
                                      color: context.customColor.text3,
                                    ),
                                  ),
                                  15.verticalSpace,
                                  Text(
                                    context.tr.salesInputFromExternalSystem,
                                    style: AppStyles.s13W400.copyWith(
                                      color: context.customColor.text3,
                                    ),
                                  ),
                                  15.verticalSpace,
                                  Text(
                                    context.tr.discrepancyReportWithinHours,
                                    style: AppStyles.s13W400.copyWith(
                                      color: context.customColor.text3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.verticalSpace,
                    BlocConsumer<CreateInventoryCubit, CreateInventoryState>(
                      listener: (context, state) {
                        if (state is CreateInventorySuccess) {
                          NavigationService.I.popToFirst();

                          AppBottomSheet.customPageRoute(
                            context,
                            (context) => InventorySuccessScreen(
                              title: context.tr.countCompleted,
                              desc: context
                                  .tr
                                  .yourDailyInventoryCountHasBeenSuccessfullySubmitted,
                            ),
                          );
                        } else if (state is CreateInventoryFailure) {
                          AppDialog.showErrorDialog(
                            context: context,
                            failure: state.failure,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is CreateInventoryLoading) {
                          return const AppButtonLoading();
                        }

                        return AppButton(
                          onClick: () => _createDailyInventory(context),
                          text: context.tr.sendData,
                          enabled: true,
                          padding: EdgeInsets.symmetric(vertical: 18.r),
                          borderRadius: BorderRadius.circular(18.r),
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

  Widget _buildSessionSummaryRow({
    required BuildContext context,
    required String title,
    String? asset,
    String? value,
    Widget? customValueWidget,
    Color? valueColor,
  }) {
    return Row(
      children: [
        if (asset != null) ...[
          AppSvg(
            assetName: asset,
            width: 18.r,
            height: 18.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text3,
              BlendMode.srcIn,
            ),
          ),
          8.horizontalSpace,
        ],
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child:
              customValueWidget ??
              Text(
                value ?? '',
                textAlign: TextAlign.end,
                style: AppStyles.s13W500.copyWith(
                  color: valueColor ?? context.customColor.text1,
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildFinalCheckpointItem({
    required BuildContext context,
    required String title,
  }) {
    return Row(
      children: [
        AppCheckBox(
          onChanged: (value) {},
          value: true,
          selectedColor: AppColors.lightGreen,
        ),
        8.horizontalSpace,
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
      ],
    );
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final parts = <String>[];

    if (hours > 0) {
      parts.add('$hours hour${hours == 1 ? '' : 's'}');
    }

    if (minutes > 0) {
      parts.add('$minutes minute${minutes == 1 ? '' : 's'}');
    }

    if (seconds > 0 || parts.isEmpty) {
      parts.add('$seconds second${seconds == 1 ? '' : 's'}');
    }

    return parts.join(' ');
  }
}
