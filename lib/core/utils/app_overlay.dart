import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../services/navigation/navigation_service.dart';
import '../styles/app_styles.dart';

class AppOverlay {
  AppOverlay._();

  static late OverlayEntry? _errorOverlay;
  static OverlayEntry? _customOverlay;
  static bool _isShowingOverlay = false;
  static bool _isShowingCustomOverlay = false;

  static void showErrorOverlay({String? message}) {
    if (_isShowingOverlay) return;

    _isShowingOverlay = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rootContext = WidgetsBinding.instance.rootElement;
      if (rootContext == null) {
        _isShowingOverlay = false;

        return;
      }

      _errorOverlay = OverlayEntry(
        builder: (overlayContext) => AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            color: AppColors.lightText.withValues(alpha: 0.5),
            child: Center(
              child: Material(
                borderRadius: BorderRadius.circular(16.r),
                color: Theme.of(overlayContext).scaffoldBackgroundColor,
                elevation: 0,
                child: Container(
                  width: 320.w,
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48.r),
                      16.verticalSpace,
                      Text(
                        message ?? S.current.somethingWentWrong,
                        style: AppStyles.s18W500.copyWith(
                          color: AppColors.lightText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      20.verticalSpace,
                      ElevatedButton(
                        onPressed: hideErrorAppOverlay,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.r,
                            vertical: 12.r,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          S.current.ok,
                          style: AppStyles.s15W400.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final navigatorState = NavigationService.I.navigatorKey.currentState;
      if (navigatorState?.overlay != null) {
        navigatorState!.overlay!.insert(_errorOverlay!);
      } else {
        _isShowingOverlay = false;
      }
    });
  }

  static void hideErrorAppOverlay() {
    _errorOverlay?.remove();
    _errorOverlay = null;
    _isShowingOverlay = false;
  }

  static void showCustomOverlay({
    required Widget child,
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
    bool animated = true,
  }) {
    if (_isShowingCustomOverlay) return;
    _isShowingCustomOverlay = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _customOverlay = OverlayEntry(
        builder: (context) => _CustomOverlayWrapper(
          barrierColor: barrierColor,
          animated: animated,
          onBarrierTap: barrierDismissible ? hideCustomOverlay : null,
          child: child,
        ),
      );

      final overlay = NavigationService.I.navigatorKey.currentState?.overlay;
      if (overlay != null) {
        overlay.insert(_customOverlay!);
      } else {
        _isShowingCustomOverlay = false;
      }
    });
  }

  static void hideCustomOverlay() {
    _customOverlay?.remove();
    _customOverlay = null;
    _isShowingCustomOverlay = false;
  }
}

class _CustomOverlayWrapper extends StatefulWidget {
  final Widget child;
  final Color barrierColor;
  final bool animated;
  final VoidCallback? onBarrierTap;

  const _CustomOverlayWrapper({
    required this.child,
    required this.barrierColor,
    required this.animated,
    this.onBarrierTap,
  });

  @override
  State<_CustomOverlayWrapper> createState() => _CustomOverlayWrapperState();
}

class _CustomOverlayWrapperState extends State<_CustomOverlayWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.animated) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      children: [
        // Barrier
        GestureDetector(
          onTap: widget.onBarrierTap,
          child: Container(color: widget.barrierColor),
        ),
        // Content
        Center(
          child: widget.animated
              ? FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(position: _slide, child: widget.child),
                )
              : widget.child,
        ),
      ],
    );

    return widget.animated
        ? FadeTransition(opacity: _fade, child: content)
        : content;
  }
}
