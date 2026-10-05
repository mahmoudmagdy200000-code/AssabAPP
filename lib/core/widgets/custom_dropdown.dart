import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/dropdown/dropdown_cubit.dart';
import '../cubits/dropdown/dropdown_state.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, bool isSelected)
  itemBuilder;
  final ValueChanged<T> onChanged;
  final String? hint;
  final double dropdownHeight;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double iconSize;
  final Color? iconColor;
  final String Function(T? value)? displayTextBuilder;
  final T? initialValue;
  final Color? displayTextColor;
  final double? displayTextSize;
  final FontWeight? displayTextWeight;
  final bool autoSelectIfInvalid;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
    this.hint,
    this.dropdownHeight = 200,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.iconSize = 24,
    this.iconColor,
    this.displayTextBuilder,
    this.initialValue,
    this.displayTextColor,
    this.displayTextSize,
    this.displayTextWeight,
    this.autoSelectIfInvalid = false,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  late final DropdownCubit<T> _cubit;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _cubit = DropdownCubit<T>(initialValue: widget.initialValue);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(covariant CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue) {
      if (widget.initialValue == null) {
        _cubit.clear();
      } else {
        _cubit.select(widget.initialValue as T);
      }
    }

    if (identical(widget.items, oldWidget.items) ||
        !widget.autoSelectIfInvalid ||
        widget.items.isEmpty) {
      return;
    }

    final currentValue = _cubit.state.value;

    final shouldAutoSelect =
        currentValue == null || !widget.items.contains(currentValue);

    if (shouldAutoSelect) {
      final firstItem = widget.items.first;
      _cubit.select(firstItem);
      widget.onChanged(firstItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<DropdownCubit<T>, DropdownState<T>>(
        listenWhen: (p, c) => p.isOpen != c.isOpen,
        listener: (context, state) {
          if (state.isOpen) {
            _showOverlay(context);
            _controller.forward();
          } else {
            _controller.reverse().then((_) {
              _removeOverlay();
            });
          }
        },
        child: BlocBuilder<DropdownCubit<T>, DropdownState<T>>(
          builder: (context, state) {
            return CompositedTransformTarget(
              link: _layerLink,
              child: AppGestureDetectorButton(
                onTap: () => context.read<DropdownCubit<T>>().toggle(),
                child: Container(
                  padding:
                      widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 12,
                    ),
                    border: Border.all(
                      color: widget.borderColor ?? context.customColor.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.displayTextBuilder?.call(state.value) ??
                              widget.hint ??
                              'Select an option',
                          style: TextStyle(
                            color: state.value == null
                                ? context.customColor.text3
                                : widget.displayTextColor ??
                                      context.customColor.text1,
                            fontSize: widget.displayTextSize,
                            fontWeight:
                                widget.displayTextWeight ?? FontWeight.w400,
                          ),
                        ),
                      ),
                      Icon(
                        state.isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: widget.iconSize,
                        color:
                            widget.iconColor ??
                            widget.displayTextColor ??
                            context.customColor.text1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final cubit = context.read<DropdownCubit<T>>();

    _overlayEntry = OverlayEntry(
      builder: (_) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: Offset(0, size.height + 5.r),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Material(
                  elevation: 6.r,
                  borderRadius: BorderRadius.circular(12.r),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: widget.dropdownHeight,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final isSelected = cubit.state.value == item;

                        return InkWell(
                          onTap: () {
                            cubit.select(item);
                            widget.onChanged(item);
                          },
                          child: widget.itemBuilder(context, item, isSelected),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }
}
