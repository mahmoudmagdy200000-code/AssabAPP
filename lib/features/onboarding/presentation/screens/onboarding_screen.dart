import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/onboarding/presentation/cubit/onboarding/onboarding_cubit.dart';
import 'package:assab/features/onboarding/presentation/widgets/pager_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/onboarding_bottom_section.dart';
import '../widgets/onboarding_top_section.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  final List _backgroundColors = [
    AppColors.primaryLight,
    AppColors.green,
    AppColors.orange,
  ];

  final List _onboardingImages = [
    AppAssets.onboardingOne,
    AppAssets.onboardingTwo,
    AppAssets.onboardingThree,
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List onboardingTitles = [
      context.tr.manageYourRestaurantCafeLikeAPro,
      context.tr.seeEverythingMissNothing,
      context.tr.knowWhatWorkingFixWhatNot,
    ];

    final List onboardingDesc = [
      context.tr.onboardingOneDesc,
      context.tr.onboardingTwoDesc,
      context.tr.onboardingThreeDesc,
    ];

    return Scaffold(
      backgroundColor:
          _backgroundColors[context.watch<OnboardingCubit>().currentPage],
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _backgroundColors[context.watch<OnboardingCubit>().currentPage],
        margin: EdgeInsets.only(top: 25.r),
        child: Stack(
          children: [
            AppPaddingWidget(
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  context.read<OnboardingCubit>().changePage(value);
                },
                children: List.generate(3, (index) {
                  return PagerViewWidget(
                    title: onboardingTitles[index],
                    desc: onboardingDesc[index],
                    image: _onboardingImages[index],
                    index: index,
                  );
                }),
              ),
            ),
            const OnboardingTopSection(),
            const OnboardingBottomSection(),
          ],
        ),
      ),
    );
  }
}
