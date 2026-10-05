import 'dart:convert';

import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

typedef QrScanCallback = void Function(Map<String, dynamic>? data);

class CustomQrScanner extends StatefulWidget {
  final QrScanCallback onDetect;

  const CustomQrScanner({super.key, required this.onDetect});

  @override
  State<CustomQrScanner> createState() => _CustomQrScannerState();
}

class _CustomQrScannerState extends State<CustomQrScanner>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final MobileScannerController _controller;
  bool _torchEnabled = false;
  bool _hasPermission = false;
  bool _isCheckingPermission = true;
  bool _scanned = false;
  DateTime? _lastScanTime;
  bool? _isSuccess;

  late AnimationController _borderAnimationController;
  late AnimationController _successAnimationController;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _successScaleAnimation;

  static const _minScanInterval = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
    _initializeScanner();
  }

  void _initializeAnimations() {
    _borderAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _borderColorAnimation = ColorTween(begin: Colors.white, end: Colors.green)
        .animate(
          CurvedAnimation(
            parent: _borderAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    _successScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _successAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateBorderColor();
  }

  void _updateBorderColor() {
    _borderColorAnimation =
        ColorTween(
          begin: context.customColor.reversedTextColor,
          end: Colors.green,
        ).animate(
          CurvedAnimation(
            parent: _borderAnimationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _hasPermission) _restartScanner();
  }

  Future<void> _initializeScanner() async {
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
      autoStart: false,
    );

    await _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      _setPermissionState(true);
    } else {
      final result = await Permission.camera.request();

      _setPermissionState(result.isGranted);

      if (!result.isGranted && mounted) _showPermissionDialog();
    }

    if (mounted) setState(() => _isCheckingPermission = false);
  }

  void _setPermissionState(bool hasPermission) async {
    if (mounted) {
      setState(() => _hasPermission = hasPermission);
      if (hasPermission) {
        await _controller.start();
      }
    }
  }

  void _showPermissionDialog() {
    AppDialog.showCustomDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          context.tr.cameraPermissionRequired,
          style: AppStyles.s18W600.copyWith(color: context.customColor.text1),
        ),
        content: Text(
          context.tr.qrDesc,
          style: AppStyles.s14W400.copyWith(color: context.customColor.text1),
        ),
        actions: [
          TextButton(
            onPressed: () {
              NavigationService.I.pop();
              NavigationService.I.pop();
              openAppSettings();
            },
            child: Text(
              context.tr.openSettings,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              NavigationService.I.pop();
              NavigationService.I.pop();
            },
            child: Text(
              context.tr.cancel,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _restartScanner() async {
    if (!_hasPermission || !mounted) return;

    try {
      await _controller.stop();

      await Future.delayed(const Duration(milliseconds: 100));

      await _controller.start();

      if (mounted) {
        setState(() => _scanned = false);
        _resetAnimations();
      }
    } catch (e) {
      AppLogger.log('Error restarting scanner: $e');

      if (mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _hasPermission) _restartScanner();
        });
      }
    }
  }

  void _resetAnimations() {
    _borderAnimationController.reset();
    _successAnimationController.reset();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned || !_hasPermission) return;

    final now = DateTime.now();

    if (_lastScanTime != null &&
        now.difference(_lastScanTime!) < _minScanInterval) {
      return;
    }

    if (capture.barcodes.isEmpty) return;

    final barcode = capture.barcodes.first.rawValue;

    if (barcode == null || barcode.isEmpty) return;

    _processBarcode(barcode);
  }

  Map<String, dynamic>? parseZatcaQr(String base64Qr) {
    try {
      final bytes = base64Decode(base64Qr);
      final Map<String, dynamic> fields = {};
      int offset = 0;

      while (offset < bytes.length) {
        if (offset + 1 >= bytes.length) break;
        final int tag = bytes[offset];
        offset++;
        if (offset >= bytes.length) break;
        final int length = bytes[offset];
        offset++;
        if (offset + length > bytes.length) break;

        final valueBytes = bytes.sublist(offset, offset + length);
        final String value = utf8.decode(valueBytes, allowMalformed: true);

        switch (tag) {
          case 1:
            fields['seller_name'] = value.trim();
            break;
          case 2:
            fields['seller_vat'] = value.trim();
            break;
          case 3:
            fields['invoice_date'] = value.trim();
            break;
          case 4:
            fields['total_with_vat'] = value.trim().replaceAll(',', '');
            break;
          case 5:
            fields['vat_amount'] = value.trim().replaceAll(',', '');
            break;
        }
        offset += length;
      }

      if (fields.containsKey('total_with_vat') &&
          fields.containsKey('vat_amount')) {
        final double total = double.parse(fields['total_with_vat']);
        final double vat = double.parse(fields['vat_amount']);
        final double net = total - vat;
        fields['net_amount'] = net.toStringAsFixed(2);
      }

      fields['invoice_number'] = fields['seller_vat'] ?? '';

      if (!fields.containsKey('total_with_vat') ||
          !fields.containsKey('vat_amount')) {
        return null;
      }

      return fields;
    } catch (e) {
      return null;
    }
  }

  Future<void> _processBarcode(String barcode) async {
    _lastScanTime = DateTime.now();
    _scanned = true;

    await _controller.stop();

    final parsedData = parseZatcaQr(barcode);

    if (parsedData == null) {
      _startResultAnimation(success: false);
      setState(() => _isSuccess = false);
      return;
    }

    _startResultAnimation(success: true);
    setState(() => _isSuccess = true);

    await Future.delayed(const Duration(milliseconds: 500));

    widget.onDetect(parsedData);

    if (mounted) NavigationService.I.pop(parsedData);
  }

  void _startResultAnimation({required bool success}) {
    _borderAnimationController.reset();
    _successAnimationController.reset();

    final endColor = success ? Colors.green : Colors.red;

    _borderColorAnimation =
        ColorTween(
          begin: context.customColor.reversedTextColor,
          end: endColor,
        ).animate(
          CurvedAnimation(
            parent: _borderAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    _borderAnimationController.forward();
    _successAnimationController.forward();
  }

  Future<void> _toggleTorch() async {
    await _controller.toggleTorch();
    if (mounted) {
      setState(
        () => _torchEnabled = _controller.value.torchState == TorchState.on,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _borderAnimationController.dispose();
    _successAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingPermission) {
      return Scaffold(
        backgroundColor: context.customColor.reversedTextColor,
        body: const AppLoadingWidget(),
      );
    }

    if (!_hasPermission) {
      return Scaffold(
        backgroundColor: context.customColor.reversedTextColor,
        body: Center(child: Text(context.tr.cameraPermissionRequired)),
      );
    }

    double boxSize = 250.r;
    double borderRadius = 24.r;

    return Scaffold(
      backgroundColor: context.customColor.reversedTextColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final center = Offset(
            constraints.maxWidth / 2,
            constraints.maxHeight / 2,
          );
          final scanRect = Rect.fromCenter(
            center: center,
            width: boxSize,
            height: boxSize,
          );
          return Stack(
            children: [
              MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
                scanWindow: scanRect,
              ),
              _buildRoundedOverlay(scanRect, borderRadius),
              Center(
                child: AnimatedBuilder(
                  animation: _borderAnimationController,
                  builder: (context, child) {
                    return Container(
                      width: boxSize,
                      height: boxSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          color:
                              _borderColorAnimation.value ??
                              context.customColor.reversedTextColor,
                          width: 3.w,
                        ),
                      ),
                      child: _buildResultAnimation(),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 60.h,
                left: 0,
                right: 0,
                child: Center(
                  child: _buildIconButton(
                    icon: Icons.flash_on,
                    active: _torchEnabled,
                    onTap: _toggleTorch,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultAnimation() {
    if (_isSuccess == null) return const SizedBox.shrink();

    final isSuccess = _isSuccess!;
    final color = isSuccess ? Colors.green : context.customColor.error;
    final icon = isSuccess ? Icons.check : Icons.refresh;

    return AnimatedBuilder(
      animation: _successAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _successScaleAnimation.value,
          child: AppGestureDetectorButton(
            onTap: isSuccess ? () {} : _restartScanner,
            child: Icon(icon, color: color, size: 60.r),
          ),
        );
      },
    );
  }

  Widget _buildRoundedOverlay(Rect scanRect, double borderRadius) {
    return Positioned.fill(
      child: ClipPath(
        clipper: _ScannerClipper(scanRect, borderRadius),
        child: Container(
          color: context.customColor.reversedTextColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: active
              ? context.customColor.reversedTextColor.withValues(alpha: 0.2)
              : context.customColor.text6,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: context.customColor.reversedTextColor,
          size: 28.r,
        ),
      ),
    );
  }
}

class _ScannerClipper extends CustomClipper<Path> {
  final Rect scanRect;
  final double borderRadius;

  _ScannerClipper(this.scanRect, this.borderRadius);

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(0)),
      )
      ..addRRect(
        RRect.fromRectAndRadius(scanRect, Radius.circular(borderRadius)),
      )
      ..fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
