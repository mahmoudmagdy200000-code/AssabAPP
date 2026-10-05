import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/choose_item/choose_item_state.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/custody/presentation/cubit/custody_create_request/custody_create_request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/search/search_state.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/custody_get_past_requests_response.dart';
import '../../data/models/custody_reuse_past_request_request_model.dart';
import '../cubit/custody_create_request/custody_create_request_state.dart';
import '../cubit/custody_get_requets/custody_get_requets_cubit.dart';
import '../cubit/custody_get_requets/custody_get_requets_state.dart';
import 'branch_custody_past_requests_request_view_item_list_widget.dart';

class CustodyReusePastRequestBottomSheetWidget extends StatefulWidget {
  const CustodyReusePastRequestBottomSheetWidget({super.key});

  @override
  State<CustodyReusePastRequestBottomSheetWidget> createState() =>
      _CustodyReusePastRequestBottomSheetWidgetState();
}

class _CustodyReusePastRequestBottomSheetWidgetState
    extends State<CustodyReusePastRequestBottomSheetWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _getPastRequests();
    _scrollController.addListener(_scrollControllerListener);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollControllerListener);

    _scrollController.dispose();
    super.dispose();
  }

  void _scrollControllerListener() {
    if (!_scrollController.position.outOfRange &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200.r) {}
  }

  void _getPastRequests({bool loadMore = false}) {
    context.read<CustodyGetRequetsCubit>().getCustodyPastRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppPaddingWidget(
        top: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.pastRequest,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            12.verticalSpace,
            Text(
              context.tr.pastRequestDesc,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            14.verticalSpace,
            const CustomDivider(),
            20.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppSvg(assetName: AppAssets.search),
                10.horizontalSpace,
                Expanded(
                  child: CustomTextField(
                    hintText: context.tr.searchForPreApprovalRequests,
                    onChanged: (value) {
                      context
                          .read<SearchCubit<CustodyGetPastRequestData>>()
                          .search(
                            value,
                            (item, query) => item.purpose
                                .toString()
                                .toLowerCase()
                                .contains(query.toLowerCase()),
                          );
                    },
                  ),
                ),
              ],
            ),
            14.verticalSpace,
            const CustomDivider(),
            14.verticalSpace,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.all(10.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.all(8.r),
                  child:
                      BlocConsumer<
                        CustodyGetRequetsCubit,
                        CustodyGetRequetsState
                      >(
                        listener: (context, state) {
                          if (state is CustodyGetPastRequestsSuccess) {
                            context
                                .read<SearchCubit<CustodyGetPastRequestData>>()
                                .setData(
                                  state.requestsResponse.previousRequests,
                                );
                          }
                        },
                        builder: (context, state) {
                          if (state is CustodyGetRequetsLoading) {
                            return const AppLoadingWidget();
                          } else if (state is CustodyGetRequetsFailure) {
                            return AppFailureWidget(
                              failure: state.failure,
                              onRetry: _getPastRequests,
                              withBorder: false,
                            );
                          }

                          return BlocBuilder<
                            SearchCubit<CustodyGetPastRequestData>,
                            SearchState<CustodyGetPastRequestData>
                          >(
                            builder: (context, state) {
                              if (state
                                  is SearchSuccess<CustodyGetPastRequestData>) {
                                final requests = state.results;

                                return ListView.builder(
                                  itemCount: requests.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    final request = requests[index];

                                    return AppGestureDetectorButton(
                                      onTap: () {
                                        context
                                            .read<ChooseItemCubit>()
                                            .selectItem(index);

                                        context
                                            .read<ValidationCubit>()
                                            .validateFieldAndStoreValue(
                                              fieldName: 'itemId',
                                              value: request.id,
                                              isValid: true,
                                            );
                                      },
                                      child:
                                          BlocSelector<
                                            ChooseItemCubit,
                                            ChooseItemState,
                                            bool
                                          >(
                                            selector: (state) =>
                                                state.selectedIndex == index,
                                            builder: (context, state) {
                                              return BranchCustodyPastRequestsRequestViewItemListWidget(
                                                border: state
                                                    ? Border.all(
                                                        color: context
                                                            .theme
                                                            .primaryColor,
                                                      )
                                                    : null,
                                                request: request,
                                                margin:
                                                    index < requests.length - 1
                                                    ? 8.r
                                                    : 0,
                                              );
                                            },
                                          ),
                                    );
                                  },
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          );
                        },
                      ),
                ),
              ),
            ),
            14.verticalSpace,
            BlocConsumer<CustodyCreateRequestCubit, CustodyCreateRequestState>(
              listener: (context, state) {
                if (state is CustodyCreateRequestSuccess) {
                  NavigationService.I.pop();
                  NavigationService.I.pop();
                  NavigationService.I.pushNamed(
                    AppRouteName.custodyRequestSuccessScreen,
                  );
                } else if (state is CustodyCreateReusePastRequestFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is CustodyCreateRequestLoading) {
                  return const AppButtonLoading();
                }

                return BlocSelector<ChooseItemCubit, ChooseItemState, bool>(
                  selector: (state) => state.selectedIndex != null,
                  builder: (context, value) {
                    return AppButton(
                      onClick: () {
                        final requestId = context
                            .read<ValidationCubit>()
                            .getFieldValue('itemId');

                        context
                            .read<CustodyCreateRequestCubit>()
                            .createReusePastRequest(
                              requestModel: CustodyReusePastRequestRequestModel(
                                pastRequestId: requestId,
                              ),
                            );
                      },
                      enabled: value,
                      text: context.tr.confirmSelection,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
