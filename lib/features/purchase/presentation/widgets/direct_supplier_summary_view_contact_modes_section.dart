import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/enums/purchasing_officer_notification_enum.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../data/models/purchase_create_order_request.dart';

class DirectSupplierSummaryViewContactModesSection extends StatelessWidget {
  final ValueNotifier<Map<int, bool>> selectedNotifiedIndexNotifier;
  final String supplierId;
  final PurchaseCreateOrderRequestDirectSupplier supplier;

  const DirectSupplierSummaryViewContactModesSection({
    super.key,
    required this.selectedNotifiedIndexNotifier,
    required this.supplierId,
    required this.supplier,
  });

  void _validateNotificationOptions(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    final selectedOptions = selectedNotifiedIndexNotifier.value;

    final values = [
      PurchasingOfficerNotificationEnum.email.toString(),
      PurchasingOfficerNotificationEnum.whatsApp.toString(),
      PurchasingOfficerNotificationEnum.pushNotification.toString(),
      PurchasingOfficerNotificationEnum.sms.toString(),
    ];

    for (int index = 0; index < selectedOptions.length; index++) {
      final isSelected = selectedOptions[index] ?? false;

      final fieldName = switch (index) {
        0 => 'email_$supplierId',
        1 => 'whatsapp_$supplierId',
        2 => 'inAppNotification_$supplierId',
        3 => 'sms_$supplierId',
        _ => '',
      };

      final anyOptionSelected = selectedOptions.values.any(
        (isSelected) => isSelected,
      );

      validationCubit.validateField(
        'notificationOptions_$supplierId',
        anyOptionSelected,
      );

      if (isSelected) {
        validationCubit.validateFieldAndStoreValue(
          fieldName: fieldName,
          value: values[index],
          isValid: true,
        );
      } else {
        validationCubit.validateFieldAndStoreValue(
          fieldName: fieldName,
          value: '',
          isValid: false,
        );
      }
    }

    final notificationChannels = <String>[];

    final validationCubitValues = validationCubit.state.fieldsValue;

    final email = validationCubitValues['email_$supplierId'];
    final whatsapp = validationCubitValues['whatsapp_$supplierId'];
    final inAppNotification =
        validationCubitValues['inAppNotification_$supplierId'];
    final sms = validationCubitValues['sms_$supplierId'];

    if (email != null && email.isNotEmpty) {
      notificationChannels.add(
        PurchasingOfficerNotificationEnum.email.toString(),
      );
    }

    if (whatsapp != null && whatsapp.isNotEmpty) {
      notificationChannels.add(
        PurchasingOfficerNotificationEnum.whatsApp.toString(),
      );
    }

    if (inAppNotification != null && inAppNotification.isNotEmpty) {
      notificationChannels.add(
        PurchasingOfficerNotificationEnum.pushNotification.toString(),
      );
    }

    if (sms != null && sms.isNotEmpty) {
      notificationChannels.add(
        PurchasingOfficerNotificationEnum.sms.toString(),
      );
    }

    supplier.updateNotificationChannels(notificationChannels);
  }

  void _onNotifiedOptionTap(BuildContext context, int index) {
    final currentSelection = selectedNotifiedIndexNotifier.value;
    final isSelected = currentSelection[index] ?? false;

    selectedNotifiedIndexNotifier.value = {
      ...currentSelection,
      index: !isSelected,
    };

    _validateNotificationOptions(context);
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.r,
        mainAxisSpacing: 12.r,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return ValueListenableBuilder(
          valueListenable: selectedNotifiedIndexNotifier,
          builder: (context, value, child) {
            final options = [
              context.tr.email,
              context.tr.whatsapp,
              context.tr.inAppNotification,
              context.tr.sms,
            ];

            final descs = [
              '${context.tr.sendDetailedPdfCopy} ',
              '${context.tr.textMessageWithDetailsLink} ',
              context.tr.supplWil,
              context.tr.shortTextMessageQuickAlert,
            ];

            final isSelected = value[index] ?? false;

            return AppGestureDetectorButton(
              onTap: () => _onNotifiedOptionTap(context, index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? context.theme.primaryColor
                        : context.customColor.border,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 12.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.theme.primaryColor
                            : context.customColor.text2,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        Icons.check,
                        size: 10.r,
                        color: context.customColor.reversedTextColor,
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            options[index],
                            softWrap: true,
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          6.verticalSpace,
                          Expanded(
                            child: Text(
                              descs[index],
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: AppStyles.s13W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
