import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../fixed_assets/presentation/widgets/fixed_assets_view_details_request_button.dart';
import '../../data/models/brand_owner_fixed_assets_modification_request_model.dart';
import '../cubit/brand_owner_fixed_assets_requests/brand_owner_fixed_assets_requests_cubit.dart';
import '../cubit/brand_owner_fixed_assets_requests/brand_owner_fixed_assets_requests_state.dart';
import '../cubit/brand_owner_modification_details/brand_owner_modification_details_cubit.dart';
import 'brand_owner_modification_details_screen.dart';

class BrandOwnerFixedAssetsRequestsModificationView extends StatefulWidget {
  const BrandOwnerFixedAssetsRequestsModificationView({super.key});

  @override
  State<BrandOwnerFixedAssetsRequestsModificationView> createState() =>
      _BrandOwnerFixedAssetsRequestsModificationViewState();
}

class _BrandOwnerFixedAssetsRequestsModificationViewState
    extends State<BrandOwnerFixedAssetsRequestsModificationView> {
  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    context
        .read<BrandOwnerFixedAssetsRequestsCubit>()
        .getModificationRequests();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BrandOwnerFixedAssetsRequestsCubit,
      BrandOwnerFixedAssetsRequestsState
    >(
      buildWhen: (previous, current) =>
          current is BrandOwnerFixedAssetsModificationRequestsLoading ||
          current is BrandOwnerFixedAssetsModificationRequestsSuccess ||
          current is BrandOwnerFixedAssetsModificationRequestsFailure,
      builder: (context, state) {
        if (state is BrandOwnerFixedAssetsRequestsInitial ||
            state is BrandOwnerFixedAssetsModificationRequestsLoading) {
          return const AppLoadingWidget();
        }

        if (state is BrandOwnerFixedAssetsModificationRequestsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: _loadRequests,
          );
        }

        final requests =
            state is BrandOwnerFixedAssetsModificationRequestsSuccess
            ? state.requests
            : <BrandOwnerFixedAssetsModificationRequestModel>[];

        if (requests.isEmpty) {
          return Center(
            child: Text(
              context.tr.noRequestsYet,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text3,
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.all(8.r),
          child: RefreshIndicator(
            onRefresh: () async {
              _loadRequests();
            },
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return Container(
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.all(8.r),
                  margin: EdgeInsets.only(
                    bottom: index == requests.length - 1 ? 0 : 10.r,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Modification Request ${request.branchName}',
                              style: AppStyles.s13W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          request.status.buildStatusWidget(context),
                        ],
                      ),
                      5.verticalSpace,
                      Text(
                        request.assetName,
                        style: AppStyles.s12W500.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      FixedAssetsViewDetailsRequestButton(
                        onPressed: () {
                          final brandOwnerFixedAssetsRequestsCubit = context
                              .read<BrandOwnerFixedAssetsRequestsCubit>();

                          AppBottomSheet.customPageRoute(
                            context,
                            (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) =>
                                      PagingCubit(totalSteps: 2),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      getIt<
                                          BrandOwnerModificationDetailsCubit
                                        >()
                                        ..load(requestId: request.id),
                                ),
                                BlocProvider.value(
                                  value: brandOwnerFixedAssetsRequestsCubit,
                                ),
                              ],
                              child: BrandOwnerModificationDetailsScreen(
                                requestId: request.id,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
