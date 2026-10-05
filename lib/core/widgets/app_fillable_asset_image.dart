import 'package:flutter/material.dart';

class AppFillableAssetImage extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final double fillPercent;
  final Color fillColor;

  const AppFillableAssetImage({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    required this.fillPercent,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(image, width: width, height: height, fit: BoxFit.contain),
          ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: fillPercent,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(fillColor, BlendMode.srcATop),
                child: Image.asset(
                  image,
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
