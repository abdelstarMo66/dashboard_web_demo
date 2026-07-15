import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/dashboard_data.dart';

class KpiCard extends StatefulWidget {
  final KpiData data;
  final int index;

  const KpiCard({super.key, required this.data, required this.index});

  @override
  State<KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<KpiCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _countAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200 + widget.index * 150),
    );
    _countAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _accentColor {
    if (!widget.data.isPositive) return AppColors.danger;
    switch (widget.index) {
      case 0:
        return AppColors.accent;
      case 1:
        return AppColors.success;
      case 2:
        return const Color(0xFF06B6D4);
      default:
        return AppColors.warning;
    }
  }

  Color get _softColor {
    if (!widget.data.isPositive) return AppColors.dangerSoft;
    switch (widget.index) {
      case 0:
        return AppColors.accentSoft;
      case 1:
        return AppColors.successSoft;
      case 2:
        return const Color(0x2206B6D4);
      default:
        return AppColors.warningSoft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _softColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.data.icon,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.data.isPositive
                      ? AppColors.successSoft
                      : AppColors.dangerSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.data.isPositive
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 11,
                      color: widget.data.isPositive
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${widget.data.changePercent}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: widget.data.isPositive
                            ? AppColors.success
                            : AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Animated counter
          AnimatedBuilder(
            animation: _countAnim,
            builder: (_, __) {
              final current = widget.data.value * _countAnim.value;
              final display = widget.data.formatted.contains('K')
                  ? '\$${(current / 1000).toStringAsFixed(1)}K'
                  : current.toInt().toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (m) => '${m[1]},',
                    );
              return Text(
                display,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  fontFamily: 'Inter',
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            widget.data.label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Sparkline
          SizedBox(
            height: 36,
            child: CustomPaint(
              size: const Size(double.infinity, 36),
              painter: _SparklinePainter(
                data: widget.data.sparkline,
                color: _accentColor,
                progress: _countAnim.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double progress;

  _SparklinePainter({
    required this.data,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final min = data.reduce((a, b) => a < b ? a : b);
    final max = data.reduce((a, b) => a > b ? a : b);
    final range = max - min == 0 ? 1 : max - min;

    final points = List.generate(data.length, (i) {
      final x = i / (data.length - 1) * size.width;
      final y =
          size.height -
          ((data[i] - min) / range * size.height * 0.85 + size.height * 0.075);
      return Offset(x, y);
    });

    final visibleCount = (points.length * progress).ceil().clamp(
      1,
      points.length,
    );
    final visiblePoints = points.sublist(0, visibleCount);

    // Fill
    final fillPath = Path()..moveTo(visiblePoints.first.dx, size.height);
    for (final p in visiblePoints) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(visiblePoints.last.dx, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.25), color.withOpacity(0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line
    final linePath = Path()
      ..moveTo(visiblePoints.first.dx, visiblePoints.first.dy);
    for (int i = 1; i < visiblePoints.length; i++) {
      final p0 = visiblePoints[i - 1];
      final p1 = visiblePoints[i];
      final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      linePath.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    linePath.lineTo(visiblePoints.last.dx, visiblePoints.last.dy);

    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Dot at end
    if (visiblePoints.isNotEmpty) {
      canvas.drawCircle(visiblePoints.last, 3, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => old.progress != progress;
}
