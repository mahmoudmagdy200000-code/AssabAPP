import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';

class ComparePriceSmartRecommendationSection extends StatefulWidget {
  const ComparePriceSmartRecommendationSection({super.key});

  @override
  State<ComparePriceSmartRecommendationSection> createState() =>
      _ComparePriceSmartRecommendationSectionState();
}

class _ComparePriceSmartRecommendationSectionState
    extends State<ComparePriceSmartRecommendationSection> {
  final GlobalKey _smartRecommendationKey = GlobalKey();
  double _smartRecommendationHeight = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _smartRecommendationKey.currentContext?.findRenderObject()
              as RenderBox;

      setState(() {
        _smartRecommendationHeight = renderBox.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: _smartRecommendationHeight,
          color: context.theme.primaryColor,
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            key: _smartRecommendationKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.smartRecommendation,
                style: AppStyles.s16W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              8.verticalSpace,
              Text(
                context.tr.theIconIsSystemgeneratedBasedOnRealtimeAnalysis,
                softWrap: true,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              20.verticalSpace,
              Text(
                context
                    .tr
                    .orderViaBrandManagerBestOverallValueCompetitivePriceExcellent,
                softWrap: true,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
