// ignore_for_file: deprecated_member_use
import 'dart:math' as math;

import 'package:flutter/gestures.dart' show PointerScrollEvent;
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ENUMS & EXTENSIONS
// ═══════════════════════════════════════════════════════════════════════════════

enum BranchStatus { highRisk, risk, caution, safe, verySafe }

extension BranchStatusExtension on BranchStatus {
  String get label {
    switch (this) {
      case BranchStatus.highRisk:
        return 'High Risk';
      case BranchStatus.risk:
        return 'Risk';
      case BranchStatus.caution:
        return 'Caution';
      case BranchStatus.safe:
        return 'Safe';
      case BranchStatus.verySafe:
        return 'Very Safe';
    }
  }

  Color get color {
    switch (this) {
      case BranchStatus.highRisk:
        return const Color(0xFF9E9E9E);
      case BranchStatus.risk:
        return const Color(0xFFE05C6A);
      case BranchStatus.caution:
        return const Color(0xFFD4A843);
      case BranchStatus.safe:
        return const Color(0xFF6BBF6A);
      case BranchStatus.verySafe:
        return const Color(0xFF3DAF5C);
    }
  }

  Color get areaColor {
    switch (this) {
      case BranchStatus.highRisk:
        return const Color(0xFFBBBBBB);
      case BranchStatus.risk:
        return const Color(0xFFE05C6A);
      case BranchStatus.caution:
        return const Color(0xFFD4A843);
      case BranchStatus.safe:
        return const Color(0xFF6BBF6A);
      case BranchStatus.verySafe:
        return const Color(0xFF3DAF5C);
    }
  }

  Color get badgeColor {
    switch (this) {
      case BranchStatus.highRisk:
        return const Color(0xFF555555);
      case BranchStatus.risk:
        return const Color(0xFFCC3344);
      case BranchStatus.caution:
        return const Color(0xFF9A7000);
      case BranchStatus.safe:
        return const Color(0xFF3A8A3A);
      case BranchStatus.verySafe:
        return const Color(0xFF2A7A3A);
    }
  }

