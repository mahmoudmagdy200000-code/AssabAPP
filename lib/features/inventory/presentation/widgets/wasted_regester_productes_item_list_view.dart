import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../data/models/wasted_damage_items_response.dart';
import '../../domain/strategies/wasted_problem_type_strategy.dart';
import 'wasted_damage_details_action_buttons.dart';
import 'wasted_damage_details_affected_product_section.dart';
import 'wasted_damage_details_justification_section.dart';
import 'wasted_damage_details_problem_type_section.dart';
import 'wasted_damage_details_product_info_section.dart';

class WastedRegesterProductesItemListView extends StatelessWidget {
  final WastedDamageItemData item;

  const WastedRegesterProductesItemListView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WastedDamageDetailsProductInfoSection(item: item),
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
        WastedDamageDetailsProblemTypeSection(itemId: item.id),
        BlocSelector<
          ValidationCubit,
          ValidationState,
          WastedProblemTypeStrategy?
        >(
          selector: (state) => state.getTypedValue<WastedProblemTypeStrategy>(
            'problemType_${item.id}',
          ),
          builder: (context, state) {
            return state?.buildDetailsSection(
                  context,
                  itemId: item.id,
                  item: item,
                ) ??
                const SizedBox.shrink();
          },
        ),
        8.verticalSpace,
        WastedDamageDetailsAffectedProductSection(item: item, itemId: item.id),
        8.verticalSpace,
        WastedDamageDetailsJustificationSection(itemId: item.id),
        8.verticalSpace,
        WastedDamageDetailsActionButtons(itemId: item.id),
      ],
    );
  }
}
