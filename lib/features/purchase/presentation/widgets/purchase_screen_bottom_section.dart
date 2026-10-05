import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../cubit/add_item_purchase/add_item_purchase_cubit.dart';
import '../cubit/add_item_purchase/add_item_purchase_state.dart';

class PurchaseScreenBottomSection extends StatelessWidget {
  const PurchaseScreenBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.watch<AddItemPurchaseCubit>().totalItemsInCart} ${context.tr.itemsAdded}',
                style: AppStyles.s16W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              BlocBuilder<AddItemPurchaseCubit, AddItemPurchaseState>(
                builder: (context, state) {
                  if (!state.items.values.any((quantity) => quantity > 0)) {
                    return const SizedBox.shrink();
                  }

                  double totalPrice = 0;

                  state.items.forEach((item, quantity) {
                    totalPrice += item.itemPrice * quantity;
                  });

                  return Column(
                    children: [
                      4.verticalSpace,
                      Row(
                        children: [
                          Text(
                            '${context.tr.total} =',
                            style: AppStyles.s13W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          SaudiRiyalSvgWidget(
                            color: context.customColor.text3,
                            size: 14.r,
                          ),
                          Text(
                            totalPrice.toString(),
                            style: AppStyles.s13W600.copyWith(
                              color: context.theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocSelector<ValidationCubit, ValidationState, bool>(
            selector: (state) => state.enableButton,
            builder: (context, state) {
              return AppButton(
                onClick: () {
                  // final addItemPurchaseCubit = context
                  //     .read<AddItemPurchaseCubit>();

                  // NavigationService.I.push(
                  //   MaterialPageRoute(
                  //     builder: (context) => MultiBlocProvider(
                  //       providers: [
                  //         BlocProvider.value(value: addItemPurchaseCubit),
                  //         BlocProvider(
                  //           create: (context) => getIt<AddItemCubit>(),
                  //         ),
                  //         BlocProvider(
                  //           create: (context) =>
                  //               ValidationCubit(requiredFields: {}),
                  //         ),
                  //       ],
                  //       child: const NewPurchaseOrderScreen(),
                  //     ),
                  //   ),
                  // );

                  context.read<PagingCubit>().goToStep(1);
                },
                enabled: state,
                text: context.tr.chooseSources,
                borderRadius: BorderRadius.circular(15.r),
              );
            },
          ),
        ),
      ],
    );
  }
}
