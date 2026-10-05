import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/recurring_order_activate_period_end_date_enum.dart';
import '../../../../core/enums/recurring_order_notifications_enum.dart';
import '../../../../core/enums/recurring_order_smart_settings_enum.dart';
import '../../../../core/enums/time_of_day_enum.dart';
import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../purchase/data/models/purchase_create_order_request.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/create_recurring_order_request.dart';
import '../../domain/strategies/repeat_frequency_strategy.dart';
import '../cubit/create_recurring_order/create_recurring_order_cubit.dart';
import '../cubit/create_recurring_order/create_recurring_order_state.dart';

class RecurringOrderSettingSummaryScreen extends StatelessWidget {
  final PurchaseCreateOrderRequest createOrderRequest;
  final PurchaseSourceStrategy source;
  final int sourceIndex;

  const RecurringOrderSettingSummaryScreen({
    super.key,
    required this.createOrderRequest,
    required this.source,
    required this.sourceIndex,
  });

  List get _items => (source is DirectSupplierPurchaseSourceStrategy)
      ? createOrderRequest.directSupplier[sourceIndex].items
      : (source is OfficerPurchaseSourceStrategy)
      ? createOrderRequest.purchaseOfficer[sourceIndex].items
      : [];

  void _onSaveAndActivate(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    final strategy = validationCubit.getTypedValue<RepeatFrequencyStrategy>(
      'repeatFrequencyType',
    );

    final notifications = validationCubit
        .getListValue<RecurringOrderNotificationsEnum>('notifications');

    final smartSettingsList = validationCubit
        .getListValue<RecurringOrderSmartSettingsEnum>('smartSettings');

    final startDate = validationCubit.getTypedValue<String>('startDate');

    final endDateType = validationCubit
        .getTypedValue<RecurringOrderActivatePeriodEndDateEnum>('endDateType');

    final endDate = validationCubit.getTypedValue<String>('endDate');

    final timeOfDay = validationCubit.getTypedValue<TimeOfDayEnum>('timeOfDay');
    final hour = validationCubit.getTypedValue<String>('hour');
    final minute = validationCubit.getTypedValue<String>('minute');

    String? schedulingTime;
    String? meridiem;

    if (hour != null && minute != null && timeOfDay != null) {
      final formattedHour = hour.padLeft(2, '0');
      final formattedMinute = minute.padLeft(2, '0');

      schedulingTime = '$formattedHour:$formattedMinute:00';
      meridiem = timeOfDay.name;
    }

    CreateRecurringOrderRequestDirectSupplier? directSupplier;
    CreateRecurringOrderRequestPurchaseOfficer? purchaseOfficer;

    if (source is DirectSupplierPurchaseSourceStrategy) {
      final sourceData = createOrderRequest.directSupplier[sourceIndex];
      directSupplier = CreateRecurringOrderRequestDirectSupplier(
        supplierId: sourceData.supplierId,
        notificationChannels: sourceData.notificationChannels,
        message: sourceData.message,
        items: sourceData.items
            .map(
              (e) => CreateRecurringOrderRequestDirectSupplierItem(
                itemId: e.itemId,
                quantity: e.quantity,
                quality: e.quality,
              ),
            )
            .toList(),
      );
    } else if (source is OfficerPurchaseSourceStrategy) {
      final sourceData = createOrderRequest.purchaseOfficer[sourceIndex];
      purchaseOfficer = CreateRecurringOrderRequestPurchaseOfficer(
        items: sourceData.items
            .map(
              (e) => CreateRecurringOrderRequestPurchaseOfficerItem(
                itemId: e.itemId,
                quantity: e.quantity,
                quality: e.quality,
                preferredDeliveryDate: e.preferredDeliveryDate,
                latestDeliveryDate: e.latestDeliveryDate,
                specialInstructions: e.specialInstructions,
              ),
            )
            .toList(),
      );
    }

    final request = CreateRecurringOrderRequest(
      directSupplier: directSupplier,
      purchaseOfficer: purchaseOfficer,
      repeatFrequency: strategy?.getRepeatFrequencyValue,
      repeatConfig: strategy?.buildRepeatConfig(validationCubit),
      schedulingTime: schedulingTime,
      meridiem: meridiem,
      notificationOptions: notifications?.map((e) => e.value).toList(),
      smartSettings: smartSettingsList?.map((e) => e.value).toList(),
      startDate: startDate,
      endDate: endDate,
      endType: endDateType?.value,
    );

    context.read<CreateRecurringOrderCubit>().createRecurringOrder(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.reviewScheduleSummary,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    Text(
                      context
                          .tr
                          .reviewTheOrderScheduleDetailsBeforeActivatingYouCanEditPauseOrDeleteItLater,
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
                          Row(
                            spacing: 12.w,
                            children: [
                              Expanded(
                                child: Text(
                                  context.tr.inspectionSummary,
                                  style: AppStyles.s16W600.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                              AppSvgButton(
                                assetName: AppAssets.edit,
                                onTap: () {
                                  NavigationService.I.pop();
                                },
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: context.customColor.reversedTextColor,
                            ),
                            padding: EdgeInsets.all(16.r),
                            child: Column(
                              children: [
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  RepeatFrequencyStrategy?
                                >(
                                  selector: (state) => state
                                      .getTypedValue<RepeatFrequencyStrategy>(
                                        'repeatFrequencyType',
                                      ),
                                  builder: (context, state) {
                                    return _buildRowDetails(
                                      context: context,
                                      title: context.tr.orderName,
                                      value:
                                          state?.getDisplayValue(context) ??
                                          context.tr.weeklyDairyOrder,
                                    );
                                  },
                                ),
                                8.verticalSpace,
                                const CustomDivider(),
                                8.verticalSpace,
                                _buildRowDetails(
                                  context: context,
                                  title: context.tr.supplier,
                                  value: source.getName(context),
                                ),
                                8.verticalSpace,
                                const CustomDivider(),
                                8.verticalSpace,
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  String?
                                >(
                                  selector: (state) =>
                                      state.getTypedValue<String>('startDate'),
                                  builder: (context, state) {
                                    return _buildRowDetails(
                                      context: context,
                                      title: context.tr.startDate,
                                      value:
                                          DateFormatter.formatDateMDY(
                                            DateTime.tryParse(state ?? ''),
                                          ) ??
                                          'N/A',
                                    );
                                  },
                                ),
                                8.verticalSpace,
                                const CustomDivider(),
                                8.verticalSpace,
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  Map<String, dynamic>?
                                >(
                                  selector: (state) {
                                    final timeOfDay = state
                                        .getTypedValue<TimeOfDayEnum>(
                                          'timeOfDay',
                                        );
                                    final hour = state.getTypedValue<String>(
                                      'hour',
                                    );
                                    final minute = state.getTypedValue<String>(
                                      'minute',
                                    );

                                    if (timeOfDay == null ||
                                        hour == null ||
                                        minute == null) {
                                      return null;
                                    }

                                    return {
                                      'timeOfDay': timeOfDay.label(context),
                                      'hour': hour,
                                      'minute': minute,
                                    };
                                  },
                                  builder: (context, state) {
                                    if (state == null) {
                                      return const SizedBox.shrink();
                                    }

                                    return Column(
                                      children: [
                                        _buildRowDetails(
                                          context: context,
                                          title: context.tr.scheduleTime,
                                          value:
                                              '${state['hour']}:${state['minute']} ${state['timeOfDay']}',
                                        ),
                                        8.verticalSpace,
                                        const CustomDivider(),
                                        8.verticalSpace,
                                      ],
                                    );
                                  },
                                ),
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  RecurringOrderActivatePeriodEndDateEnum?
                                >(
                                  selector: (state) =>
                                      state.getTypedValue<
                                        RecurringOrderActivatePeriodEndDateEnum
                                      >('endDateType'),
                                  builder: (context, state) {
                                    return _buildRowDetails(
                                      context: context,
                                      title: context.tr.endDate,
                                      value: state != null
                                          ? state ==
                                                    RecurringOrderActivatePeriodEndDateEnum
                                                        .open
                                                ? context
                                                      .tr
                                                      .openRepeatsUntilYouEndIt
                                                : (DateFormatter.formatDateMDY(
                                                        DateTime.tryParse(
                                                          context
                                                                  .read<
                                                                    ValidationCubit
                                                                  >()
                                                                  .getTypedValue<
                                                                    String
                                                                  >(
                                                                    'endDate',
                                                                  ) ??
                                                              ' ',
                                                        ),
                                                      ) ??
                                                      'N/A')
                                          : 'N/A',
                                    );
                                  },
                                ),
                                8.verticalSpace,
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  RepeatFrequencyStrategy?
                                >(
                                  selector: (state) => state
                                      .getTypedValue<RepeatFrequencyStrategy>(
                                        'repeatFrequencyType',
                                      ),
                                  builder: (context, state) {
                                    if (state == null) {
                                      return const SizedBox.shrink();
                                    }

                                    return state.buildRepeatModeWidget(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          10.verticalSpace,
                          Text(
                            context.tr.itemsAndQuantities(_items.length),
                            style: AppStyles.s16W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          10.verticalSpace,
                          ListView.builder(
                            itemCount: _items.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              if (source
                                  is DirectSupplierPurchaseSourceStrategy) {
                                final items = createOrderRequest
                                    .directSupplier[sourceIndex]
                                    .items;

                                return _buildItemWidget(
                                  context: context,
                                  itemImage: items[index].itemImage,
                                  itemName: items[index].itemName,
                                  itemQuantity:
                                      '${items[index].quantity} ${items[index].itemUnit}',
                                  itemUnitPrice: items[index].itemPrice,
                                  itemQuality: items[index].quality,
                                );
                              } else if (source
                                  is OfficerPurchaseSourceStrategy) {
                                final items = createOrderRequest
                                    .purchaseOfficer[sourceIndex]
                                    .items;

                                return _buildItemWidget(
                                  context: context,
                                  itemImage: items[index].itemImage,
                                  itemName: items[index].itemName,
                                  itemQuantity:
                                      '${items[index].quantity} ${items[index].itemUnit}',
                                  itemUnitPrice: items[index].itemPrice,
                                  itemQuality: items[index].quality,
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                        ],
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
                          Row(
                            spacing: 12.w,
                            children: [
                              Expanded(
                                child: Text(
                                  context.tr.scheduleSettings,
                                  style: AppStyles.s16W600.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                              AppSvgButton(
                                assetName: AppAssets.edit,
                                onTap: () {
                                  NavigationService.I.pop();
                                },
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: context.customColor.reversedTextColor,
                            ),
                            padding: EdgeInsets.all(16.r),
                            child: Column(
                              children: [
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  RepeatFrequencyStrategy?
                                >(
                                  selector: (state) => state
                                      .getTypedValue<RepeatFrequencyStrategy>(
                                        'repeatFrequencyType',
                                      ),
                                  builder: (context, state) {
                                    return _buildRowDetails(
                                      context: context,
                                      title: context.tr.repeatFrequency,
                                      value:
                                          state?.getDisplayValue(context) ??
                                          '-',
                                    );
                                  },
                                ),
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  RepeatFrequencyStrategy?
                                >(
                                  selector: (state) => state
                                      .getTypedValue<RepeatFrequencyStrategy>(
                                        'repeatFrequencyType',
                                      ),
                                  builder: (context, state) {
                                    if (state == null) {
                                      return const SizedBox.shrink();
                                    }

                                    return Column(
                                      children: [
                                        8.verticalSpace,
                                        const CustomDivider(),
                                        8.verticalSpace,
                                        state.buildScheduleSettingsForSummary(
                                          context,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                8.verticalSpace,
                                const CustomDivider(),
                                8.verticalSpace,
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  List<RecurringOrderNotificationsEnum>
                                >(
                                  selector: (state) =>
                                      state.getListValue<
                                        RecurringOrderNotificationsEnum
                                      >('notifications') ??
                                      [],
                                  builder: (context, state) {
                                    return _buildRowDetails(
                                      context: context,
                                      title: context.tr.notifications,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      customValue: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: state.isNotEmpty
                                            ? state
                                                  .map(
                                                    (e) => _buildColumnWidget(
                                                      context: context,
                                                      text:
                                                          '${e.label(context)} -',
                                                    ),
                                                  )
                                                  .toList()
                                            : [
                                                _buildColumnWidget(
                                                  context: context,
                                                  text: '-',
                                                ),
                                              ],
                                      ),
                                    );
                                  },
                                ),
                                8.verticalSpace,
                                const CustomDivider(),
                                8.verticalSpace,
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  List<RecurringOrderSmartSettingsEnum>
                                >(
                                  selector: (state) =>
                                      state.getListValue<
                                        RecurringOrderSmartSettingsEnum
                                      >('smartSettings') ??
                                      [],
                                  builder: (context, state) {
                                    return _buildRowDetails(
                                      context: context,
                                      title: context.tr.smartSettings,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      customValue: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: state.isNotEmpty
                                            ? state
                                                  .map(
                                                    (e) => _buildColumnWidget(
                                                      context: context,
                                                      text:
                                                          '${e.label(context)} -',
                                                    ),
                                                  )
                                                  .toList()
                                            : [
                                                _buildColumnWidget(
                                                  context: context,
                                                  text: '-',
                                                ),
                                              ],
                                      ),
                                    );
                                  },
                                ),
                              ],
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
            BlocConsumer<CreateRecurringOrderCubit, CreateRecurringOrderState>(
              listener: (context, state) {
                if (state is CreateRecurringOrderSuccess) {
                  NavigationService.I.pop();
                  NavigationService.I.pop();

                  NavigationService.I.pushNamed(
                    AppRouteName.recurringOrderCreatedSuccessfullyScreen,
                  );
                } else if (state is CreateRecurringOrderFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is CreateRecurringOrderLoading) {
                  return const AppButtonLoading();
                }

                return CustomTextButton(
                  text: context.tr.saveAndActivate,
                  onTap: () {
                    _onSaveAndActivate(context);
                  },
                  padding: EdgeInsets.symmetric(vertical: 19.r),
                  backgroundColor: context.theme.primaryColor,
                  textColor: context.customColor.reversedTextColor,
                  borderRadius: 20.r,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Text _buildColumnWidget({
    required BuildContext context,
    required String text,
  }) {
    return Text(
      text,
      style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
      textAlign: TextAlign.end,
    );
  }

  Widget _buildRowDetails({
    required BuildContext context,
    required String title,
    String? value,
    bool isCurrency = false,
    Widget? customValue,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Expanded(
          child:
              customValue ??
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isCurrency) const SaudiRiyalSvgWidget(),
                  3.horizontalSpace,
                  Flexible(
                    child: Text(
                      value ?? '',
                      style: AppStyles.s13W500.copyWith(
                        color: context.customColor.text1,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
        ),
      ],
    );
  }

  Widget _buildItemWidget({
    required BuildContext context,
    required String? itemImage,
    required String itemName,
    required String itemQuantity,
    required String itemUnitPrice,
    required String itemQuality,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: context.customColor.reversedTextColor,
      ),
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(bottom: 6.r),
      child: Column(
        children: [
          Row(
            children: [
              PurchaseItemImage(image: itemImage),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  itemName,
                  style: AppStyles.s14W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRowDetails(
            context: context,
            title: context.tr.qtyOrdered,
            value: itemQuantity,
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRowDetails(
            context: context,
            title: context.tr.unitPrice,
            value: itemUnitPrice,
            isCurrency: true,
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRowDetails(
            context: context,
            title: context.tr.quality,
            value: itemQuality,
          ),
        ],
      ),
    );
  }
}
