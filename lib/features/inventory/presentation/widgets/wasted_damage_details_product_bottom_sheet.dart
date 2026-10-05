import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/strategies/wasted_problem_type_strategy.dart';
import 'wasted_damage_details_product_info_section.dart';
import 'wasted_damage_details_problem_type_section.dart';
import 'wasted_damage_details_affected_product_section.dart';
import 'wasted_damage_details_justification_section.dart';
import 'wasted_damage_details_action_buttons.dart';

class WastedDamageDetailsProductBottomSheet extends StatelessWidget {
  const WastedDamageDetailsProductBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          10.verticalSpace,
          PurchaseAppBar(
            title: context.tr.wasteDamageDetailsColon,
            subtitle: context.tr.completeTheRequiredFieldsBelow,
            titleColor: context.customColor.text1,
            iconColor: context.customColor.text1,
            paddingBottom: 0,
          ),
          12.verticalSpace,
          Expanded(
            child: AppPaddingWidget(
              top: 0,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.r,
                        vertical: 12.r,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const WastedDamageDetailsProductInfoSection(),
                            16.verticalSpace,
                            Row(
                              spacing: 8.w,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppSvg(assetName: AppAssets.box, width: 16.r),
                                Text(
                                  context.tr.wasteDamageDetailsColon,
                                  style: AppStyles.s14W600.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ],
                            ),
                            16.verticalSpace,
                            const WastedDamageDetailsProblemTypeSection(
                              itemId: '',
                            ),
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              WastedProblemTypeStrategy?
                            >(
                              selector: (state) => state
                                  .getTypedValue<WastedProblemTypeStrategy>(
                                    'problemType',
                                  ),
                              builder: (context, state) {
                                return state?.buildDetailsSection(context) ??
                                    const SizedBox.shrink();
                              },
                            ),
                            8.verticalSpace,
                            const WastedDamageDetailsAffectedProductSection(),
                            8.verticalSpace,
                            const WastedDamageDetailsJustificationSection(),
                            8.verticalSpace,
                            const WastedDamageDetailsActionButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  BlocSelector<ValidationCubit, ValidationState, bool>(
                    selector: (state) => state.enableButton,
                    builder: (context, state) {
                      return AppButton(
                        onClick: () {},
                        text: context.tr.addToList,
                        enabled: state,
                        borderRadius: BorderRadius.circular(15.r),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
