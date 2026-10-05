import 'package:flutter/material.dart';

import '../../../../domain/entity/network_image_item.dart';
import '../network_image_preview_widget.dart';

class VarianceNetworkImagesPreviewWidget extends StatelessWidget {
  const VarianceNetworkImagesPreviewWidget({
    super.key,
    this.padding,
    required this.images,
  });
  final EdgeInsets? padding;
  final List<NetworkImageItem> images;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: images.length,
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          NetworkImagePreviewWidget(image: images[index]),
    );
  }
}
