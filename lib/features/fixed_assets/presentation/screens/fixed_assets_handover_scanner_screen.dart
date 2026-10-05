import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FixedAssetsHandoverScannerScreen extends StatefulWidget {
  const FixedAssetsHandoverScannerScreen({super.key, this.onDetect});

  /// Called when a valid asset QR code is successfully scanned and decoded.
  /// Receives the decoded JSON map. Use this to persist or process the data.
  final Future<void> Function(Map<String, dynamic> data)? onDetect;

  @override
  State<FixedAssetsHandoverScannerScreen> createState() =>
      _FixedAssetsHandoverScannerScreenState();
}

class _FixedAssetsHandoverScannerScreenState
    extends State<FixedAssetsHandoverScannerScreen>
    with TickerProviderStateMixin {
  // ── Controllers ────────────────────────────────────────────────────────────

  late final MobileScannerController _scannerController;
  late final AnimationController _scanLineController;
  late final AnimationController _resultCardController;
  late final AnimationController _pulseController;

  // ── Animations ──────────────────────────────────────────────────────────────

  late final Animation<double> _scanLineAnimation;
  late final Animation<Offset> _resultSlideAnimation;
  late final Animation<double> _resultFadeAnimation;
  late final Animation<double> _pulseAnimation;

  // ── State ───────────────────────────────────────────────────────────────────

  bool _isProcessing = false;
  bool _flashEnabled = false;
  bool _showResult = false;
  Map<String, dynamic>? _decodedData;
  String? _errorMessage;

  // ── Accent color ────────────────────────────────────────────────────────────

  static const Color _cyan = Color(0xFF00E5FF);

  // ── Lifecycle ────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _resultCardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );

    _resultSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _resultCardController,
            curve: Curves.easeOutBack,
          ),
        );

    _resultFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _resultCardController, curve: Curves.easeIn),
    );

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _scanLineController.dispose();
    _resultCardController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ── Handlers ─────────────────────────────────────────────────────────────────

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final rawValue = capture.barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    _isProcessing = true;
    HapticFeedback.mediumImpact();

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is Map<String, dynamic>) {
        // Invoke the external callback if provided, then show the result sheet.
        if (widget.onDetect != null) {
          await widget.onDetect!(decoded);
        }

        if (!mounted) return;

        setState(() {
          _decodedData = decoded;
          _errorMessage = null;
          _showResult = true;
        });
      } else {
        setState(() {
          _errorMessage = 'QR data is not a valid JSON object.';
          _decodedData = null;
          _showResult = true;
        });
      }
    } catch (_) {
      setState(() {
        _errorMessage =
            'Failed to decode QR JSON. Make sure the QR code '
            'belongs to a valid fixed asset.';
        _decodedData = null;
        _showResult = true;
      });
    }

    await _scannerController.stop();
    await _resultCardController.forward();
    _isProcessing = false;
  }

  Future<void> _toggleFlash() async {
    await _scannerController.toggleTorch();
    setState(() => _flashEnabled = !_flashEnabled);
    HapticFeedback.lightImpact();
  }

  Future<void> _scanAgain() async {
    HapticFeedback.lightImpact();
    await _resultCardController.reverse();
    setState(() {
      _decodedData = null;
      _errorMessage = null;
      _showResult = false;
    });
    await _scannerController.start();
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final safePadding = MediaQuery.paddingOf(context);

    // Responsive frame: clamp between 220 and 300, at 65% screen width
    final frameSize = (size.width * 0.65).clamp(220.0, 300.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Camera feed
            MobileScanner(controller: _scannerController, onDetect: _onDetect),

            // Ambient vignette
            _buildVignette(),

            // Main UI
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(safePadding),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildHeadline(size),
                        _buildScanFrame(frameSize),
                        _buildStatusPill(),
                      ],
                    ),
                  ),
                  SizedBox(height: safePadding.bottom + 8),
                ],
              ),
            ),

            // Dimmer backdrop behind result sheet
            if (_showResult)
              AnimatedOpacity(
                opacity: _showResult ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: ColoredBox(
                  color: Colors.black.withOpacity(0.65),
                  child: const SizedBox.expand(),
                ),
              ),

            // Result bottom sheet
            if (_showResult)
              Align(
                alignment: Alignment.bottomCenter,
                child: FadeTransition(
                  opacity: _resultFadeAnimation,
                  child: SlideTransition(
                    position: _resultSlideAnimation,
                    child: _buildResultSheet(size, safePadding),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Widget helpers ────────────────────────────────────────────────────────────

  Widget _buildVignette() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.35, 0.65, 1.0],
          colors: [
            Colors.black.withOpacity(0.78),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.88),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(EdgeInsets safePadding) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, safePadding.top > 0 ? 6 : 14, 16, 6),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fixed Assets Scanner',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'HANDOVER MODULE',
                  style: TextStyle(
                    color: _cyan.withOpacity(0.7),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
          ),
          _CircleButton(
            icon: _flashEnabled
                ? Icons.flash_on_rounded
                : Icons.flash_off_rounded,
            accentColor: _flashEnabled ? _cyan : null,
            onTap: _toggleFlash,
          ),
        ],
      ),
    );
  }

  Widget _buildHeadline(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            'Scan Asset QR Code',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: (size.width * 0.055).clamp(18.0, 26.0),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Place the QR code inside the frame to retrieve\nasset handover details.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: (size.width * 0.033).clamp(11.0, 14.0),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanFrame(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rounded border
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
                width: 1.5,
              ),
            ),
          ),

          // Animated scan line + glow
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size * 0.1),
              child: AnimatedBuilder(
                animation: _scanLineAnimation,
                builder: (_, __) {
                  final dy = _scanLineAnimation.value * (size * 0.42);
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Soft glow band
                      Transform.translate(
                        offset: Offset(0, dy),
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                _cyan.withOpacity(0.10),
                                _cyan.withOpacity(0.14),
                                _cyan.withOpacity(0.10),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Sharp scan line
                      Transform.translate(
                        offset: Offset(0, dy),
                        child: Container(
                          height: 2.5,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                _cyan.withOpacity(0.6),
                                _cyan,
                                _cyan.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _cyan.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Accent corners
          ..._buildCorners(size),
        ],
      ),
    );
  }

  List<Widget> _buildCorners(double size) {
    final cornerSize = (size * 0.145).clamp(24.0, 44.0);
    return [
      Positioned(top: 0, left: 0, child: _ScannerCorner(size: cornerSize)),
      Positioned(
        top: 0,
        right: 0,
        child: RotatedBox(
          quarterTurns: 1,
          child: _ScannerCorner(size: cornerSize),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: RotatedBox(
          quarterTurns: 3,
          child: _ScannerCorner(size: cornerSize),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: RotatedBox(
          quarterTurns: 2,
          child: _ScannerCorner(size: cornerSize),
        ),
      ),
    ];
  }

  Widget _buildStatusPill() {
    return AnimatedOpacity(
      opacity: _showResult ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.10)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (_, __) => Opacity(
                opacity: _pulseAnimation.value,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _cyan,
                    boxShadow: [
                      BoxShadow(
                        color: _cyan.withOpacity(0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Waiting for QR code…',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSheet(Size size, EdgeInsets safePadding) {
    final isSuccess = _decodedData != null;
    final accentColor = isSuccess ? const Color(0xFF00E564) : Colors.redAccent;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(
        20,
        22,
        20,
        safePadding.bottom > 0 ? safePadding.bottom + 8 : 24,
      ),
      constraints: BoxConstraints(maxHeight: size.height * 0.72),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isSuccess
                      ? Icons.check_circle_outline_rounded
                      : Icons.error_outline_rounded,
                  color: accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSuccess ? 'QR Successfully Scanned' : 'Invalid QR Code',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isSuccess
                          ? 'Asset data retrieved'
                          : 'Could not parse JSON data',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Content
          if (isSuccess)
            _buildSuccessSummary(_decodedData!)
          else
            _buildErrorMessage(_errorMessage ?? 'Unknown error'),

          const SizedBox(height: 22),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Scan Again',
                  onPressed: _scanAgain,
                  variant: _ButtonVariant.outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: 'Continue',
                  onPressed: () => Navigator.pop(context, _decodedData),
                  variant: _ButtonVariant.filled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessSummary(Map<String, dynamic> data) {
    // Show a human-friendly count of fields, plus the asset ID if present,
    // without exposing raw JSON in the UI.
    final assetId = data['asset_id'] ?? data['id'] ?? data['assetId'];
    final fieldCount = data.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF00E564).withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00E564).withOpacity(0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (assetId != null) ...[
            Text(
              'Asset ID',
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 11,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              assetId.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Colors.white.withOpacity(0.08), height: 1),
            ),
          ],
          Row(
            children: [
              const Icon(
                Icons.check_rounded,
                color: Color(0xFF00E564),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '$fieldCount field${fieldCount == 1 ? '' : 's'} ready to process',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red.withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.redAccent.withOpacity(0.7),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable components ───────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.accentColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: (accentColor ?? Colors.white).withOpacity(0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: accentColor ?? Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _ScannerCorner extends StatelessWidget {
  const _ScannerCorner({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ScannerCornerPainter()),
    );
  }
}

class _ScannerCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.6)
        ..lineTo(0, 0)
        ..lineTo(size.width * 0.6, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum _ButtonVariant { outlined, filled }

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.variant,
  });

  final String label;
  final VoidCallback onPressed;
  final _ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final isFilled = variant == _ButtonVariant.filled;

    return SizedBox(
      height: 52,
      child: isFilled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.16)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
    );
  }
}
