import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/recurring_order_notifications_enum.dart';
import '../../../../core/widgets/label_text_field.dart';
import 'recurring_order_setting_choose_item_widget.dart';

class RecurringOrderSettingNotificationsWidget extends StatefulWidget {
  const RecurringOrderSettingNotificationsWidget({super.key});

  @override
  State<RecurringOrderSettingNotificationsWidget> createState() =>
      _RecurringOrderSettingNotificationsWidgetState();
}

class _RecurringOrderSettingNotificationsWidgetState
    extends State<RecurringOrderSettingNotificationsWidget> {
  late final ValueNotifier<Set<RecurringOrderNotificationsEnum>>
  _selectedNotifications;

  @override
  void initState() {
    super.initState();

    final existing = context
        .read<ValidationCubit>()
        .getListValue<RecurringOrderNotificationsEnum>('notifications');
    _selectedNotifications =
        ValueNotifier<Set<RecurringOrderNotificationsEnum>>(
          existing != null ? existing.toSet() : {},
        );

    _selectedNotifications.addListener(() {
      context
          .read<ValidationCubit>()
          .validateFieldAndStoreList<RecurringOrderNotificationsEnum>(
            fieldName: 'notifications',
            value: _selectedNotifications.value.toList(),
            isValid: _selectedNotifications.value.isNotEmpty,
          );
    });
  }

  @override
  void dispose() {
    _selectedNotifications.dispose();
    super.dispose();
  }

  List<RecurringOrderNotificationsEnum> get _notificationsList => [
    RecurringOrderNotificationsEnum.alert24HoursBefore,
    RecurringOrderNotificationsEnum.reviewBeforeSending,
    RecurringOrderNotificationsEnum.sendAutomaticallyWithoutReview,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        spacing: 8.h,
        children: [
          LabelTextField(text: context.tr.notifications),
          ...List.generate(_notificationsList.length, (index) {
            return ValueListenableBuilder<Set<RecurringOrderNotificationsEnum>>(
              valueListenable: _selectedNotifications,
              builder: (context, selected, child) {
                return RecurringOrderSettingChooseItemWidget(
                  text: _notificationsList[index].label(context),
                  onTap: () {
                    final newSelected =
                        Set<RecurringOrderNotificationsEnum>.from(selected);

                    if (newSelected.contains(_notificationsList[index])) {
                      newSelected.remove(_notificationsList[index]);
                    } else {
                      newSelected.add(_notificationsList[index]);

                      if (index == 1 &&
                          newSelected.contains(_notificationsList[2])) {
                        newSelected.remove(_notificationsList[2]);
                      }

                      if (index == 2 &&
                          newSelected.contains(_notificationsList[1])) {
                        newSelected.remove(_notificationsList[1]);
                      }
                    }

                    _selectedNotifications.value = newSelected;
                  },
                  isSelected: selected.contains(_notificationsList[index]),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
