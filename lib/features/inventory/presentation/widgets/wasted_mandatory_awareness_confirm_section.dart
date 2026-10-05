import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_check_box.dart';
import '../../domain/strategies/inventory_user_type.dart';

class WastedMandatoryAwarenessConfirmSection extends StatefulWidget {
  final InventoryUserType userType;

  const WastedMandatoryAwarenessConfirmSection({
    super.key,
    required this.userType,
  });

  @override
  State<WastedMandatoryAwarenessConfirmSection> createState() =>
      _WastedMandatoryAwarenessConfirmSectionState();
}

class _WastedMandatoryAwarenessConfirmSectionState
    extends State<WastedMandatoryAwarenessConfirmSection> {
  late final ValueNotifier<bool> _valueNotifier;

  @override
  void initState() {
    super.initState();

    _valueNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _valueNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: context.customColor.border),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 12.r),
          child: Row(
            children: [
              ValueListenableBuilder(
                valueListenable: _valueNotifier,
                builder: (context, value, child) {
                  return AppCheckBox(
                    onChanged: (value) {
                      _valueNotifier.value = value;
                    },
                    value: value,
                  );
                },
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  context.tr.iConfirmIUnderstandTheDifferenceAndCanDistinguish,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text4,
                  ),
                ),
              ),
            ],
          ),
        ),
        15.verticalSpace,
        Row(
          spacing: 12.w,
          children: [
            Expanded(
              child: CustomTextButton(
                text: context.tr.back,
                onTap: () {
                  NavigationService.I.pop();
                },
                padding: EdgeInsets.symmetric(vertical: 18.r),
                textColor: context.customColor.text1,
                borderRadius: 20.r,
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _valueNotifier,
                builder: (context, value, child) {
                  return AppButton(
                    onClick: () {
                      NavigationService.I.pushNamed(
                        AppRouteName.wastedRegesterProductesScreen,
                        arguments: widget.userType,
                      );
                    },
                    text: context.tr.startRegistration,
                    enabled: value,
                    borderRadius: BorderRadius.circular(20.r),
                    padding: EdgeInsets.symmetric(vertical: 18.r),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
