import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/inventory/data/models/daily_inventory_items_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helpers/shared_preferences_helper.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../purchase/presentation/widgets/purchase_app_bar.dart';
import '../../domain/strategies/inventory_user_type.dart';
import '../cubit/create_inventory/create_inventory_cubit.dart';
import '../widgets/daily_inventory_progress.dart';
import 'daily_inventory_summary_screen.dart';
import 'daily_personal_inventory_item_list_view.dart';

class DailyPersonalInventory extends StatelessWidget {
  final List<DailyInventoryItem> items;
  final InventoryUserType userType;

  const DailyPersonalInventory({
    super.key,
    required this.items,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.dailyQuickInventory,
            subtitle:
                '${DateFormatter.formatDateMDY(DateTime.now())} | ${getIt<SharedPreferencesHelper>().getString('u_name')} (${context.tr.branch})',
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  DailyInventoryProgress(
                    itemsLength: items.length,
                    quantityKeys: items.map((e) => 'quantity_${e.id}').toList(),
                  ),
                  10.verticalSpace,
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return DailyPersonalInventoryItemListView(
                          item: item,
                          index: index,
                          length: items.length,
                        );
                      },
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextButton(
                          text: context.tr.back,
                          onTap: () {
                            NavigationService.I.pop();
                          },
                          padding: EdgeInsets.symmetric(vertical: 18.r),
                          textColor: context.customColor.text1,
                          borderRadius: 18.r,
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child:
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              bool
                            >(
                              selector: (state) => state.enableButton,
                              builder: (context, state) {
                                return AppButton(
                                  onClick: () {
                                    final validationCubit = context
                                        .read<ValidationCubit>();

                                    NavigationService.I.push(
                                      MaterialPageRoute(
                                        builder: (context) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                              value: validationCubit,
                                            ),
                                            BlocProvider(
                                              create: (context) =>
                                                  getIt<CreateInventoryCubit>(),
                                            ),
                                          ],
                                          child: DailyInventorySummaryScreen(
                                            items: items,
                                            userType: userType,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  text: context.tr.next,
                                  enabled: state,
                                  padding: EdgeInsets.symmetric(vertical: 18.r),
                                  borderRadius: BorderRadius.circular(18.r),
                                );
                              },
                            ),
                      ),
                    ],
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
