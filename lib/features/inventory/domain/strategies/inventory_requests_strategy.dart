import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/features/custody/presentation/widgets/custody_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../data/models/daily_inventory_list_response.dart';
import '../../data/models/monthly_inventory_list_response.dart';
import '../../data/models/wasted_damage_list_response.dart';
import '../../presentation/cubit/get_inventory_requests/get_inventory_requests_cubit.dart';
import '../../presentation/cubit/get_inventory_requests/get_inventory_requests_state.dart';
import '../../presentation/screens/daily_inventory_request_details_screen.dart';
import '../../presentation/screens/monthly_inventory_details_screen.dart';
import '../../presentation/widgets/daily_inventory_requests_cart_widget.dart';
import '../../presentation/widgets/monthly_inventory_requests_cart_widget.dart';
import '../../presentation/widgets/wast_damage_requests_cart_widget.dart';
import 'daily_inventory_status_strategy.dart';
import 'monthly_inventory_status_strategy.dart';

abstract class InventoryRequestsStrategy {
  String title(BuildContext context, {required String count});

  Widget buildDailyInventoryTopSection(BuildContext context) =>
      const SizedBox.shrink();

  Widget buildRequestsList(BuildContext context, {int selectedTabIndex = 0}) =>
      const SizedBox.shrink();

  Future<void> getRequests(BuildContext context) async {}
}

Widget _buildEmptyWidget(BuildContext context) {
  return CustodyEmptyWidget(
    asset: AppAssets.listPng,
    title: context.tr.noRequestsYet,
    desc: context.tr.noRequestsYetDesc,
  );
}

class DailyInventoryRequestsStrategy extends InventoryRequestsStrategy {
  @override
  String title(BuildContext context, {required String count}) =>
      context.tr.dailyInventory(int.tryParse(count) ?? 0);

  @override
  Future<void> getRequests(BuildContext context) async {
    await context.read<GetInventoryRequestsCubit>().getInventoryDailyRequests();
  }

