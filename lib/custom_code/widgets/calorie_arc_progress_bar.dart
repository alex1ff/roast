// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Imports other custom widgets

import 'dart:math' as math;

/// Цвета макро (как в MacroProgressBar) — вынесены на уровень файла
const Map<String, Color> _macroColors = {
  'protein': Color(0xFF80BFB4), // Opaque teal‑green
  'fats': Color(0xFFEE8B60), // Opaque orange‑brown
  'carbs': Color(0xFF9F4284), // Opaque purple
};

class CalorieArcProgressBar extends StatefulWidget {
  const CalorieArcProgressBar({
    super.key,
    this.width,
    this.height,
    this.carbs,
    this.protein,
    this.kkcal,
    this.fats,
    required this.text,
    this.strokeWidth = 15.0,
    this.duration = const Duration(milliseconds: 900),
    this.startAngle = 180,
  });

  final double? width;
  final double? height;
  final int? carbs;
  final int? protein;
  final int? kkcal;
  final int? fats;
  final double strokeWidth;
  final Duration duration;
  final double startAngle;
  final String text;

  @override
  State<CalorieArcProgressBar> createState() => _CalorieArcProgressBarState();
}

class _CalorieArcProgressBarState extends State<CalorieArcProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CalorieArcProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.protein != widget.protein ||
        oldWidget.fats != widget.fats ||
        oldWidget.carbs != widget.carbs) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Берём желаемую ширину; если указана только высота, считаем,
    // что полукруг должен занимать удвоенную высоту.
    final double width =
        widget.width ?? ((widget.height != null) ? widget.height! * 2 : 150.0);

    // Радиус окружности — половина ширины минус половина толщины дуги.
    final double radius = (width - widget.strokeWidth) / 2;
    // Реальная высота виджета = радиус + половина толщины дуги.
    final double widgetHeight = radius + widget.strokeWidth / 2;

    return SizedBox(
      width: width,
      height: widgetHeight,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: [
            // Рисуем только полукруг, центр окружности смещён вниз,
            // поэтому ничего не «обрезается» и не уезжает.
            CustomPaint(
              size: Size(width, widgetHeight),
              painter: _MacroRingPainter(
                progress: _animation.value,
                strokeWidth: widget.strokeWidth,
                // startAngle = 180° (по‑умолчанию) даёт полукруг снизу.
                startAngle: widget.startAngle,
                protein: widget.protein ?? 0,
                fats: widget.fats ?? 0,
                carbs: widget.carbs ?? 0,
              ),
            ),
            if (widget.kkcal != null)
// ── ВЫРЕЖЬТЕ старый Positioned(...) целиком и вставьте этот ──
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  // доступная высота: половина круга минус толщина дуги
                  height: (width / 2) - widget.strokeWidth,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      // лёгкий отступ сверху, чтобы «143» опустился чуть ниже
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.kkcal}',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  // уменьшили межстрочный интервал
                                  height: 1,
                                  // при желании подберите размер под дизайн
                                  fontSize: 16,
                                ),
                          ),
                          // минимальный зазор между «143» и «kcal»
                          const SizedBox(height: 2),
                          Text(
                            '${widget.text}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .copyWith(
                                  height: 1,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Painter
class _MacroRingPainter extends CustomPainter {
  _MacroRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.startAngle,
    required this.protein,
    required this.fats,
    required this.carbs,
  });

  final double progress;
  final double strokeWidth;
  final double startAngle;
  final int protein;
  final int fats;
  final int carbs;

  double get _proteinCal => protein * 4.0;
  double get _carbCal => carbs * 4.0;
  double get _fatCal => fats * 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final totalCal = _proteinCal + _carbCal + _fatCal;
    if (totalCal == 0) return;

    // Центр окружности смещаем вниз так, чтобы нижняя точка
    // дуги совпала с нижней границей виджета.
    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height - strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Серый трек
    final trackPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      rect,
      _deg2rad(startAngle),
      math.pi,
      false,
      trackPaint,
    );

    final segments = <_Segment>[
      _Segment(_proteinCal / totalCal, _macroColors['protein']!),
      _Segment(_fatCal / totalCal, _macroColors['fats']!),
      _Segment(_carbCal / totalCal, _macroColors['carbs']!),
    ];

    double currentStart = _deg2rad(startAngle);
    double remaining = progress.clamp(0.0, 1.0);

    for (final seg in segments) {
      final sweep = math.min(remaining, seg.fraction) * math.pi;
      if (sweep > 0) {
        final paint = Paint()
          ..color = seg.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt;
        canvas.drawArc(rect, currentStart, sweep, false, paint);
      }
      currentStart += seg.fraction * math.pi;
      remaining = (remaining - seg.fraction).clamp(0.0, 1.0);
    }
  }

  @override
  bool shouldRepaint(covariant _MacroRingPainter old) =>
      old.progress != progress ||
      old.protein != protein ||
      old.fats != fats ||
      old.carbs != carbs ||
      old.strokeWidth != strokeWidth ||
      old.startAngle != startAngle;

  double _deg2rad(double deg) => deg * math.pi / 180;
}

class _Segment {
  const _Segment(this.fraction, this.color);
  final double fraction;
  final Color color;
}
