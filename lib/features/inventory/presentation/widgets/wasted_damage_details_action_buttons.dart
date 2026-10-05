import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../presentation/screens/wasted_regester_productes_screen.dart';
import '../cubit/wasted_selected_items/wasted_selected_items_cubit.dart';

class WastedDamageDetailsActionButtons extends StatelessWidget {
  final String? itemId;

  const WastedDamageDetailsActionButtons({super.key, this.itemId});

  void _handleRemoveItem(BuildContext context) {
    if (itemId != null) {
      // Clean up validation fields for this item first.
      WastedRegesterProductesScreen.removeItemFields(
        context.read<ValidationCubit>(),
        itemId!,
      );
      context.read<WastedSelectedItemsCubit>().removeItem(itemId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonTextIcon(
              onTap: () => _handleRemoveItem(context),
              label: context.tr.removeItemFromList,
              icon: AppSvg(assetName: AppAssets.trashSvg, width: 12.r),
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
              borderRadius: BorderRadius.circular(10.r),
              backgroundColor: context.customColor.reversedTextColor,
              borderColor: Colors.transparent,
            ),
          ],
        ),
      ],
    );
  }
}
