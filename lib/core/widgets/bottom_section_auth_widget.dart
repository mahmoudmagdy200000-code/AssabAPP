import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import 'app_asset_image.dart';

class BottomSectionAuthWidget extends StatelessWidget {
  final List<Widget> listWidgets;

  const BottomSectionAuthWidget({super.key, required this.listWidgets});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          AppAssetImage(image: AppAssets.row, width: 280.w, height: 15.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.r),
                  topRight: Radius.circular(25.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: SingleChildScrollView(
                child: Column(children: listWidgets),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
