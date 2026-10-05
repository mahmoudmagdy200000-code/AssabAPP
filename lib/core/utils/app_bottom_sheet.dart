import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extensions.dart';
import '../../core/extensions/number_extensions.dart';

class AppBottomSheet {
  const AppBottomSheet._();

  static void show(
    BuildContext context,
    WidgetBuilder builder, {
    ShapeBorder? shape,
    bool showDragHandle = true,
    bool enableDrag = true,
  }) {
    showBottomSheet(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            side: BorderSide(color: context.customColor.border, width: 1.2),
          ),
      showDragHandle: showDragHandle,
      enableDrag: enableDrag,
      context: context,
      builder: builder,
    );
  }

  static Future<T?> showModal<T>(
    BuildContext context,
    WidgetBuilder builder, {
    ShapeBorder? shape,
    bool enableDrag = true,
    bool isDismissible = true,
    bool showDragHandle = true,
    bool isScrollControlled = false,
    bool useSafeArea = false,
  }) async {
    return await showModalBottomSheet<T>(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      showDragHandle: showDragHandle,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      context: context,
      builder: builder,
    );
  }

  static Future<T?> pageRoute<T>(
    BuildContext context,
    WidgetBuilder builder, {
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutCubic,
    bool fullscreenDialog = false,
  }) {
    return NavigationService.I.push<T>(
      PageRouteBuilder(
        fullscreenDialog: fullscreenDialog,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        pageBuilder: (context, animation, secondaryAnimation) {
          return AppScaffold(
            child: Column(
              children: [
                10.verticalSpace,
                Container(
                  width: 150.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: context.customColor.text1,
                    borderRadius: BorderRadius.circular(1000.r),
                  ),
                ),
                10.verticalSpace,
                builder(context),
              ],
            ),
          );
        },
        transitionsBuilder: (_, animation, _, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  static Future<T?> customPageRoute<T>(
    BuildContext context,
    WidgetBuilder builder, {
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutCubic,
    bool fullscreenDialog = false,
  }) {
    return NavigationService.I.push<T>(
      PageRouteBuilder(
        fullscreenDialog: fullscreenDialog,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        pageBuilder: (context, animation, secondaryAnimation) {
          return builder(context);
        },
        transitionsBuilder: (_, animation, _, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }
}
