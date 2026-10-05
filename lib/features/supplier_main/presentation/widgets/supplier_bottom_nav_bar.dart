import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';

class SupplierBottomNavBar extends StatelessWidget {
  const SupplierBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 25.r,
        right: 25.r,
        top: 12.r,
        bottom: 20.r,
      ),
      decoration: BoxDecoration(color: context.theme.scaffoldBackgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return InkWell(
            onTap: () => context.read<PagingCubit>().goToStep(index),
            child: BlocSelector<PagingCubit, PagingState, bool>(
              selector: (state) {
                return state.currentIndex == index;
              },
              builder: (context, isSelected) {
                return _buildIcon(
                  context: context,
                  index: index,
                  isSelected: isSelected,
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildIcon({
    required BuildContext context,
    required int index,
    required bool isSelected,
  }) {
    final List<String> icons = [
      AppAssets.requests,
      AppAssets.returnsManagement,
      AppAssets.settings,
    ];

    final List<String> titles = [
      context.tr.requests,
      context.tr.returnsManagement,
      context.tr.settings,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSvg(
          assetName: icons[index],
          colorFilter: ColorFilter.mode(
            isSelected ? context.customColor.text1 : context.customColor.text3,
            BlendMode.srcIn,
          ),
        ),
        5.verticalSpace,
        Text(
          titles[index],
          style: isSelected
              ? AppStyles.s11WB.copyWith(color: context.customColor.text1)
              : AppStyles.s11W400.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
