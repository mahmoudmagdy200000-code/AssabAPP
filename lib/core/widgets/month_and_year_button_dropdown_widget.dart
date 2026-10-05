import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
import 'app_padding_widget.dart';

class MonthAndYearButtonDropdownWidget extends StatelessWidget {
  final List text;
  final void Function(int index) onTap;
  final String? selectedText;

  const MonthAndYearButtonDropdownWidget({
    super.key,
    required this.text,
    required this.onTap,
    required this.selectedText,
  });

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.tr.selectMonth,
            style: AppStyles.s24W500.copyWith(color: context.customColor.text1),
          ),
          18.verticalSpace,
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.only(bottom: 20.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.2.r,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: text.length,
              itemBuilder: (context, index) {
                final isSelected = selectedText == text[index].toString();

                return InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () {
                    onTap(index);
                    NavigationService.I.pop();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.theme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSelected
                            ? context.theme.primaryColor
                            : context.customColor.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${text[index]}',
                        style: isSelected
                            ? AppStyles.s16W500.copyWith(
                                color: context.customColor.reversedTextColor,
                              )
                            : AppStyles.s16W400.copyWith(
                                color: context.customColor.text1,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
