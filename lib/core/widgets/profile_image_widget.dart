import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import 'app_asset_image.dart';
import 'app_network_image.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? image;
  final double? width;
  final double? height;

  const ProfileImageWidget({super.key, this.image, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return image == null
        ? AppAssetImage(
            image: AppAssets.testProfile,
            width: width ?? 50.w,
            height: height ?? 50.w,
            borderRadius: BorderRadius.circular(1000.w),
          )
        : AppNetworkImage(
            image: image!,
            width: width ?? 50.w,
            height: height ?? 50.w,
            borderRadius: BorderRadius.circular(1000.w),
          );
  }
}
