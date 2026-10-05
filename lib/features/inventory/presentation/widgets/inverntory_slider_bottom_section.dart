import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_fillable_asset_image.dart';
import 'package:assab/features/inventory/domain/strategies/slider_strategy.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../data/models/inventory_slider_indicator.dart';

class InverntorySliderBottomSection extends StatefulWidget {
  const InverntorySliderBottomSection({super.key});

  @override
  State<InverntorySliderBottomSection> createState() =>
      _InverntorySliderBottomSectionState();
}

class _InverntorySliderBottomSectionState
    extends State<InverntorySliderBottomSection> {
  late final ScrollController _scrollController;
  late final ValueNotifier<InventorySliderIndicator> _indicatorNotifier;

  @override
  void initState() {
    super.initState();

    _indicatorNotifier = ValueNotifier(
      InventorySliderIndicator(
        arrowBottom: 0,
        percentageText: '0% ${S.current.full}',
        fillPercent: 1.0,
      ),
    );

    _scrollController = ScrollController(initialScrollOffset: 200 * 3.h);
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onScroll();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        !_scrollController.position.hasContentDimensions) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    final fillPercent = maxScroll > 0
        ? (1 - (currentScroll / maxScroll)).clamp(0.0, 1.0)
        : 0.0;

    final percentage = (fillPercent * 100).round();

    context.read<ValidationCubit>().validateFieldAndStoreTypedValue<int>(
      fieldName: 'sliderPercentage',
      value: percentage,
      isValid: true,
    );

    _indicatorNotifier.value = InventorySliderIndicator(
      arrowBottom: fillPercent * 200.h,
      percentageText: '$percentage% ${S.current.full}',
      fillPercent: fillPercent,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _indicatorNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ValueListenableBuilder<InventorySliderIndicator>(
          valueListenable: _indicatorNotifier,
          builder: (context, state, _) {
            return AnimatedBuilder(
              animation: _indicatorNotifier,
              builder: (context, _) {
                return BlocSelector<
                  ValidationCubit,
                  ValidationState,
                  SliderStrategy
                >(
                  selector: (state) =>
                      state.getTypedValue<SliderStrategy>('sliderType') ??
                      BottlesSliderStrategy(),
                  builder: (context, state) {
                    return AppFillableAssetImage(
                      image: state.image,
                      width: state.width,
                      height: state.height,
                      fillPercent: _indicatorNotifier.value.fillPercent,
                      fillColor: context.theme.primaryColor,
                    );
                  },
                );
              },
            );
          },
        ),
        20.horizontalSpace,
        Flexible(
          fit: FlexFit.loose,
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 216.h,
                    width: 55.r,
                    margin: EdgeInsets.only(top: 30.r, bottom: 5.r),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: 100,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final isIndexTen = index % 10 == 0;
                        final isLastIndex = index == 99;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isIndexTen || isLastIndex) ...[
                              Text(
                                isLastIndex ? '0%' : '${100 - index}%',
                                style: AppStyles.s10W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ),
                              5.horizontalSpace,
                            ],
                            Container(
                              width: isIndexTen || isLastIndex ? 17.w : 10.w,
                              height: isIndexTen || isLastIndex ? 2.h : 1.h,
                              color: isIndexTen || isLastIndex
                                  ? context.customColor.text6
                                  : context.customColor.text3,
                              margin: EdgeInsets.symmetric(vertical: 2.r),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              ValueListenableBuilder<InventorySliderIndicator>(
                valueListenable: _indicatorNotifier,
                builder: (context, state, _) {
                  return Positioned(
                    left: 50.r + 15.r,
                    bottom: state.arrowBottom,
                    child: Row(
                      children: [
                        AppSvg(
                          assetName: AppAssets.arrowLeft,
                          width: 15.r,
                          colorFilter: ColorFilter.mode(
                            context.theme.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        5.horizontalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(1000.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.r,
                            vertical: 5.r,
                          ),
                          child: Text(
                            state.percentageText,
                            style: AppStyles.s12W500.copyWith(
                              color: context.customColor.reversedTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
