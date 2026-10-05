import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/widgets/app_back_button.dart';
import '../../logic/cashier/cashier_filter/cashier_filter_cubit.dart';
import '../../logic/cashier/cashier_management_cubit.dart';
import 'cashier_filter_bottom_sheet.dart';

class ShiftManagementAppBar extends StatelessWidget {
  const ShiftManagementAppBar({
    super.key,
    required this.onSearch,
    required this.searchController,
  });

  final Function(String) onSearch;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: 10.w,
            vertical: 5.h,
          ),
          child: Row(
            children: [
              AppBackButton(
                isTransparent: true,
                iconColor: context.customColor.text1,
              ),

              BlocSelector<CashierManagementCubit, CashierManagementState, Map>(
                selector: (state) {
                  if (state is CashierManagementSuccess) {
                    return {
                      'length': state.cashiers.length,
                      'branchName': state.cashiers[0].branch.name,
                    };
                  }
                  return {'length': 0, 'branchName': context.tr.noStore};
                },
                builder: (context, map) {
                  return Flexible(
                    child: ListTile(
                      title: Text(
                        context.tr.cashierList(map['length']),
                        style: context.theme.textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        context.tr.cashiersInStore(map['branchName']),
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ),
                  );
                },
              ),

              AppGestureDetectorButton(
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    AppRouteName.addCashierScreen,
                    arguments: context.read<CashierManagementCubit>(),
                  );
                },
                child: Container(
                  // width: 100.w,
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: context.customColor.reversedTextColor,
                        size: 15.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        context.tr.add,
                        style: AppStyles.s13W400.copyWith(
                          color: context.customColor.reversedTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          decoration: BoxDecoration(color: context.customColor.text2),
          padding: EdgeInsets.symmetric(vertical: 18.r, horizontal: 16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.search_sharp, size: 20.w),
              SizedBox(width: 10.w),

              Expanded(
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: searchController,
                  builder: (context, value, _) {
                    return CustomTextField(
                      controller: searchController,
                      hintText: context.tr.searchByCashierName,
                      maxLength: 30,
                      onChanged: onSearch,
                    );
                  },
                ),
              ),

              InkWell(
                child: AppSvg(
                  assetName: AppAssets.filter,
                  width: 16.w,
                  height: 16.h,
                ),
                onTap: () => AppBottomSheet.show(
                  context,
                  (context) => BlocProvider(
                    create: (context) => CashierFilterCubit(),
                    child: const CashierFilterBottomSheetWidget(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
