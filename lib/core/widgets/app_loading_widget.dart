import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/extensions/build_context_extensions.dart';
import '../../core/extensions/number_extensions.dart';

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: context.theme.primaryColor,
        size: 30.r,
      ),
    );
  }
}
