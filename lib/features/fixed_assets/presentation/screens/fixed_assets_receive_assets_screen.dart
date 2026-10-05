import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/fixed_assets/presentation/cubit/fixed_assets_get_receive_assets/fixed_assets_get_receive_assets_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/receive_assets_respons.dart';
import '../../domain/strategies/fixed_assets_transfer_types_strategy.dart';
import '../widgets/fixed_assets_receive_assets_list_view_widget.dart';

class FixedAssetsReceiveAssetsScreen extends StatelessWidget {
  final FixedAssetsTransferTypesStrategy transferTypeStrategy;
  final String requestId;

  const FixedAssetsReceiveAssetsScreen({
    super.key,
    required this.transferTypeStrategy,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.dark,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Row(
                children: [
                  const AppBackButton(isTransparent: true),
                  8.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.fixedAssetsReceiveAssetsTitle,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.customColor.reversedTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          context.tr.fixedAssetsReceiveAssetsSubtitle,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.customColor.reversedTextColor
                                .withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child:
                    BlocBuilder<
                      FixedAssetsGetReceiveAssetsCubit,
                      FixedAssetsGetReceiveAssetsState
                    >(
                      builder: (context, state) {
                        final items = <ReceiveAssetsData>[];

                        if (state is FixedAssetsGetReceiveAssetsLoading) {
                          return const AppLoadingWidget();
                        } else if (state
                            is FixedAssetsGetReceiveAssetsFailure) {
                          return AppFailureWidget(
                            failure: state.failure,
                            onRetry: () {
                              context
                                  .read<FixedAssetsGetReceiveAssetsCubit>()
                                  .getReceiveAssets(requestId: requestId);
                            },
                            withBorder: false,
                          );
                        } else if (state
                            is FixedAssetsGetReceiveAssetsSuccess) {
                          items.addAll(state.data);
                        }

                        return FixedAssetsReceiveAssetsListViewWidget(
                          items: items,
                          requestId: requestId,
                          transferTypeStrategy: transferTypeStrategy,
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
