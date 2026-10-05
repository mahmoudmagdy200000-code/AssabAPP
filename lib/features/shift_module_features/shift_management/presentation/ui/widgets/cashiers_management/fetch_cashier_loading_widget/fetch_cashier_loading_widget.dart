import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_placeholder.dart';
import 'package:flutter/material.dart';

class ShiftManagementLoadingWidget extends StatelessWidget {
  const ShiftManagementLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
          6,
          (index) => Container(
            margin: EdgeInsetsDirectional.only(
              top: 10.h,
              start: 10.w,
              end: 10.w,
            ),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              border: Border.all(color: context.customColor.border, width: 1.w),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                AppPlaceholder(
                  width: 60.w,
                  height: 65.h,
                  borderRadius: BorderRadius.circular(25.r),
                ),

                10.horizontalSpace,
                Column(
                  spacing: 10.h,
                  children: [
                    AppPlaceholder(
                      width: 60.w,
                      height: 15.h,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    AppPlaceholder(
                      width: 40.w,
                      height: 10.h,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ],
                ),
                const Spacer(),
                AppPlaceholder(
                  width: 20.w,
                  height: 20.h,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
