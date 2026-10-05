import 'dart:async';
import 'package:flutter/material.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import '../styles/app_colors.dart';

class AppSnackBar {
  const AppSnackBar._();

  static OverlayEntry? _currentEntry;
  static const int _defaultDuration = 2400;

  static void showSuccess(
    BuildContext context,
    String message, {
    int milliseconds = _defaultDuration,
  }) {
    _show(
      context,
      message,
      milliseconds: milliseconds,
      gradient: LinearGradient(
        colors: [
          context.customColor.reversedTextColor,
          context.customColor.reversedTextColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.check_circle_rounded,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    int milliseconds = _defaultDuration,
  }) {
    _show(
      context,
      message,
      milliseconds: milliseconds,
      gradient: const LinearGradient(
        colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.error_rounded,
      textColor: context.customColor.reversedTextColor,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required int milliseconds,
    required Gradient gradient,
    required IconData icon,
    Color? textColor,
  }) {
    _removeCurrent();

    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _AnimatedSnackBar(
        message: message,
        gradient: gradient,
        icon: icon,
        duration: Duration(milliseconds: milliseconds),
        textColor: textColor,
        onFinish: () {
          entry.remove();
          if (_currentEntry == entry) {
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void _removeCurrent() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _AnimatedSnackBar extends StatefulWidget {
  final String message;
  final Gradient gradient;
  final IconData icon;
  final Duration duration;
  final Color? textColor;
  final VoidCallback onFinish;

  const _AnimatedSnackBar({
    required this.message,
    required this.gradient,
    required this.icon,
    required this.duration,
    this.textColor,
    required this.onFinish,
  });

  @override
  State<_AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slide = Tween<Offset>(
      begin: Offset(0, -0.3.h),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    _timer = Timer(widget.duration, () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onFinish();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.customColor.reversedTextColor;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16.w,
      right: 16.w,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 18.r,
                    offset: Offset(0, 6.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 12.r,
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColors.lightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(widget.icon, color: color, size: 18.r),
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Text(
                            widget.message,
                            style: AppStyles.s14W400.copyWith(
                              color:
                                  widget.textColor ?? context.customColor.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(14.r),
                    ),
                    child: TweenAnimationBuilder<double>(
                      duration: widget.duration,
                      tween: Tween(begin: 0, end: 1),
                      builder: (_, value, _) {
                        return LinearProgressIndicator(
                          value: value,
                          minHeight: 6.h,
                          backgroundColor: Colors.white.withValues(alpha: 0.25),
                          valueColor: AlwaysStoppedAnimation(
                            context.theme.primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
