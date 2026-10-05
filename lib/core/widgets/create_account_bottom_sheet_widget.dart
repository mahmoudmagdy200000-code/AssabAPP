import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

import 'animated_container_of_paging_widget.dart';
import 'custom_paging_widget.dart';

class CreateAccountBottomSheetWidget extends StatefulWidget {
  const CreateAccountBottomSheetWidget({super.key});

  @override
  State<CreateAccountBottomSheetWidget> createState() =>
      _CreateAccountBottomSheetWidgetState();
}

class _CreateAccountBottomSheetWidgetState
    extends State<CreateAccountBottomSheetWidget> {
  late final PageController _pageController;
  late final ValueNotifier<int> _valueNotifier;
  int currentPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _valueNotifier = ValueNotifier(0);

    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != currentPage) {
        setState(() {
          currentPage = newPage;
        });
      }
      _valueNotifier.value = newPage;
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  _buildPageOne(context: context),
                  _buildPageTwo(context: context),
                  _buildPageThree(context: context),
                ],
              ),
            ),
            20.verticalSpace,
            _buildRowNumber(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageOne({required BuildContext context}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppAssetImage(
            image: AppAssets.createAccount,
            width: 335.h,
            height: 335.h,
          ),
          20.verticalSpace,
          Text(
            context.tr.createAccountTitle,
            textAlign: TextAlign.center,
            style: AppStyles.s24W500.copyWith(color: context.customColor.text1),
          ),
          20.verticalSpace,
          Text(
            context.tr.createAccountDesc,
            textAlign: TextAlign.center,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
        ],
      ),
    );
  }

  Widget _buildPageTwo({required BuildContext context}) {
    List titles = [
      context.tr.createAccountTitleItem1,
      context.tr.createAccountTitleItem2,
      context.tr.createAccountTitleItem3,
    ];

    List desc = [
      context.tr.createAccountDescItem1,
      context.tr.createAccountDescItem2,
      context.tr.createAccountDescItem3,
    ];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              AppAssetImage(
                image: AppAssets.createAccount2,
                width: 335.h,
                height: 335.h,
              ),
              20.verticalSpace,
              Text(
                context.tr.createAccountDesc2,
                textAlign: TextAlign.start,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
        SliverList.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: context.customColor.border),
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.all(16.r),
              margin: EdgeInsets.only(bottom: index != 2 ? 20.r : 0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.all(20.r),
                    child: Center(child: Text('${index + 1}')),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titles[index],
                          style: AppStyles.s16W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          desc[index],
                          softWrap: true,
                          style: AppStyles.s11W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPageThree({required BuildContext context}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAssetImage(
            image: AppAssets.createAccount3,
            width: 335.h,
            height: 335.h,
          ),
          20.verticalSpace,
          Text(
            context.tr.createAccountDesc3,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          40.verticalSpace,
          Text(
            context.tr.contactUsToday,
            style: AppStyles.s20W500.copyWith(color: context.customColor.text1),
          ),
          16.verticalSpace,
          _contactWidget(text: '(+966 91 223 4567)', icon: AppAssets.phone),
          20.verticalSpace,
          _contactWidget(
            text: 'Email Us (Support@Assab.sa)',
            icon: AppAssets.email,
          ),
        ],
      ),
    );
  }

  Widget _contactWidget({required String text, required String icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(20.r),
      child: Row(
        children: [
          AppSvg(assetName: icon),
          10.horizontalSpace,
          Text(
            '${context.tr.callUs} $text',
            style: AppStyles.s12W500.copyWith(color: context.customColor.text3),
          ),
          const Spacer(),
          Icon(
            Icons.keyboard_arrow_right_outlined,
            color: context.customColor.text6,
          ),
        ],
      ),
    );
  }

  Widget _buildRowNumber() {
    return ValueListenableBuilder(
      valueListenable: _valueNotifier,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: List.generate(3, (index) {
                  final condition = value == index;

                  return Row(
                    children: [
                      CustomPagingWidget(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: condition
                              ? Border.all(color: context.customColor.text2)
                              : null,
                        ),
                        condition: condition,
                        text: '0${index + 1}',
                      ),
                      AnimatedContainerOfPagingWidget(
                        condition: condition,
                        color: context.theme.primaryColor,
                      ),
                    ],
                  );
                }),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: currentPage != 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  padding: EdgeInsets.all(10.r),
                  enableFeedback: false,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      currentPage == 0
                          ? Colors.transparent
                          : context.theme.primaryColor,
                    ),
                    side: currentPage == 0
                        ? WidgetStatePropertyAll(
                            BorderSide(color: context.customColor.border),
                          )
                        : null,
                  ),
                  icon: AppSvg(
                    assetName: AppAssets.arrowLeft,
                    colorFilter: ColorFilter.mode(
                      currentPage == 0
                          ? context.customColor.text6
                          : context.customColor.reversedTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                10.horizontalSpace,
                IconButton(
                  onPressed: currentPage != 2
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  padding: EdgeInsets.all(10.r),
                  enableFeedback: false,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      currentPage == 2
                          ? Colors.transparent
                          : context.theme.primaryColor,
                    ),
                    side: currentPage == 2
                        ? WidgetStatePropertyAll(
                            BorderSide(color: context.customColor.border),
                          )
                        : null,
                  ),
                  icon: AppSvg(
                    assetName: AppAssets.arrowRight,
                    colorFilter: ColorFilter.mode(
                      currentPage == 2
                          ? context.customColor.text6
                          : context.customColor.reversedTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
