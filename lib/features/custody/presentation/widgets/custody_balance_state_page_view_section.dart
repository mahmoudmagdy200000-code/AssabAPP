import 'dart:ui';

import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_placeholder.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../cubit/get_custody_trend_state/get_custody_trend_state_cubit.dart';
import '../cubit/get_custody_trend_state/get_custody_trend_state_state.dart';

class CustodyBalanceStatePageViewSection extends StatefulWidget {
  const CustodyBalanceStatePageViewSection({super.key});

  @override
  State<CustodyBalanceStatePageViewSection> createState() =>
      _CustodyBalanceStatePageViewSectionState();
}

class _CustodyBalanceStatePageViewSectionState
    extends State<CustodyBalanceStatePageViewSection> {
  late final PageController _pageController;
  bool _isBranchAmountHidden = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              padEnds: false,
              onPageChanged: (value) {
                context.read<PagingCubit>().goToStep(value);
              },
              children: [
                _buildBranchCustodyWidget(context: context),
                _buildPersonalCustodyWidget(context: context),
              ],
            ),
          ),
          12.verticalSpace,
          SmoothPageIndicator(
            controller: _pageController,
            count: 2,
            effect: ExpandingDotsEffect(
              dotHeight: 8.r,
              dotWidth: 10.r,
              activeDotColor: context.theme.primaryColor,
              dotColor: context.customColor.border,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchCustodyWidget({required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        gradient: LinearGradient(
          colors: [
            context.theme.primaryColor.withValues(alpha: 0.6),
            context.theme.primaryColor.withValues(alpha: 0.7),
            context.theme.primaryColor.withValues(alpha: 0.8),
            context.theme.primaryColor.withValues(alpha: 0.9),
            context.theme.primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 18.5.r),
      margin: EdgeInsetsDirectional.only(end: 10.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.tr.branchCustodyBalance,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                ),
                6.verticalSpace,
                Row(
                  children: [
                    SaudiRiyalSvgWidget(
                      color: context.customColor.reversedTextColor,
                      size: 20.r,
                    ),
                    10.horizontalSpace,
                    BlocBuilder<
                      GetCustodyTrendStateCubit,
                      GetCustodyTrendStateState
                    >(
                      builder: (context, state) {
                        double amount = 0;

                        if (state is GetCustodyTrendStateLoading) {
                          return AppPlaceholder(
                            width: 150.w,
                            height: 12.r,
                            borderRadius: BorderRadius.circular(1000.r),
                          );
                        } else if (state is GetCustodyTrendStateSuccess) {
                          amount = state.response.data.currentBalance;
                        }

                        return _isBranchAmountHidden
                            ? ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 5,
                                  sigmaY: 5,
                                ),
                                child: Text(
                                  amount.toStringAsFixed(2),
                                  style: AppStyles.s16WB.copyWith(
                                    color:
                                        context.customColor.reversedTextColor,
                                  ),
                                ),
                              )
                            : Text(
                                amount.toStringAsFixed(2),
                                style: AppStyles.s16WB.copyWith(
                                  color: context.customColor.reversedTextColor,
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          AppGestureDetectorButton(
            onTap: () {
              setState(() {
                _isBranchAmountHidden = !_isBranchAmountHidden;
              });
            },
            child: AppSvg(
              assetName: AppAssets.eye,
              width: 20.w,
              height: 20.w,
              colorFilter: ColorFilter.mode(
                context.customColor.reversedTextColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalCustodyWidget({required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 18.5.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.tr.personalCustodyBalance,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          6.verticalSpace,
          Row(
            children: [
              SaudiRiyalSvgWidget(color: context.customColor.text1, size: 20.r),
              10.horizontalSpace,
              BlocBuilder<GetCustodyTrendStateCubit, GetCustodyTrendStateState>(
                builder: (context, state) {
                  double amount = 0;

                  if (state is GetCustodyTrendStateLoading) {
                    return AppPlaceholder(
                      width: 150.w,
                      height: 12.r,
                      borderRadius: BorderRadius.circular(1000.r),
                    );
                  } else if (state is GetCustodyTrendStateSuccess) {
                    amount = state.response.data.currentBalance;
                  }

                  return Text(
                    amount.toStringAsFixed(2),
                    style: AppStyles.s16WB.copyWith(
                      color: context.customColor.text1,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
