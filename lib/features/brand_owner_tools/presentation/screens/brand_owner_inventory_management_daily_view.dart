import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_local_failure.dart';
import '../../../../core/widgets/app_search_empty_result_widget.dart';
import '../../../custody/presentation/widgets/custody_empty_widget.dart';
import '../cubit/brand_owner_daily_inventory_requests/brand_owner_daily_inventory_requests_cubit.dart';
import '../cubit/brand_owner_daily_inventory_requests/brand_owner_daily_inventory_requests_state.dart';
import '../widgets/brabd_owner_daily_requests_cart_widget.dart';

class BrandOwnerInventoryManagementDailyView extends StatefulWidget {
  const BrandOwnerInventoryManagementDailyView({super.key});

  @override
  State<BrandOwnerInventoryManagementDailyView> createState() =>
      _BrandOwnerInventoryManagementDailyViewState();
}

class _BrandOwnerInventoryManagementDailyViewState
    extends State<BrandOwnerInventoryManagementDailyView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.h) {
      if (context
          .read<BrandOwnerDailyInventoryRequestsCubit>()
          .paginator
          .hasMore) {
        context.read<BrandOwnerDailyInventoryRequestsCubit>().load(
          loadMore: true,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BrandOwnerDailyInventoryRequestsCubit,
      BrandOwnerDailyInventoryRequestsState
    >(
      builder: (context, state) {
        return switch (state) {
          BrandOwnerDailyInventoryRequestsInitial() ||
          BrandOwnerDailyInventoryRequestsLoading() => const AppLoadingWidget(),
          BrandOwnerDailyInventoryRequestsFailure(:final failure) =>
            AppFailureWidget(
              failure: failure,
              withBorder: false,
              onRetry: () {
                context.read<BrandOwnerDailyInventoryRequestsCubit>().load();
              },
            ),
          BrandOwnerDailyInventoryRequestsSuccess(:final response) =>
            response.isEmpty
                ? RefreshIndicator(
                    onRefresh: () async => await context
                        .read<BrandOwnerDailyInventoryRequestsCubit>()
                        .load(),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: CustodyEmptyWidget(
                              asset: AppAssets.boxPNG,
                              title: context.tr.noRequestsYet,
                              desc: context
                                  .tr
                                  .youHaveNotSentAnyDailyInventoryRequestsToStoreOwnerForApprovals,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async => await context
                        .read<BrandOwnerDailyInventoryRequestsCubit>()
                        .load(),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: response.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return BrandOwnerDailyRequestsCartWidget(
                          request: response[index],
                        );
                      },
                    ),
                  ),
        };
      },
    );
  }
}