  IconData get icon {
    switch (this) {
      case BranchStatus.highRisk:
        return Icons.error_outline_rounded;
      case BranchStatus.risk:
        return Icons.warning_amber_rounded;
      case BranchStatus.caution:
        return Icons.info_outline_rounded;
      case BranchStatus.safe:
        return Icons.check_circle_outline_rounded;
      case BranchStatus.verySafe:
        return Icons.verified_rounded;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STATIC CHART CONFIGURATION
// ═══════════════════════════════════════════════════════════════════════════════

class AxisConfig {
  final double yMin;
  final double yMax;
  final double yStep;
  final double xMinPct;
  final double xMaxPct;

  const AxisConfig({
    this.yMin = 50000,
    this.yMax = 400000,
    this.yStep = 50000,
    this.xMinPct = -0.50,
    this.xMaxPct = 0.40,
  });

  AxisConfig copyWith({
    double? yMin,
    double? yMax,
    double? yStep,
    double? xMinPct,
    double? xMaxPct,
  }) => AxisConfig(
    yMin: yMin ?? this.yMin,
    yMax: yMax ?? this.yMax,
    yStep: yStep ?? this.yStep,
    xMinPct: xMinPct ?? this.xMinPct,
    xMaxPct: xMaxPct ?? this.xMaxPct,
  );
}

// ─── Zone bands ───────────────────────────────────────────────────────────────

abstract class ZoneBandDef {
  final double lowerBoundary;
  final double upperBoundary;
  final bool drawUpperLine;

  const ZoneBandDef({
    required this.lowerBoundary,
    required this.upperBoundary,
    this.drawUpperLine = false,
  });

  Color get lowerLineColor;

  Color get upperLineColor => const Color(0xFF6BBF6A);

  String get labelText;

  String get legendText => labelText.split(' (').first;

  Color get labelColor;

  Color get legendSwatchColor => labelColor;
}

class BreakEvenZoneBand extends ZoneBandDef {
  const BreakEvenZoneBand({
    required super.lowerBoundary,
    required super.upperBoundary,
  });

  @override
  Color get lowerLineColor => Colors.transparent;

  @override
  String get labelText => 'Break-even Zone (100%)';

  @override
  Color get labelColor => const Color(0xFF777777);
}

class DangerZoneBand extends ZoneBandDef {
  const DangerZoneBand({
    required super.lowerBoundary,
    required super.upperBoundary,
  });

  @override
  Color get lowerLineColor => const Color(0xFF9E9E9E);

  @override
  String get labelText => 'Danger Zone (<100%)';

  @override
  Color get labelColor => const Color(0xFFCC4455);
}

class CautionZoneBand extends ZoneBandDef {
  const CautionZoneBand({
    required super.lowerBoundary,
    required super.upperBoundary,
  });

  @override
  Color get lowerLineColor => const Color(0xFFE05C6A);

  @override
  String get labelText => 'Caution Zone (100–120%)';

  @override
  Color get labelColor => const Color(0xFFAA8800);
}

class SafeZoneBand extends ZoneBandDef {
  const SafeZoneBand({
    required super.lowerBoundary,
    required super.upperBoundary,
  }) : super(drawUpperLine: true);

  @override
  Color get lowerLineColor => const Color(0xFFD4A843);

  @override
  Color get upperLineColor => const Color(0xFF6BBF6A);

  @override
  String get labelText => 'Safe Zone (>120%)';

  @override
  Color get labelColor => const Color(0xFF4A9A4A);
}

class ZoneBands {
  final BreakEvenZoneBand breakEvenZone;
  final DangerZoneBand dangerZone;
  final CautionZoneBand cautionZone;
  final SafeZoneBand safeZone;

  const ZoneBands({
    required this.breakEvenZone,
    required this.dangerZone,
    required this.cautionZone,
    required this.safeZone,
  });

  List<ZoneBandDef> get ordered => [
    breakEvenZone,
    dangerZone,
    cautionZone,
    safeZone,
  ];
}

// ─── App-level constants ──────────────────────────────────────────────────────

const kDefaultAxisConfig = AxisConfig();

const kDefaultZoneBands = ZoneBands(
  breakEvenZone: BreakEvenZoneBand(lowerBoundary: 50000, upperBoundary: 140000),
  dangerZone: DangerZoneBand(lowerBoundary: 140000, upperBoundary: 225000),
  cautionZone: CautionZoneBand(lowerBoundary: 225000, upperBoundary: 325000),
  safeZone: SafeZoneBand(lowerBoundary: 325000, upperBoundary: 400000),
);

// ═══════════════════════════════════════════════════════════════════════════════
// DATA MODEL — only what the API provides
// ═══════════════════════════════════════════════════════════════════════════════

/// Only 4 values come from the API.
/// [status] is computed automatically from [currentPointY] against zone boundaries.
/// Only 4 values come from the API.
/// [status] is computed automatically from [currentPointY] against zone boundaries.
///
/// X positions are accepted as INTEGER percent values in the range -50..+40
/// (matching the chart's X-axis labels: -50%, -40%, ..., 0%, ..., +40%).
/// They are stored internally as normalized doubles (-0.50..+0.40).
///
/// Use the named constructor [BreakEvenChartData.fromApiValues] to pass the
/// raw integer values directly from the API response.
class BreakEvenChartData {
  /// X position in data-space (−0.50 … +0.40). Do not set directly from API —
  /// use [fromApiValues] which accepts the integer range −50 … +40.
  final double currentPointX;

  /// Y position (sales value) of the current sales dot.
  final double currentPointY;

  /// X position in data-space (−0.50 … +0.40). Do not set directly from API —
  /// use [fromApiValues] which accepts the integer range −50 … +40.
  final double fixedCostX;

  /// Y position (sales value) of the fixed-cost dot.
  final double fixedCostY;

  const BreakEvenChartData({
    required this.currentPointX,
    required this.currentPointY,
    required this.fixedCostX,
    required this.fixedCostY,
  });

  /// Create from raw API integer percent values.
  ///
  /// [currentPointXInt] — integer in -50..+40, e.g. -10 means -10% on X axis.
  /// [fixedCostXInt]    — integer in -50..+40, e.g. -30 means -30% on X axis.
  ///
  /// Values are clamped to the valid range so out-of-range API responses
  /// never break the chart.
  factory BreakEvenChartData.fromApiValues({
    required int currentPointXInt,
    required double currentPointY,
    required int fixedCostXInt,
    required double fixedCostY,
  }) {
    return BreakEvenChartData(
      currentPointX: currentPointXInt.clamp(-50, 40) / 100.0,
      currentPointY: currentPointY,
      fixedCostX: fixedCostXInt.clamp(-50, 40) / 100.0,
      fixedCostY: fixedCostY,
    );
  }

  /// Derived from [currentPointY] against fixed zone boundaries.
  /// Never from the API.
  BranchStatus get status {
    final y = currentPointY;
    if (y < 140000) return BranchStatus.highRisk;
    if (y < 225000) return BranchStatus.risk;
    if (y < 325000) return BranchStatus.caution;
    if (y <= 400000) return BranchStatus.safe;
    return BranchStatus.verySafe;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreakEvenChartData &&
          currentPointX == other.currentPointX &&
          currentPointY == other.currentPointY &&
          fixedCostX == other.fixedCostX &&
          fixedCostY == other.fixedCostY;

  @override
  int get hashCode =>
      currentPointX.hashCode ^
      currentPointY.hashCode ^
      fixedCostX.hashCode ^
      fixedCostY.hashCode;
}

// ═══════════════════════════════════════════════════════════════════════════════
// MOCK DATA
// ═══════════════════════════════════════════════════════════════════════════════

final List<BreakEvenChartData> mockBranches = [
  BreakEvenChartData.fromApiValues(
    currentPointXInt: -10,
    currentPointY: 82000,
    fixedCostXInt: -30,
    fixedCostY: 85200,
  ),
  BreakEvenChartData.fromApiValues(
    currentPointXInt: 0,
    currentPointY: 150000,
    fixedCostXInt: -25,
    fixedCostY: 85200,
  ),
  BreakEvenChartData.fromApiValues(
    currentPointXInt: 10,
    currentPointY: 265000,
    fixedCostXInt: -20,
    fixedCostY: 85200,
  ),
  BreakEvenChartData.fromApiValues(
    currentPointXInt: 15,
    currentPointY: 316000,
    fixedCostXInt: -15,
    fixedCostY: 85200,
  ),
];

// ═══════════════════════════════════════════════════════════════════════════════
// VIEWPORT
// ═══════════════════════════════════════════════════════════════════════════════

class ChartViewport extends ValueNotifier<_ViewportState> {
  ChartViewport() : super(_ViewportState.identity());

  static const double minZoom = 1.0;
  static const double maxZoom = 4.0;

  void zoomBy(double scaleDelta, double focalPct) {
    final cur = value;
    final newZoom = (cur.zoom * scaleDelta).clamp(minZoom, maxZoom);
    final newPan = focalPct - (focalPct - cur.panPct) * (newZoom / cur.zoom);
    value = _ViewportState(zoom: newZoom, panPct: _clampPan(newPan, newZoom));
  }

  void panBy(double deltaPct) {
    final cur = value;
    value = _ViewportState(
      zoom: cur.zoom,
      panPct: _clampPan(cur.panPct + deltaPct, cur.zoom),
    );
  }

  void reset() => value = _ViewportState.identity();

  double _clampPan(double p, double zoom) {
    final a = kDefaultAxisConfig;
    final full = a.xMaxPct - a.xMinPct;
    final vis = full / zoom;
    final maxPan = (full - vis) / 2;
    return p.clamp(-maxPan, maxPan);
  }

  AxisConfig effectiveAxis() {
    final cur = value;
    final a = kDefaultAxisConfig;
    final full = a.xMaxPct - a.xMinPct;
    final center = (a.xMinPct + a.xMaxPct) / 2 + cur.panPct;
    final vis = full / cur.zoom;
    return a.copyWith(xMinPct: center - vis / 2, xMaxPct: center + vis / 2);
  }
}

class _ViewportState {
  final double zoom;
  final double panPct;

  const _ViewportState({required this.zoom, required this.panPct});

  factory _ViewportState.identity() =>
      const _ViewportState(zoom: 1.0, panPct: 0.0);
}

// ═══════════════════════════════════════════════════════════════════════════════
// CROSSHAIR
// ═══════════════════════════════════════════════════════════════════════════════

class CrosshairState {
  final double? pct;

  const CrosshairState({this.pct});

  static const none = CrosshairState();

  bool get isActive => pct != null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LAYOUT SCALE
// ═══════════════════════════════════════════════════════════════════════════════

class _ChartScale {
  final Size canvasSize;
  late final double leftPad, rightPad, topPad, bottomPad;
  late final double plotW, plotH, plotL, plotT;
  late final double axisLabelFontSize, zoneLabelFontSize, tooltipFontSize;
  late final double markerLabelFontSize, axisTitleFontSize, legendFontSize;
  late final double dotRadius, dotGlowRadius, dotInnerRadius, dotStrokeWidth;
  late final double curveStrokeWidth, dashedLineWidth, gridLineWidth;
  late final double zoneLineWidth, tickWidth;
  late final double tooltipHPad, tooltipVPad, tooltipRadius;
  late final double tooltipArrowH, tooltipArrowHW;

  _ChartScale(this.canvasSize) {
    final sw = canvasSize.width.clamp(200.0, 1200.0);
    final sh = canvasSize.height.clamp(160.0, 800.0);
    final sf = sw / 360.0;

    leftPad = (44.0 * sf).clamp(36.0, 72.0);
    rightPad = (16.0 * sf).clamp(12.0, 28.0);
    topPad = (20.0 * sf).clamp(16.0, 36.0);
    bottomPad = (44.0 * (sh / 220.0)).clamp(36.0, 64.0);
    plotW = sw - leftPad - rightPad;
    plotH = sh - topPad - bottomPad;
    plotL = leftPad;
    plotT = topPad;

    axisLabelFontSize = (8.0 * sf).clamp(7.0, 11.0);
    zoneLabelFontSize = (8.0 * sf).clamp(7.0, 11.0);
    tooltipFontSize = (9.5 * sf).clamp(8.0, 13.0);
    markerLabelFontSize = (8.5 * sf).clamp(7.5, 12.0);
    axisTitleFontSize = (10.0 * sf).clamp(8.5, 14.0);
    legendFontSize = (8.5 * sf).clamp(7.5, 11.0);

    dotRadius = (6.0 * sf).clamp(5.0, 9.0);
    dotGlowRadius = (9.0 * sf).clamp(7.0, 13.0);
    dotInnerRadius = (2.0 * sf).clamp(1.8, 3.0);
    dotStrokeWidth = (1.8 * sf).clamp(1.4, 2.6);

    curveStrokeWidth = (2.0 * sf).clamp(1.5, 3.0);
    dashedLineWidth = (0.8 * sf).clamp(0.6, 1.4);
    gridLineWidth = (0.5 * sf).clamp(0.4, 0.8);
    zoneLineWidth = (1.4 * sf).clamp(1.0, 2.0);
    tickWidth = (0.8 * sf).clamp(0.6, 1.2);

    tooltipHPad = (9.0 * sf).clamp(7.0, 14.0);
    tooltipVPad = (5.0 * sf).clamp(4.0, 8.0);
    tooltipRadius = (5.0 * sf).clamp(4.0, 8.0);
    tooltipArrowH = (5.0 * sf).clamp(4.0, 8.0);
    tooltipArrowHW = (5.0 * sf).clamp(4.0, 8.0);
  }
}

class _ChartScaleCache {
  Size? _sz;
  _ChartScale? _sc;

  _ChartScale of(Size s) {
    if (_sz == s && _sc != null) return _sc!;
    _sc = _ChartScale(s);
    _sz = s;
    return _sc!;
  }
}

class _CurveSampleCache {
  BreakEvenChartData? data;
  double? anim;
  List<Offset>? samples;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CURVE MATH
// ═══════════════════════════════════════════════════════════════════════════════
//
// The curve is a smooth piecewise path that:
//   1. Starts at (xMinPct, yMin) — left edge, 50K baseline
//   2. Rises through (fixedCostX, fixedCostY) — API-supplied
//   3. Peaks at  (currentPointX, currentPointY) — API-supplied
//   4. Falls back to (xMaxPct, yMin) — right edge, 50K baseline
//
// We use a SUM of two half-gaussians to interpolate smoothly through all
// waypoints without solving a complex system:
//
//   Left half  [xMinPct .. currentPointX]:
//     A gaussian centered at currentPointX, width fitted so it passes
//     through (fixedCostX, fixedCostY) if fixedCostX < currentPointX,
//     otherwise fitted to reach yMin at xMinPct.
//
//   Right half [currentPointX .. xMaxPct]:
//     A gaussian centered at currentPointX, width fitted to reach yMin
//     at xMaxPct.
//
// This guarantees:
//   • curve = yMin at both edges (no open-path bug)
//   • curve = currentPointY at currentPointX (peak)
//   • curve passes through or very close to fixedCostY at fixedCostX
//

class _CurveFit {
  final double baseline; // yMin
  final double peakX; // currentPointX
  final double peakY; // currentPointY
  final double sigmaLeft; // controls left half width
  final double sigmaRight; // controls right half width

  const _CurveFit({
    required this.baseline,
    required this.peakX,
    required this.peakY,
    required this.sigmaLeft,
    required this.sigmaRight,
  });

  /// Compute curve value at [pct].
  double eval(double pct) {
    final amp = peakY - baseline;
    final sigma = pct <= peakX ? sigmaLeft : sigmaRight;
    return baseline + amp * math.exp(-0.5 * math.pow((pct - peakX) / sigma, 2));
  }

  /// Build a fit from the two API points.
  factory _CurveFit.fromData(BreakEvenChartData data) {
    final a = kDefaultAxisConfig;
    final baseline = a.yMin.toDouble();
    final peakX = data.currentPointX;
    final peakY = data.currentPointY;
    final fcX = data.fixedCostX;
    final fcY = data.fixedCostY;
    final amp = peakY - baseline;

    // Right sigma: fitted so curve reaches yMin at xMaxPct.
    // exp(-0.5*(span/sigma)^2) = epsilon  =>  sigma = span / sqrt(-2*ln(epsilon))
    const eps = 0.001; // fraction of amplitude at edge
    final rightSpan = (a.xMaxPct - peakX).abs();
    final sigmaRight = rightSpan / math.sqrt(-2.0 * math.log(eps));

    double sigmaLeft;
    if (fcX < peakX && amp > 0) {
      // Solve for sigmaLeft so curve passes through (fcX, fcY):
      // fcY = baseline + amp * exp(-0.5*((fcX-peakX)/sigmaLeft)^2)
      // => exp(...) = (fcY - baseline) / amp
      // => sigmaLeft = |fcX - peakX| / sqrt(-2 * ln(ratio))
      final ratio = ((fcY - baseline) / amp).clamp(eps, 1.0 - eps);
      final dx = (fcX - peakX).abs();
      sigmaLeft = dx / math.sqrt(-2.0 * math.log(ratio));
    } else {
      // fixedCost is to the right of peak or no valid constraint —
      // mirror the right sigma so the bell is symmetric.
      final leftSpan = (peakX - a.xMinPct).abs();
      sigmaLeft = leftSpan / math.sqrt(-2.0 * math.log(eps));
    }

    return _CurveFit(
      baseline: baseline,
      peakX: peakX,
      peakY: peakY,
      sigmaLeft: sigmaLeft.clamp(0.01, 5.0),
      sigmaRight: sigmaRight.clamp(0.01, 5.0),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CUSTOM PAINTER
// ═══════════════════════════════════════════════════════════════════════════════

class BreakEvenChartPainter extends CustomPainter {
  final BreakEvenChartData data;
  final double animationValue;
  final AxisConfig? viewportAxis;
  final CrosshairState crosshair;
  final _CurveSampleCache sampleCache;
  final _ChartScaleCache scaleCache;

  late final _CurveFit _fit;

  BreakEvenChartPainter({
    required this.data,
    required this.animationValue,
    required this.sampleCache,
    required this.scaleCache,
    this.viewportAxis,
    this.crosshair = CrosshairState.none,
  }) : _fit = _CurveFit.fromData(data);

  AxisConfig get _axis => viewportAxis ?? kDefaultAxisConfig;

  // ─── Coordinate helpers ───────────────────────────────────────────────────

  /// Sales value → Y pixel offset from top of plot area.
  /// Returns 0 at yMax (top), plotH at yMin (bottom).
  double _sy(double sales, double plotH) {
    final a = kDefaultAxisConfig;
    final t = ((sales - a.yMin) / (a.yMax - a.yMin)).clamp(0.0, 1.0);
    return plotH * (1.0 - t);
  }

  /// Data-space X percent → X pixel offset from left of plot area.
  double _px(double pct, double plotW) {
    final a = _axis;
    final span = a.xMaxPct - a.xMinPct;
    if (span.abs() < 1e-9) return 0;
    final t = (pct - a.xMinPct) / span;
    return (t * plotW).clamp(-plotW * 0.5, plotW * 1.5);
  }

  double _xToPct(double xInPlot, double plotW) {
    final a = _axis;
    final span = a.xMaxPct - a.xMinPct;
    return a.xMinPct + (xInPlot / plotW) * span;
  }

  // ─── Animated curve value at pct ─────────────────────────────────────────

  double _animVal(double pct) {
    final base = kDefaultAxisConfig.yMin.toDouble();
    final full = _fit.eval(pct);
    return base + (full - base) * animationValue;
  }

  // ─── Curve sample cache ───────────────────────────────────────────────────

  static const _kSteps = 200;

  List<Offset> _samples() {
    if (sampleCache.data == data &&
        sampleCache.anim == animationValue &&
        sampleCache.samples != null) {
      return sampleCache.samples!;
    }
    final a = kDefaultAxisConfig;
    final yMin = a.yMin.toDouble();
    final pts = <Offset>[];
    for (int i = 0; i <= _kSteps; i++) {
      final pct = a.xMinPct + (a.xMaxPct - a.xMinPct) * i / _kSteps;
      // Force the very first and last sample to exactly yMin so the curve
      // always starts and ends at the 50K baseline regardless of sigma precision.
      final y = (i == 0 || i == _kSteps) ? yMin : _animVal(pct);
      pts.add(Offset(pct, y));
    }
    sampleCache.data = data;
    sampleCache.anim = animationValue;
    sampleCache.samples = pts;
    return pts;
  }

  double _sampledValueAt(double pct) {
    final pts = _samples();
    final a = kDefaultAxisConfig;
    final span = a.xMaxPct - a.xMinPct;
    if (span.abs() < 1e-9) return pts.first.dy;
    final t = ((pct - a.xMinPct) / span * _kSteps).clamp(
      0.0,
      _kSteps.toDouble(),
    );
    final i0 = t.floor().clamp(0, _kSteps);
    final i1 = (i0 + 1).clamp(0, _kSteps);
    return pts[i0].dy + (pts[i1].dy - pts[i0].dy) * (t - i0);
  }

  // ─── Main paint ───────────────────────────────────────────────────────────

  @override
  void paint(Canvas canvas, Size size) {
    final sc = scaleCache.of(size);

    // Background
    canvas.drawRect(
      Rect.fromLTWH(sc.plotL, sc.plotT, sc.plotW, sc.plotH),
      Paint()..color = const Color(0xFFF9F9F9),
    );

    // Clipped: area fill + curve stroke
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(sc.plotL, sc.plotT, sc.plotW, sc.plotH));
    _paintAreaFill(canvas, sc);
    _paintCurveStroke(canvas, sc);
    canvas.restore();

    // Solid axes
    final axisPaint = Paint()
      ..color = const Color(0xFFBBBBBB)
      ..strokeWidth = (1.5 * sc.canvasSize.width / 360.0).clamp(1.0, 2.2)
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(sc.plotL, sc.plotT + sc.plotH),
      Offset(sc.plotL + sc.plotW, sc.plotT + sc.plotH),
      axisPaint,
    );
    canvas.drawLine(
      Offset(sc.plotL, sc.plotT),
      Offset(sc.plotL, sc.plotT + sc.plotH),
      axisPaint,
    );

    // Zone lines + labels (clipped to plot area)
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(sc.plotL, sc.plotT, sc.plotW, sc.plotH));
    _paintZoneLinesAndLabels(canvas, sc);
    canvas.restore();

    _paintYAxisLabels(canvas, sc);
    _paintXAxisLabels(canvas, sc);
    _paintAxisTitle(canvas, size, sc);
    _paintFixedCostMarker(canvas, sc);
    _paintCurrentSalesMarker(canvas, sc);

    if (crosshair.isActive) _paintCrosshair(canvas, sc, crosshair.pct!);
  }

  // ─── Area fill ────────────────────────────────────────────────────────────

  void _paintAreaFill(Canvas canvas, _ChartScale sc) {
    final pts = _samples();
    final path = Path();
    final bottomY = sc.plotT + sc.plotH; // absolute Y of the 50K baseline

    // Bottom-left corner: always the left edge of the plot area at yMin (50K)
    path.moveTo(sc.plotL, bottomY);

    // Draw the curve from left to right
    for (final s in pts) {
      path.lineTo(
        sc.plotL + _px(s.dx, sc.plotW),
        sc.plotT + _sy(s.dy, sc.plotH),
      );
    }

    // Bottom-right corner: always the right edge of the plot area at yMin (50K)
    path.lineTo(sc.plotL + sc.plotW, bottomY);
    path.close();

    final ac = data.status.areaColor;
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ac.withOpacity(0.55),
            ac.withOpacity(0.22),
            ac.withOpacity(0.05),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromLTWH(sc.plotL, sc.plotT, sc.plotW, sc.plotH))
        ..style = PaintingStyle.fill,
    );
  }

  // ─── Curve stroke ─────────────────────────────────────────────────────────

  void _paintCurveStroke(Canvas canvas, _ChartScale sc) {
    final pts = _samples();
    final path = Path();
    final yMin = kDefaultAxisConfig.yMin.toDouble();
    final bottomY = sc.plotT + sc.plotH; // y pixel for 50K

    // Begin at the left edge of the plot at the 50K baseline
    path.moveTo(sc.plotL, bottomY);

    for (final s in pts) {
      path.lineTo(
        sc.plotL + _px(s.dx, sc.plotW),
        sc.plotT + _sy(s.dy, sc.plotH),
      );
    }

    // End at the right edge of the plot at the 50K baseline
    path.lineTo(sc.plotL + sc.plotW, bottomY);

    // Glow pass
    canvas.drawPath(
      path,
      Paint()
        ..color = data.status.areaColor.withOpacity(0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sc.curveStrokeWidth * 2.8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Crisp stroke
    canvas.drawPath(
      path,
      Paint()
        ..color = data.status.areaColor.withOpacity(0.92)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sc.curveStrokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  // ─── Zone lines + labels ──────────────────────────────────────────────────

  void _paintZoneLinesAndLabels(Canvas canvas, _ChartScale sc) {
    for (final band in kDefaultZoneBands.ordered) {
      final lPx = sc.plotT + _sy(band.lowerBoundary, sc.plotH);
      final uPx = sc.plotT + _sy(band.upperBoundary, sc.plotH);
      if (lPx - uPx < 2) continue;

      if (lPx >= sc.plotT - 0.5 && lPx <= sc.plotT + sc.plotH + 0.5)
        _dashedHLine(
          canvas,
          sc.plotL,
          sc.plotL + sc.plotW,
          lPx,
          band.lowerLineColor,
          sc.zoneLineWidth,
          sc,
        );

      if (band.drawUpperLine &&
          uPx >= sc.plotT - 0.5 &&
          uPx <= sc.plotT + sc.plotH + 0.5)
        _dashedHLine(
          canvas,
          sc.plotL,
          sc.plotL + sc.plotW,
          uPx,
          band.upperLineColor,
          sc.zoneLineWidth,
          sc,
        );

      final visL = lPx.clamp(sc.plotT, sc.plotT + sc.plotH);
      final visU = uPx.clamp(sc.plotT, sc.plotT + sc.plotH);
      final visH = visL - visU;
      if (visH < 4) continue;

      final tp = TextPainter(
        text: TextSpan(
          text: band.labelText,
          style: TextStyle(
            color: band.labelColor.withOpacity(0.82),
            fontSize: sc.zoneLabelFontSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: sc.plotW * 0.65);

      final mid = (visL + visU) / 2;
      final top = (mid - tp.height / 2).clamp(
        sc.plotT + 1.0,
        sc.plotT + sc.plotH - tp.height - 1.0,
      );
      tp.paint(canvas, Offset(sc.plotL + 6.0, top));
    }
  }

  // ─── Y-axis labels ────────────────────────────────────────────────────────

  void _paintYAxisLabels(Canvas canvas, _ChartScale sc) {
    final a = kDefaultAxisConfig;
    final tick = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = sc.tickWidth;
    final minGap = sc.axisLabelFontSize + 3.0;
    final steps = ((a.yMax - a.yMin) / a.yStep).round();
    double lastY = double.infinity;

    for (int i = 0; i <= steps; i++) {
      final v = a.yMin + a.yStep * i;
      if (v > a.yMax + 0.5) continue;
      final y = sc.plotT + _sy(v, sc.plotH);
      if (y < sc.plotT || y > sc.plotT + sc.plotH + 0.5) continue;
      if ((y - lastY).abs() < minGap && lastY != double.infinity) continue;
      lastY = y;

      canvas.drawLine(Offset(sc.plotL - 4, y), Offset(sc.plotL, y), tick);

      final vInt = v.round();
      final label = vInt >= 1000 ? 'SAR ${(vInt ~/ 1000)}k' : 'SAR $vInt';
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: const Color(0xFF9A9A9A),
            fontSize: sc.axisLabelFontSize,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final lx = (sc.plotL - tp.width - 6).clamp(0.0, sc.plotL - 2.0);
      final ly = (y - tp.height / 2).clamp(
        0.0,
        sc.canvasSize.height - tp.height,
      );
      tp.paint(canvas, Offset(lx, ly));
    }
  }

  // ─── X-axis labels ────────────────────────────────────────────────────────

  void _paintXAxisLabels(Canvas canvas, _ChartScale sc) {
    final a = _axis;
    final span = a.xMaxPct - a.xMinPct;
    const nice = [0.05, 0.10, 0.20, 0.25, 0.50];
    double step = nice.last;
    for (final n in nice) {
      if (n >= span / 8) {
        step = n;
        break;
      }
    }

    final tick = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = sc.tickWidth;
    final sample = TextPainter(
      text: TextSpan(
        text: '-50%',
        style: TextStyle(fontSize: sc.axisLabelFontSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final minGap = sample.width + 4.0;
    final yBot = sc.plotT + sc.plotH;
    double lastX = -double.infinity;

    final first = (a.xMinPct / step).ceil() * step;
    for (double p = first; p <= a.xMaxPct + 1e-9; p += step) {
      final r = double.parse(p.toStringAsFixed(4));
      if (r < a.xMinPct - 1e-9 || r > a.xMaxPct + 1e-9) continue;
      final x = sc.plotL + _px(r, sc.plotW);
      if (x - lastX < minGap && lastX != -double.infinity) continue;

      canvas.drawLine(Offset(x, yBot), Offset(x, yBot + 4), tick);

      final pInt = (r * 100).round();
      final str = pInt > 0 ? '+$pInt%' : '$pInt%';
      final tp = TextPainter(
        text: TextSpan(
          text: str,
          style: TextStyle(
            color: const Color(0xFF9A9A9A),
            fontSize: sc.axisLabelFontSize,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final lx = (x - tp.width / 2).clamp(
        sc.plotL,
        sc.plotL + sc.plotW - tp.width,
      );
      tp.paint(canvas, Offset(lx, yBot + 6));
      lastX = x;
    }
  }

  // ─── Axis title ───────────────────────────────────────────────────────────

  void _paintAxisTitle(Canvas canvas, Size size, _ChartScale sc) {
    final tp = TextPainter(
      text: TextSpan(
        text: 'Sales Change %',
        style: TextStyle(
          color: const Color(0xFF888888),
          fontSize: sc.axisTitleFontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: sc.plotW);

    final y = (sc.plotT + sc.plotH + 30.0 * sc.canvasSize.height / 220.0).clamp(
      sc.plotT + sc.plotH + 20.0,
      size.height - 2.0,
    );
    tp.paint(canvas, Offset(sc.plotL + sc.plotW / 2 - tp.width / 2, y));
  }

  // ─── Fixed cost marker ────────────────────────────────────────────────────
  //
  // The dot is placed at (fixedCostX, curve value at fixedCostX) so it
  // always sits ON the curve line visually, because the curve was fitted
  // to pass through (fixedCostX, fixedCostY).

  void _paintFixedCostMarker(Canvas canvas, _ChartScale sc) {
    final pct = data.fixedCostX;
    if (pct < _axis.xMinPct || pct > _axis.xMaxPct) return;

    final mx = sc.plotL + _px(pct, sc.plotW);
    // Use animated curve value — curve passes through fixedCostY at fixedCostX
    final curveVal = _animVal(pct);
    final my = (sc.plotT + _sy(curveVal, sc.plotH)).clamp(
      sc.plotT,
      sc.plotT + sc.plotH,
    );

    // Halo + purple dot
    canvas.drawCircle(
      Offset(mx, my),
      sc.dotRadius + 2,
      Paint()..color = const Color(0xFF7B5EA7).withOpacity(0.18),
    );
    canvas.drawCircle(
      Offset(mx, my),
      sc.dotRadius - 0.5,
      Paint()..color = const Color(0xFF7B5EA7),
    );
    canvas.drawCircle(
      Offset(mx, my),
      sc.dotRadius - 0.5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = sc.dotStrokeWidth * 0.85,
    );
    canvas.drawCircle(
      Offset(mx, my),
      sc.dotInnerRadius,
      Paint()..color = Colors.white,
    );

    // Floating card
    final label = 'Fixed Cost  SAR ${_fmt(data.fixedCostY.toInt())}';
    final fs = sc.markerLabelFontSize;
    final tp =
        TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: const Color(0xFF444444),
              fontSize: fs,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(
          maxWidth: (sc.plotW - _px(pct, sc.plotW) - 12).clamp(60.0, 200.0),
        );

    const hPad = 7.0, vPad = 4.0, r = 5.0;
    final cW = tp.width + hPad * 2;
    final cH = tp.height + vPad * 2;
    double cX = (mx + sc.dotRadius + 6).clamp(
      sc.plotL + 2,
      sc.plotL + sc.plotW - cW - 2,
    );
    double cY = (my - cH / 2).clamp(sc.plotT + 2, sc.plotT + sc.plotH - cH - 2);

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cX, cY, cW, cH),
      const Radius.circular(r),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cX + 1, cY + 2, cW, cH),
        const Radius.circular(r),
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawRRect(rect, Paint()..color = Colors.white);
    canvas.drawRRect(
      rect,
      Paint()
        ..color = const Color(0xFFDDDDDD)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    tp.paint(canvas, Offset(cX + hPad, cY + vPad));
  }

  // ─── Current sales marker ─────────────────────────────────────────────────
  //
  // The dot is placed at (currentPointX, curve peak) — the curve peaks here.

  void _paintCurrentSalesMarker(Canvas canvas, _ChartScale sc) {
    final pct = data.currentPointX;
    if (pct < _axis.xMinPct || pct > _axis.xMaxPct) return;

    final px = sc.plotL + _px(pct, sc.plotW);
    // Curve peaks at currentPointX — _animVal returns the animated peak value
    final curveVal = _animVal(pct);
    final py = (sc.plotT + _sy(curveVal, sc.plotH)).clamp(
      sc.plotT + sc.dotRadius + 2,
      sc.plotT + sc.plotH - sc.dotRadius - 2,
    );

    final dotColor = data.status.color;

    _dashedVLine(
      canvas,
      px,
      py + sc.dotRadius + 2,
      sc.plotT + sc.plotH,
      const Color(0xFFAAAAAA),
      sc.dashedLineWidth,
      sc,
    );

    canvas.drawCircle(
      Offset(px, py),
      sc.dotGlowRadius,
      Paint()..color = dotColor.withOpacity(0.20),
    );
    canvas.drawCircle(Offset(px, py), sc.dotRadius, Paint()..color = dotColor);
    canvas.drawCircle(
      Offset(px, py),
      sc.dotRadius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = sc.dotStrokeWidth,
    );
    canvas.drawCircle(
      Offset(px, py),
      sc.dotInnerRadius,
      Paint()..color = Colors.white,
    );

    if (animationValue > 0.4 && !crosshair.isActive) {
      final opacity = ((animationValue - 0.4) / 0.6).clamp(0.0, 1.0);
      _paintTooltip(
        canvas,
        px,
        py,
        'Current',
        data.currentPointY.toInt(),
        dotColor,
        opacity,
        sc,
      );
    }
  }

  // ─── Crosshair ────────────────────────────────────────────────────────────

  void _paintCrosshair(Canvas canvas, _ChartScale sc, double pct) {
    final cp = pct.clamp(_axis.xMinPct, _axis.xMaxPct);
    final v = _sampledValueAt(cp);
    final px = sc.plotL + _px(cp, sc.plotW);
    final py = (sc.plotT + _sy(v, sc.plotH)).clamp(
      sc.plotT,
      sc.plotT + sc.plotH,
    );

    canvas.drawLine(
      Offset(px, sc.plotT),
      Offset(px, sc.plotT + sc.plotH),
      Paint()
        ..color = const Color(0xFF555555).withOpacity(0.50)
        ..strokeWidth = sc.dashedLineWidth * 1.4,
    );

    const ring = Color(0xFF2C2C2C);
    canvas.drawCircle(
      Offset(px, py),
      sc.dotGlowRadius * 0.9,
      Paint()..color = ring.withOpacity(0.15),
    );
    canvas.drawCircle(
      Offset(px, py),
      sc.dotRadius * 0.85,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(px, py),
      sc.dotRadius * 0.85,
      Paint()
        ..color = ring
        ..style = PaintingStyle.stroke
        ..strokeWidth = sc.dotStrokeWidth,
    );

    final lbl = cp >= 0 ? '+${(cp * 100).round()}%' : '${(cp * 100).round()}%';
    _paintTooltip(
      canvas,
      px,
      py,
      lbl,
      v.toInt(),
      ring,
      1.0,
      sc,
      forceAbove: py > sc.plotT + sc.plotH * 0.5,
    );
  }

  // ─── Tooltip ─────────────────────────────────────────────────────────────

  void _paintTooltip(
    Canvas canvas,
    double x,
    double y,
    String prefix,
    int sales,
    Color color,
    double opacity,
    _ChartScale sc, {
    bool? forceAbove,
  }) {
    final label = '$prefix ···· SAR ${_fmt(sales)}';
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white.withOpacity(opacity),
          fontSize: sc.tooltipFontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final bw = tp.width + sc.tooltipHPad * 2;
    final bh = tp.height + sc.tooltipVPad * 2;
    final flip = forceAbove != null
        ? !forceAbove
        : (y - bh - sc.dotGlowRadius - sc.tooltipArrowH < sc.plotT + 4);
    double bx = (x - bw / 2).clamp(sc.plotL, sc.plotL + sc.plotW - bw);
    double by = flip
        ? y + sc.dotGlowRadius + sc.tooltipArrowH
        : y - bh - sc.dotGlowRadius - sc.tooltipArrowH;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bx + 1, by + 1, bw, bh),
        Radius.circular(sc.tooltipRadius),
      ),
      Paint()..color = Colors.black.withOpacity(0.15 * opacity),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bx, by, bw, bh),
        Radius.circular(sc.tooltipRadius),
      ),
      Paint()
        ..color = Color.lerp(
          Colors.transparent,
          const Color(0xFF2C2C2C),
          opacity,
        )!,
    );
    tp.paint(canvas, Offset(bx + sc.tooltipHPad, by + sc.tooltipVPad));

    final tY1 = flip ? by : by + bh;
    final tY2 = flip ? by - sc.tooltipArrowH : by + bh + sc.tooltipArrowH;
    final aX = x.clamp(
      bx + sc.tooltipArrowHW + 2,
      bx + bw - sc.tooltipArrowHW - 2,
    );
    canvas.drawPath(
      Path()
        ..moveTo(aX - sc.tooltipArrowHW, tY1)
        ..lineTo(aX + sc.tooltipArrowHW, tY1)
        ..lineTo(aX, tY2)
        ..close(),
      Paint()
        ..color = Color.lerp(
          Colors.transparent,
          const Color(0xFF2C2C2C),
          opacity,
        )!,
    );
  }

  // ─── Dashed lines ─────────────────────────────────────────────────────────

  void _dashedHLine(
    Canvas canvas,
    double x1,
    double x2,
    double y,
    Color color,
    double sw,
    _ChartScale sc,
  ) {
    if (color == Colors.transparent) return;
    final dash = (6.0 * sc.canvasSize.width / 360.0).clamp(4.0, 10.0);
    final gap = (4.0 * sc.canvasSize.width / 360.0).clamp(3.0, 7.0);
    final p = Paint()
      ..color = color
      ..strokeWidth = sw
      ..style = PaintingStyle.stroke;
    double x = x1;
    bool on = true;
    while (x < x2) {
      final seg = on ? math.min(dash, x2 - x) : math.min(gap, x2 - x);
      if (on) canvas.drawLine(Offset(x, y), Offset(x + seg, y), p);
      x += seg;
      on = !on;
    }
  }

  void _dashedVLine(
    Canvas canvas,
    double x,
    double y1,
    double y2,
    Color color,
    double sw,
    _ChartScale sc,
  ) {
    final dash = (6.0 * sc.canvasSize.width / 360.0).clamp(4.0, 10.0);
    final gap = (4.0 * sc.canvasSize.width / 360.0).clamp(3.0, 7.0);
    final p = Paint()
      ..color = color
      ..strokeWidth = sw
      ..style = PaintingStyle.stroke;
    double y = y1;
    bool on = true;
    while (y < y2) {
      final seg = on ? math.min(dash, y2 - y) : math.min(gap, y2 - y);
      if (on) canvas.drawLine(Offset(x, y), Offset(x, y + seg), p);
      y += seg;
      on = !on;
    }
  }

  // ─── Number formatting ────────────────────────────────────────────────────

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n < 1000) return '$n';
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  bool shouldRepaint(BreakEvenChartPainter old) =>
      old.data != data ||
      old.animationValue != animationValue ||
      old.crosshair.pct != crosshair.pct ||
      old.viewportAxis?.xMinPct != viewportAxis?.xMinPct ||
      old.viewportAxis?.xMaxPct != viewportAxis?.xMaxPct;

  double? hitTestPct(Offset local, Size size) {
    final sc = scaleCache.of(size);
    if (local.dx < sc.plotL || local.dx > sc.plotL + sc.plotW) return null;
    return _xToPct(
      local.dx - sc.plotL,
      sc.plotW,
    ).clamp(_axis.xMinPct, _axis.xMaxPct);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// LEGEND
// ═══════════════════════════════════════════════════════════════════════════════

class _ChartLegend extends StatelessWidget {
  final double fontSize;

  const _ChartLegend({this.fontSize = 10.5});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: kDefaultZoneBands.ordered
          .map(
            (band) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: band.legendSwatchColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  band.legendText,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: const Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CHART WIDGET
// ═══════════════════════════════════════════════════════════════════════════════

class BreakEvenChart extends StatefulWidget {
  final BreakEvenChartData data;
  final double? height;
  final bool showLegend;
  final bool enableZoom;
  final bool enableInspect;

  const BreakEvenChart({
    super.key,
    required this.data,
    this.height,
    this.showLegend = true,
    this.enableZoom = true,
    this.enableInspect = true,
  });

  @override
  State<BreakEvenChart> createState() => _BreakEvenChartState();
}

class _BreakEvenChartState extends State<BreakEvenChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;
  late ChartViewport _viewport;
  final ValueNotifier<CrosshairState> _crosshair = ValueNotifier(
    CrosshairState.none,
  );

  BreakEvenChartPainter? _lastPainter;
  Size _lastSize = Size.zero;
  final _ChartScaleCache _scaleCache = _ChartScaleCache();
  final _CurveSampleCache _sampleCache = _CurveSampleCache();
  double _zoomStartScale = 1.0;
  double _zoomFocalPct = 0.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
    _viewport = ChartViewport();
  }

  @override
  void didUpdateWidget(BreakEvenChart old) {
    super.didUpdateWidget(old);
    if (old.data != widget.data) {
      _ctrl
        ..reset()
        ..forward();
      _viewport.dispose();
      _viewport = ChartViewport();
      _crosshair.value = CrosshairState.none;
      _sampleCache.data = null;
      _sampleCache.samples = null;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _viewport.dispose();
    _crosshair.dispose();
    super.dispose();
  }

  void _updateCrosshair(Offset local, Size size) {
    final pct = _lastPainter?.hitTestPct(local, size);
    if (pct != null) _crosshair.value = CrosshairState(pct: pct);
  }

  void _clearCrosshair() {
    if (_crosshair.value.isActive) _crosshair.value = CrosshairState.none;
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;
    final chartH = widget.height ?? (screenH * 0.30).clamp(180.0, 340.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: chartH,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);

                Widget canvas = AnimatedBuilder(
                  animation: Listenable.merge([_anim, _viewport, _crosshair]),
                  builder: (_, __) {
                    final painter = BreakEvenChartPainter(
                      data: widget.data,
                      animationValue: _anim.value,
                      sampleCache: _sampleCache,
                      scaleCache: _scaleCache,
                      viewportAxis: widget.enableZoom
                          ? _viewport.effectiveAxis()
                          : null,
                      crosshair: _crosshair.value,
                    );
                    _lastPainter = painter;
                    _lastSize = size;
                    return RepaintBoundary(
                      child: CustomPaint(painter: painter, size: size),
                    );
                  },
                );

                if (!widget.enableInspect && !widget.enableZoom) return canvas;

                return Listener(
                  onPointerSignal: (ev) {
                    if (!widget.enableZoom || ev is! PointerScrollEvent) return;
                    final pct =
                        _lastPainter?.hitTestPct(ev.localPosition, _lastSize) ??
                        0.0;
                    _viewport.zoomBy(
                      math.exp(-ev.scrollDelta.dy * 0.0015),
                      pct,
                    );
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onDoubleTap: widget.enableZoom ? _viewport.reset : null,
                    onScaleStart: (d) {
                      _zoomStartScale = _viewport.value.zoom;
                      _zoomFocalPct =
                          _lastPainter?.hitTestPct(d.localFocalPoint, size) ??
                          0.0;
                      if (widget.enableInspect && d.pointerCount == 1)
                        _updateCrosshair(d.localFocalPoint, size);
                    },
                    onScaleUpdate: (d) {
                      if (d.pointerCount > 1) {
                        _clearCrosshair();
                        if (!widget.enableZoom) return;
                        final target = (_zoomStartScale * d.scale).clamp(
                          ChartViewport.minZoom,
                          ChartViewport.maxZoom,
                        );
                        _viewport.zoomBy(
                          target / _viewport.value.zoom,
                          _zoomFocalPct,
                        );
                      } else if (widget.enableInspect) {
                        _updateCrosshair(d.localFocalPoint, size);
                      } else if (widget.enableZoom &&
                          _viewport.value.zoom > ChartViewport.minZoom) {
                        final sc = _scaleCache.of(size);
                        final ax = _viewport.effectiveAxis();
                        final pctPerPx = (ax.xMaxPct - ax.xMinPct) / sc.plotW;
                        _viewport.panBy(-d.focalPointDelta.dx * pctPerPx);
                      }
                    },
                    onScaleEnd: widget.enableInspect
                        ? (_) => _clearCrosshair()
                        : null,
                    child: canvas,
                  ),
                );
              },
            ),
          ),
          if (widget.showLegend)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
              child: _ChartLegend(fontSize: 10.5),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Center(
              child: Container(
                width: 36,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED UI HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

String formatSalesValue(double v) {
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
  if (v >= 1000) {
    final s = v.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
  return v.toInt().toString();
}

Widget statusChip(BranchStatus status) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: status.color.withOpacity(0.13),
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: status.color.withOpacity(0.35)),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(status.icon, size: 12, color: status.color),
      const SizedBox(width: 4),
      Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  ),
);
