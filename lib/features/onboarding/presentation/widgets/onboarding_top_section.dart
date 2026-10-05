import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/onboarding/presentation/cubit/onboarding/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_padding_widget.dart';
import 'onboarding_app_bar.dart';
import 'onboarding_row_numbers.dart';

class OnboardingTopSection extends StatefulWidget {
  const OnboardingTopSection({super.key});

  @override
  State<OnboardingTopSection> createState() => _OnboardingTopSectionState();
}

class _OnboardingTopSectionState extends State<OnboardingTopSection> {
  final GlobalKey _appBarAndNumRowKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getWidgetHeight();
    });
    super.initState();
  }

  void _getWidgetHeight() {
    final RenderBox? renderBox =
        _appBarAndNumRowKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      context.read<OnboardingCubit>().getAppBarAndNumRowHeight(
        renderBox.size.height,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      key: _appBarAndNumRowKey,
      top: 0,
      right: 0,
      left: 0,
      child: AppPaddingWidget(
        child: Column(
          children: [
            const OnboardingAppBar(),
            28.verticalSpace,
            const OnboardingRowNumbers(),
          ],
        ),
      ),
    );
  }
}
