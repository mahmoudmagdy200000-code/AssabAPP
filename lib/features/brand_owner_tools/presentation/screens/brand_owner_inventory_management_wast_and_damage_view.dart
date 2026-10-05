import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_local_failure.dart';
import '../../../../core/widgets/app_search_empty_result_widget.dart';
import '../../../custody/presentation/widgets/custody_empty_widget.dart';
import '../cubit/brand_owner_wast_and_damage_requests/brand_owner_wast_and_damage_requests_cubit.dart';
import '../cubit/brand_owner_wast_and_damage_requests/brand_owner_wast_and_damage_requests_state.dart';
import '../widgets/brabd_owner_wast_damage_requests_cart_widget.dart';

class BrandOwnerInventoryManagementWastAndDamageView extends StatefulWidget {
  const BrandOwnerInventoryManagementWastAndDamageView({super.key});

  @override
  State<BrandOwnerInventoryManagementWastAndDamageView> createState() =>
      _BrandOwnerInventoryManagementWastAndDamageViewState();
}

class _BrandOwnerInventoryManagementWastAndDamageViewState
    extends State<BrandOwnerInventoryManagementWastAndDamageView> {
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
          .read<BrandOwnerWastAndDamageRequestsCubit>()
          .paginator
          .hasMore) {
        context.read<BrandOwnerWastAndDamageRequestsCubit>().load(
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
      BrandOwnerWastAndDamageRequestsCubit,
      BrandOwnerWastAndDamageRequestsState
    >(
      builder: (context, state) {
        return switch (state) {
          BrandOwnerWastAndDamageRequestsInitial() ||
          BrandOwnerWastAndDamageRequestsLoading() => const AppLoadingWidget(),
          BrandOwnerWastAndDamageRequestsFailure(:final failure) =>
            AppFailureWidget(
              failure: failure,
              withBorder: false,
              onRetry: () {
                context.read<BrandOwnerWastAndDamageRequestsCubit>().load();
              },
            ),
          BrandOwnerWastAndDamageRequestsSuccess(:final response) =>
            response.isEmpty
                ? RefreshIndicator(
                    onRefresh: () async => await context
                        .read<BrandOwnerWastAndDamageRequestsCubit>()
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
                                  .youHaveNotSentAnyWastAndDamageRequestsToStoreOwnerForApprovals,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async => await context
                        .read<BrandOwnerWastAndDamageRequestsCubit>()
                        .load(),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: response.length,
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return BrandOwnerWastDamageRequestsCartWidget(
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
