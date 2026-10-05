import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/search/search_cubit.dart';
import '../../../../../../../core/cubits/search/search_state.dart';
import '../../../../domain/entity/cashier_entity.dart';
import '../../../logic/cashier/cashier_management_cubit.dart';
import 'fetch_cashier_empty_widget/fetch_cashier_empty_body.dart';
import 'fetch_cashier_loading_widget/fetch_cashier_loading_widget.dart';
import 'fetch_cashiers_success_widgets/cashiers_management_success_body.dart';

class CashiersBottomSectionWidget extends StatelessWidget {
  const CashiersBottomSectionWidget({
    super.key,
    required this.scrollController,
    this.isFromFilter = false,
  });

  final bool isFromFilter;

  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashierManagementCubit, CashierManagementState>(
      builder: (context, state) {
        List<CashierEntity> cashiers = [];

        if (state is CashierManagementLoading) {
          if (isFromFilter) {
            return const Center(child: AppLoadingWidget());
          } else {
            return const ShiftManagementLoadingWidget();
          }
        } else if (state is CashierManagementSuccess) {
          cashiers = state.cashiers;
          context.read<SearchCubit<CashierEntity>>().setData(cashiers);
        } else if (state is CashierManagementFailure) {
          // return ShiftManagementFailureBody(failure: state.failure);
          return Center(
            child: AppFailureWidget(
              failure: state.failure,
              onRetry: () {
                if (isFromFilter) {
                  context.read<CashierManagementCubit>().getCashiers(
                    dateOption: context
                        .read<CashierManagementCubit>()
                        .dateOption,
                    status: context.read<CashierManagementCubit>().status,
                    loadMore: false,
                  );
                } else {
                  context.read<CashierManagementCubit>().getCashiers(
                    loadMore: false,
                  );
                }
              },
            ),
          );
        }

        return BlocBuilder<
          SearchCubit<CashierEntity>,
          SearchState<CashierEntity>
        >(
          builder: (context, searchState) {
            List<CashierEntity> cashiers = [];

            if (searchState is SearchSuccess<CashierEntity>) {
              cashiers = searchState.results;
            }

            if (state is CashierManagementEmpty ||
                (searchState is SearchSuccess<CashierEntity> &&
                    cashiers.isEmpty)) {
              return ShiftManagementEmptyBody(
                hasFilters:
                    context.read<CashierManagementCubit>().hasFilters ||
                    searchState is SearchSuccess<CashierEntity>,
              );
            }

            return CashiersManagementSuccessBody(
              cashiers: cashiers,
              scrollController: scrollController,
              onRefresh: () async {
                if (isFromFilter) {
                  context.read<CashierManagementCubit>().getCashiers(
                    dateOption: context
                        .read<CashierManagementCubit>()
                        .dateOption,
                    status: context.read<CashierManagementCubit>().status,
                    loadMore: false,
                  );
                } else {
                  context.read<CashierManagementCubit>().getCashiers(
                    loadMore: false,
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
