import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../data/models/supplier_returns_response.dart';
import '../cubit/supplier_get_returns/supplier_get_returns_cubit.dart';
import '../cubit/supplier_get_returns/supplier_get_returns_state.dart';
import '../widgets/supplier_returns_app_bar.dart';

class SupplierReturnsScreen extends StatefulWidget {
  const SupplierReturnsScreen({super.key});

  @override
  State<SupplierReturnsScreen> createState() => _SupplierReturnsScreenState();
}

class _SupplierReturnsScreenState extends State<SupplierReturnsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _getReturns();

    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenToScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _listenToScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.r) {
      if (context.read<SupplierGetReturnsCubit>().paginator.hasMore) {
        _getReturns(loadMore: true);
      }
    }
  }

  void _getReturns({bool loadMore = false}) {
    context.read<SupplierGetReturnsCubit>().getReturns(loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          const SupplierReturnsAppBar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: AppPaddingWidget(
                top: 12.r,
                bottom: 12.r,
                left: 12.r,
                right: 12.r,
                child:
                    BlocBuilder<
                      SupplierGetReturnsCubit,
                      SupplierGetReturnsState
                    >(
                      builder: (context, state) {
                        final returns = <SupplierReturnData>[];

                        if (state is SupplierGetReturnsLoading) {
                          return const AppLoadingWidget();
                        } else if (state is SupplierGetReturnsFailure) {
                          return AppFailureWidget(
                            failure: state.failure,
                            onRetry: _getReturns,
                            withBorder: false,
                          );
                        } else if (state is SupplierGetReturnsSuccess) {
                          returns.addAll(state.returns);
                        }

                        if (returns.isEmpty) {
                          return Center(
                            child: Text(
                              context.tr.noReturnsAvailable,
                              style: AppStyles.s15W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async => _getReturns(),
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: returns.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final returnItem = returns[index];

                              return AppGestureDetectorButton(
                                onTap: () async {
                                  await NavigationService.I.pushNamed(
                                    AppRouteName
                                        .supplierItemReturnDetailsScreen,
                                    arguments: returnItem.id,
                                  );

                                  if (mounted) _getReturns();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.customColor.text2,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  margin: EdgeInsets.only(bottom: 4.r),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16.r,
                                    horizontal: 20.r,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              returnItem.returnNumber,
                                              style: AppStyles.s13W600.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                AppSvg(
                                                  assetName: AppAssets
                                                      .returnsManagement,
                                                  width: 12.r,
                                                  colorFilter: ColorFilter.mode(
                                                    context.customColor.text3,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                                6.horizontalSpace,
                                                Expanded(
                                                  child: Text(
                                                    context.tr.goodsReturns,
                                                    style: AppStyles.s12W400
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text1,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${DateFormatter.formatDateMDY(DateTime.tryParse(returnItem.createdAt))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(returnItem.createdAt))}',
                                              style: AppStyles.s12W400.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      returnItem.status.buildStatusWidget(
                                        context,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
