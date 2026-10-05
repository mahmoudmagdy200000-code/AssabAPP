import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/locale/locale_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/navigation/navigation_service.dart';
import '../styles/app_styles.dart';
import 'app_padding_widget.dart';
import 'choose_language_button.dart';

class ChangeLanguageBottomSheetWidget extends StatelessWidget {
  const ChangeLanguageBottomSheetWidget({super.key});

  void _changeLanguage({required BuildContext context, required String code}) {
    context.read<LocaleCubit>().setLocale(code);
    NavigationService.I.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      bottom: 70.r,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.changeLanguage,
            style: AppStyles.s20W500.copyWith(color: context.customColor.text1),
          ),
          7.verticalSpace,
          Text(
            context.tr.changeLanguageDescription,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text1),
          ),
          32.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ChooseLanguageButton(
                changeLanguage: () =>
                    _changeLanguage(context: context, code: 'en'),
                text: 'English',
                flag: AppAssets.enFlag,
                selectedLanguage: !context.watch<LocaleCubit>().isArabic,
              ),
              16.horizontalSpace,
              ChooseLanguageButton(
                changeLanguage: () =>
                    _changeLanguage(context: context, code: 'ar'),
                text: 'العربيه',
                flag: AppAssets.arFlag,
                selectedLanguage: context.watch<LocaleCubit>().isArabic,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