  @override
  Widget buildRequestsList(BuildContext context, {int selectedTabIndex = 0}) {
    return BlocBuilder<GetInventoryRequestsCubit, GetInventoryRequestsState>(
      builder: (context, state) {
        final allRequests = <DailyInventoryListResponseSession>[];

        if (state is GetInventoryRequestsLoading) {
          return const AppLoadingWidget();
        } else if (state is GetInventoryRequestsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: () async => await getRequests(context),
            withBorder: false,
          );
        } else if (state is GetDailyInventoryRequestsSuccess) {
          allRequests.addAll(state.response);
        }

        final requests = _filterDailyRequests(allRequests, selectedTabIndex);

        if (requests.isEmpty) {
          return _buildEmptyWidget(context);
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return DailyInventoryRequestsCartWidget(
              request: requests[index],
              onTap: () {
                NavigationService.I.push(
                  MaterialPageRoute(
                    builder: (_) => DailyInventoryRequestDetailsScreen(
                      request: requests[index],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<DailyInventoryListResponseSession> _filterDailyRequests(
    List<DailyInventoryListResponseSession> requests,
    int selectedTabIndex,
  ) {
    if (selectedTabIndex == 0) return requests;
    return requests.where((r) {
      final isPending = r.status is PendingDailyInventoryStatusStrategy;
      return selectedTabIndex == 1 ? isPending : !isPending;
    }).toList();
  }

  @override
  Widget buildDailyInventoryTopSection(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: context.customColor.border),
          ),
          margin: EdgeInsets.only(bottom: 10.r),
          child: Column(
            children: [
              Text(
                context.tr.productsPreSelected,
                style: AppStyles.s14W600.copyWith(
                  color: context.customColor.text1,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                context.tr.howWouldYouLikeToRecordThisInventorySuggestions,
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text3,
                ),
                textAlign: TextAlign.center,
              ),
              16.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      onTap: () {
                        NavigationService.I.pop();

                        NavigationService.I.pushNamed(
                          AppRouteName.dailyInventoryScreen,
                        );
                      },
                      text: context.tr.startInventory,
                      backgroundColor: context.theme.primaryColor,
                      textColor: context.customColor.reversedTextColor,
                      borderRadius: 1000.r,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      borderColor: Colors.transparent,
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: CustomTextButton(
                      onTap: () {
                        NavigationService.I.pop();

                        NavigationService.I.pushNamed(
                          AppRouteName.dailyInventoryScreen,
                        );
                      },
                      text: context.tr.assignToStaff,
                      backgroundColor: Colors.transparent,
                      textColor: context.customColor.text1,
                      borderRadius: 1000.r,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WastedAndDamagedInventoryRequestsStrategy
    extends InventoryRequestsStrategy {
  @override
  String title(BuildContext context, {required String count}) =>
      context.tr.wasteAndDamages(count);

  @override
  Future<void> getRequests(BuildContext context) async {
    await context.read<GetInventoryRequestsCubit>().getWasteDamageRequests();
  }

  @override
  Widget buildRequestsList(BuildContext context, {int selectedTabIndex = 0}) {
    return BlocBuilder<GetInventoryRequestsCubit, GetInventoryRequestsState>(
      builder: (context, state) {
        final allRequests = <WastedDamageListEntry>[];

        if (state is GetInventoryRequestsLoading) {
          return const AppLoadingWidget();
        } else if (state is GetInventoryRequestsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: () async => await getRequests(context),
            withBorder: false,
          );
        } else if (state is GetWasteDamageInventoryRequestsSuccess) {
          allRequests.addAll(state.response);
        }

        final requests = _filterWasteRequests(allRequests, selectedTabIndex);

        if (requests.isEmpty) {
          return _buildEmptyWidget(context);
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return WastDamageRequestsCartWidget(request: requests[index]);
          },
        );
      },
    );
  }

  List<WastedDamageListEntry> _filterWasteRequests(
    List<WastedDamageListEntry> requests,
    int selectedTabIndex,
  ) {
    if (selectedTabIndex == 0) return requests;
    return requests.where((r) {
      final isPending = r.status is PendingDailyInventoryStatusStrategy;
      return selectedTabIndex == 1 ? isPending : !isPending;
    }).toList();
  }
}

class MonthlyInventoryRequestsStrategy extends InventoryRequestsStrategy {
  @override
  String title(BuildContext context, {required String count}) =>
      context.tr.monthlyInventoryCount(count);

  @override
  Future<void> getRequests(BuildContext context) async {
    await context
        .read<GetInventoryRequestsCubit>()
        .getMonthlyInventoryRequests();
  }

  @override
  Widget buildRequestsList(BuildContext context, {int selectedTabIndex = 0}) {
    return BlocBuilder<GetInventoryRequestsCubit, GetInventoryRequestsState>(
      builder: (context, state) {
        final allRequests = <MonthlyInventoryListItem>[];

        if (state is GetInventoryRequestsLoading) {
          return const AppLoadingWidget();
        } else if (state is GetInventoryRequestsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: () async => await getRequests(context),
            withBorder: false,
          );
        } else if (state is GetMonthlyInventoryRequestsSuccess) {
          allRequests.addAll(state.products);
        }

        final requests = _filterMonthlyRequests(allRequests, selectedTabIndex);

        if (requests.isEmpty) {
          return _buildEmptyWidget(context);
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return MonthlyInventoryRequestsCartWidget(
              request: requests[index],
              onTap: () {
                NavigationService.I.push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => PagingCubit(totalSteps: 2),
                      child: MonthlyInventoryDetailsScreen(
                        details: requests[index].details,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<MonthlyInventoryListItem> _filterMonthlyRequests(
    List<MonthlyInventoryListItem> requests,
    int selectedTabIndex,
  ) {
    if (selectedTabIndex == 0) return requests;
    return requests.where((r) {
      final isInProgress = r.status is InProgressMonthlyInventoryStatusStrategy;
      return selectedTabIndex == 1 ? isInProgress : !isInProgress;
    }).toList();
  }
}
